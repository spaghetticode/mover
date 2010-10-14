require 'rubygems'
require 'wx'
require 'movable_file'
require 'mover'
include Wx

class ReportFrame < Frame
  def initialize(parent, moved, not_moved)
    super(parent, -1, 'Report', :size => Size.new(300,200))
    panel = Panel.new self
    sizer = BoxSizer.new(VERTICAL)
    panel.sizer = sizer
    moved_caption = StaticText.new panel, :label => 'Ho spostato i seguenti files:'
    not_moved_caption = StaticText.new panel, :label => 'Non ho trovato i seguenti files:'
    not_moved_box = TextCtrl.new panel, -1, not_moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    moved_box = TextCtrl.new panel, -1, moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    sizer.add not_moved_caption, 0
    sizer.add not_moved_box, 1, GROW|ALL, 10
    sizer.add moved_caption, 0
    sizer.add moved_box, 1, GROW|ALL, 10
  end
end

class CopierFrame < Frame
  def initialize
    super(nil, -1, 'Sposta files', :size => Size.new(450, 450))
    AppConfig.path = File.join(get_home_dir, 'file_mover.yml')
    @panel = Panel.new self
    
    @caption = StaticText.new @panel, :label => 'Copia qui i nomi dei files da spostare:'
    @files = TextCtrl.new @panel, -1, '', DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    
    @source = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @source.value = AppConfig.source_dir if AppConfig.source_dir
    @source_button = Button.new(@panel, -1, 'directory origine')
    evt_button(@source_button.id) {|e| on_source_button(e)}
    
    @first_dest = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @first_dest.value = AppConfig.target_dir if AppConfig.target_dir
    @first_button = Button.new(@panel, -1, 'prima directory destinazione')
    evt_button(@first_button.id) {|e| on_first_choose_button(e)}
    
    @second_dest = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @second_dest.value = AppConfig.second_target_dir if AppConfig.second_target_dir
    @second_button = Button.new(@panel, -1, 'seconda directory destinazione')
    evt_button(@second_button.id) {|e| on_second_choose_button(e)}
    
    @submit_button = Button.new(@panel, -1, 'sposta')
    evt_button(@submit_button.id) {|e| on_submit_button(e)}
    
    @sizer = BoxSizer.new(VERTICAL)
    @panel.sizer = @sizer
    
    @sizer.add @caption, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @files, 1, GROW|ALL, 10
    
    @sizer.add @source, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @source_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
        
    @sizer.add @first_dest, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @first_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
    
    @sizer.add @second_dest, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @second_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
    
    @sizer.add @submit_button, 0, ALIGN_CENTER|ALL, 10
  end
  
  def on_source_button(event)
    dir_home = AppConfig.source_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di origine", dir_home)
    @source.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_first_choose_button(event)
    dir_home = AppConfig.target_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    @first_dest.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_second_choose_button(event)
    dir_home = AppConfig.second_target_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    @second_dest.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_submit_button(event)
    if @source.value.empty? || @first_dest.value.empty? || @files.value.empty?
      log_message "Devi fornire tutti i dati obbligatori:\ncartella sorgente, destinazione, e file da copiare"
    else
      files = FileAdapter.convert(@files.value)
      copier = Mover.new(files, @source.value, @first_dest.value, @second_dest.value)
      copier.mv
      AppConfig.save(@source.value, @first_dest.value, @second_dest.value)
      moved = copier.moved.join("\n")
      not_moved = copier.not_moved.join("\n")
      ReportFrame.new(self, moved, not_moved).show
    end
  end
end

class MoverApp < App
  def on_init
    CopierFrame.new.show
  end
end

MoverApp.new.main_loop