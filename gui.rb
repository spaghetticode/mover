require 'rubygems'
require 'wx'
require 'movable_file'
require 'mover'
include Wx

class CopierFrame < Frame
  def initialize
    super(nil, -1, 'Sposta file', :size => Size.new(450, 450))
    @panel = Panel.new self
    
    @caption = StaticText.new @panel, :label => 'Copia qui i nomi dei file'
    @files = TextCtrl.new @panel, -1, '', DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    
    @source = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @source_button = Button.new(@panel, -1, 'directory origine')
    evt_button(@source_button.id) {|e| on_source_button(e)}
    
    @first_dest = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @first_button = Button.new(@panel, -1, 'prima directory destinazione')
    evt_button(@first_button.id) {|e| on_first_choose_button(e)}
    
    @second_dest = TextCtrl.new @panel, -1, "", DEFAULT_POSITION, Size.new(350, 22)
    @second_button = Button.new(@panel, -1, 'seconda directory destinazione')
    evt_button(@second_button.id) {|e| on_second_choose_button(e)}
    
    @submit_button = Button.new(@panel, -1, 'sposta')
    evt_button(@submit_button.id) {|e| on_submit_button(e)}
    
    @sizer = BoxSizer.new(VERTICAL)
    @panel.sizer = @sizer
    
    @sizer.add @caption, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @files, 0, GROW|ALL, 10
    
    @sizer.add @source, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @source_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
        
    @sizer.add @first_dest, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @first_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
    
    @sizer.add @second_dest, 0, GROW|TOP|LEFT|RIGHT, 10
    @sizer.add @second_button, 0, GROW|TOP|LEFT|RIGHT|BOTTOM, 10
    
    @sizer.add @submit_button, 0, ALIGN_CENTER|ALL, 10
  end
  
  def on_source_button(event)
    dir_home = get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di origine", dir_home)
    @source.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_first_choose_button(event)
    dir_home = get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    @first_dest.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_second_choose_button(event)
    dir_home = get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    @second_dest.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_submit_button(event)
    if @source.value.empty? || @first_dest.value.empty? || @files.value.empty?
      log_message "Devi fornire tutti i dati obbligatori: cartella sorgente, destinazione, e file da copiare"
      return
    else
      files = FileAdapter.convert(@files.value)
      copier = Mover.new(files, @source.value, @first_dest.value, @second_dest.value)
      copier.mv
      moved = copier.moved.join_in_groups_of(5)
      not_moved = copier.not_moved.join_in_groups_of(5)
      log_message "Ho spostato i seguenti file: #{moved}\n\nNon ho trovato i seguenti files: #{not_moved}"
    end
  end
end

class MaxApp < App
  def on_init
    CopierFrame.new.show
  end
end

MaxApp.new.main_loop