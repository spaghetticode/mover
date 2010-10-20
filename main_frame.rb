# This class was automatically generated from XRC source. It is not
# recommended that this file is edited directly; instead, inherit from
# this class and extend its behaviour there.  
#
# Source file: my_frame.xrc 
# Generated at: Sun Oct 17 21:04:02 +0200 2010

class TextFrameBase < Wx::Frame
	
	attr_reader :save_config_bt, :file_names_txt, :source_dir_txt,
              :source_dir_bt, :target_dir_txt, :target_dir_bt,
              :second_target_dir_txt, :second_target_dir_bt,
              :submit_bt
	
	def initialize(parent = nil)
		super()
		xml = Wx::XmlResource.get
		xml.flags = 2 # Wx::XRC_NO_SUBCLASSING
		xml.init_all_handlers
		xml.load(File.join(File.dirname(__FILE__),"main_frame.xrc"))
		xml.load_frame_subclass(self, parent, "ID_WXFRAME")

		finder = lambda do | x | 
			int_id = Wx::xrcid(x)
			begin
				Wx::Window.find_window_by_id(int_id, self) || int_id
			# Temporary hack to work around regression in 1.9.2; remove
			# begin/rescue clause in later versions
			rescue RuntimeError
				int_id
			end
		end
		
		@save_config_bt = finder.call("save_config_bt")
		@file_names_txt = finder.call("file_names_txt")
		@source_dir_txt = finder.call("source_dir_txt")
		@source_dir_bt = finder.call("source_dir_bt")
		@target_dir_txt = finder.call("target_dir_txt")
		@target_dir_bt = finder.call("target_dir_bt")
		@second_target_dir_txt = finder.call("second_target_dir_txt")
		@second_target_dir_bt = finder.call("second_target_dir_bt")
		@submit_bt = finder.call("submit_bt")
		if self.class.method_defined? "on_init"
			self.on_init()
		end
	end
end


