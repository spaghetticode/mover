require 'rubygems'
require 'wx'
require 'movable_file'
require 'mover'
require 'code'
require 'cleaner'
require 'validator'
require 'main_frame'
include Wx

class MovedFrame < Frame
  def initialize(parent, moved, not_moved)
    super(parent, -1, 'Report', :size => Size.new(300, 200))
    panel = Panel.new(self)
    panel.sizer   = BoxSizer.new(VERTICAL)
    moved_caption = StaticText.new panel, :label => 'Ho spostato i seguenti files:'
    moved_box     = TextCtrl.new panel, -1, moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    not_moved_box = TextCtrl.new panel, -1, not_moved, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    not_moved_caption = StaticText.new panel, :label => 'Non ho trovato i seguenti files:'
    panel.sizer.add not_moved_caption, 0
    panel.sizer.add not_moved_box, 1, GROW|ALL, 10
    panel.sizer.add moved_caption, 0
    panel.sizer.add moved_box, 1, GROW|ALL, 10
  end
end

class InvalidFrame < Frame
  def initialize(parent, message)
    super(parent, -1, 'Report', :size => Size.new(300, 200))
    panel = Panel.new(self)
    panel.sizer     = BoxSizer.new(VERTICAL)
    invalid_caption = StaticText.new panel, :label => 'Le seguenti sigle sono invalide:'
    invalid_box     = TextCtrl.new panel, -1, message, DEFAULT_POSITION, DEFAULT_SIZE, TE_MULTILINE
    panel.sizer.add invalid_caption, 0
    panel.sizer.add invalid_box, 1, GROW|ALL, 10
  end
end

class MoverFrame < TextFrameBase
  def initialize
    AppConfig.path = File.join(get_home_dir, '.file_mover.yml')
    super
    source_dir_txt.value = AppConfig.source_dir if AppConfig.source_dir
    target_dir_txt.value = AppConfig.target_dir if AppConfig.target_dir
    second_target_dir_txt.value = AppConfig.second_target_dir if AppConfig.second_target_dir
    bind_events
  end

  def on_source_button(event)
    dir_home = AppConfig.source_dir || get_home_dir
    dialog   = DirDialog.new(self, "Scegli la directory di origine", dir_home)
    source_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end

  def on_first_choose_button(event)
    dir_home = AppConfig.target_dir || get_home_dir
    dialog   = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    target_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end

  def on_second_choose_button(event)
    dir_home = AppConfig.second_target_dir || get_home_dir
    dialog   = DirDialog.new(self, "Scegli la directory di destinazione", dir_home)
    second_target_dir_txt.value = dialog.path if dialog.show_modal == ID_OK
  end

  def on_save_config_button(event)
    AppConfig.save(source_dir_txt.value, target_dir_txt.value, second_target_dir_txt.value)
  end

  def on_validate_button(event)
    if file_names_txt.value.empty?
      log_message 'Devi inserire una lista di sigle'
    else
      codes = FileAdapter.codes(file_names_txt.value)
      validator = Validator.new(codes)
      invalid_codes = validator.get_invalid_codes
      message = invalid_codes.empty? && 'Le sigle sono valide o non hanno codice di controllo' || invalid_codes
      InvalidFrame.new(self, message).show
    end
  end

  def on_clean_button(event)
    if file_names_txt.value.empty?
      log_message 'Devi inserire una lista di sigle'
    else
      codes   = FileAdapter.codes(file_names_txt.value)
      cleaner = Cleaner.new(codes)
      file_names_txt.value = cleaner.remove_control_codes
    end
  end

  def on_submit_button(event)
    if required_fields_empty?
      log_message error_message
    elsif origin_and_targets_are_same?
      log_message invalid_folder
    else
      prog_bar = ProgressDialog.new('', start_message, 100, self, PD_APP_MODAL|PD_ELAPSED_TIME)
      files    = FileAdapter.convert(file_names_txt.value)
      mover    = Mover.new(prog_bar, files, source_dir_txt.value, target_dir_txt.value, second_target_dir_txt.value)
      mover.mv
      prog_bar.update(100, "#{mover.moved_count} files spostati. Operazione terminata.")
      moved     = mover.moved.join("\n")
      not_moved = mover.not_moved.join("\n")
      MovedFrame.new(self, moved, not_moved).show
    end
  end

  private

  def bind_events
    evt_button(clean_bt)       {|e| on_clean_button(e)}
    evt_button(save_config_bt) {|e| on_save_config_button(e)}
    evt_button(validate_bt)    {|e| on_validate_button(e)}
    evt_button(submit_bt)      {|e| on_submit_button(e)}
    evt_button(source_dir_bt)  {|e| on_source_button(e)}
    evt_button(target_dir_bt)  {|e| on_first_choose_button(e)}
    evt_button(second_target_dir_bt) {|e| on_second_choose_button(e)}
  end

  def required_fields_empty?
    source_dir_txt.value.empty? || target_dir_txt.value.empty? || file_names_txt.value.empty?
  end

  def error_message
    "Devi fornire tutti i dati obbligatori:\ncartella sorgente, destinazione, e file da spostare"
  end

  def invalid_folder
    "La cartella di destinazione non è valida:\ndevi scegliere una cartella esterna a quella di origine"
  end

  def start_message
    'Inizio spostamento files, per favore attendere...'
  end

  def origin_and_targets_are_same?
    FileAdapter.same_dir?(target_dir_txt.value, source_dir_txt.value) or FileAdapter.same_dir?(second_target_dir_txt.value, source_dir_txt.value)
  end
end

class MoverApp < App
  def on_init
    MoverFrame.new.show
  end
end

MoverApp.new.main_loop