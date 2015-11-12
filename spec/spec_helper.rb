#
# Cookbook Name:: ohai_software
#
# Copyright 2015, Nordstrom, Inc.
#
# Apache2 license as specified in the License file.
#

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  PLUGIN_PATH = File.expand_path('../../files/default/plugins', __FILE__)

  def get_plugin(plugin, ohai = Ohai::System.new, path = PLUGIN_PATH)
    loader = Ohai::Loader.new(ohai)
    loader.load_plugin("#{path}/#{plugin}")
  end
end
