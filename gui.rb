require 'rubygems'
require 'wx'
require 'movable_file'
require 'mover'
require 'main_frame'
include Wx

class ReportFrame < Frame
  def initialize(parent, moved, not_moved)
    super(parent, -1, 'Report', :size => Size.new(300,200))
    panel = Panel.new(self)
    sizer = BoxSizer.new(VERTICAL)
    panel.sizer   = sizer
    moved_caption = StaticText.new panel, :label => 'Ho spostato i seguenti files:'
    moved_box     = TextCtrl.new panel, -1, moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    not_moved_box = TextCtrl.new panel, -1, not_moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    not_moved_caption = StaticText.new panel, :label => 'Non ho trovato i seguenti files:'
    sizer.add not_moved_caption, 0
    sizer.add not_moved_box, 1, GROW|ALL, 10
    sizer.add moved_caption, 0
    sizer.add moved_box, 1, GROW|ALL, 10
  end
end

class MoverFrame < TextFrameBase
  def initialize
    AppConfig.path = File.join(get_home_dir, '.file_mover.yml')
    super
    source_dir_txt.value = AppConfig.source_dir if AppConfig.source_dir
    target_dir_txt.value = AppConfig.target_dir if AppConfig.target_dir
    second_target_dir_txt.value = AppConfig.second_target_dir if AppConfig.second_target_dir
    evt_button(clean_bt)       {|e| on_clean_button(e)}
    evt_button(save_config_bt) {|e| on_save_config_button(e)}
    evt_button(validate_bt)    {|e| on_validate_button(e)}
    evt_button(submit_bt)      {|e| on_submit_button(e)}
    evt_button(source_dir_bt)  {|e| on_source_button(e)}
    evt_button(target_dir_bt)  {|e| on_first_choose_button(e)}
    evt_button(second_target_dir_bt) {|e| on_second_choose_button(e)}
  end
  
  def on_source_button(event)
    dir_home = AppConfig.source_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di origine", dir_home)
    source_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_first_choose_button(event)
    dir_home = AppConfig.target_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    target_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end
  
  def on_second_choose_button(event)
    dir_home = AppConfig.second_target_dir || get_home_dir
    dialog = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    second_target_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end

  def on_save_config_button(event)
    AppConfig.save(source_dir_txt.value, target_dir_txt.value, second_target_dir_txt.value)
  end
  
  def on_validate_button(event)
    raise "verify"
  end
  
  def on_clean_button(event)
    raise "clean"
  end
  
  def on_submit_button(event)
    if required_fields_empty?
      log_message "Devi fornire tutti i dati obbligatori:\ncartella sorgente, destinazione, e file da spostare"
    elsif target_dir_txt.value.include?(source_dir_txt.value)
      log_message "La cartella di destinazione non è valida:\ndevi scegliere una cartella esterna a quella di origine"
    else
      prog_bar = ProgressDialog.new('', 'Inizio spostamento files, per favore attendere...', 100, self, PD_APP_MODAL|PD_ELAPSED_TIME)
      files = FileAdapter.convert(file_names_txt.value)
      mover = Mover.new(prog_bar, files, source_dir_txt.value, target_dir_txt.value, second_target_dir_txt.value)
      mover.mv
      prog_bar.update(100, "#{mover.moved_count} files spostati. Operazione terminata.")
      moved = mover.moved.join("\n")
      not_moved = mover.not_moved.join("\n")
      ReportFrame.new(self, moved, not_moved).show
    end
  end
  
  private
  
  def required_fields_empty?
    source_dir_txt.value.empty? || target_dir_txt.value.empty? || file_names_txt.value.empty?
  end
end

class MoverApp < App
  def on_init
    MoverFrame.new.show
  end
end

MoverApp.new.main_loop