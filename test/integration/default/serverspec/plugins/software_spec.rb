#
# Copyright (c) 2015 Nordstrom, Inc.
#

require 'spec_helper'

software = OHAI['software']

describe 'software plugin' do
  it 'should add software to the plugin directory'do
    expect(file '/etc/chef/ohai_plugins/software.rb').to be_file
  end

  it 'vas should not be installed'do
    expect(software['vas']['installed']).to eql(false)
  end

  it 'vas version should be nil'do
    expect(software['vas']['version']).to eql(nil)
  end

  it 'vmware should not be installed'do
    expect(software['vmware']['installed']).to eql(false)
  end

  it 'vmware version should be nil'do
    expect(software['vmware']['version']).to eql(nil)
  end

  it 'vxfs should not be installed'do
    expect(software['vxfs']['installed']).to eql(false)
  end

  it 'vxfs version should be nil'do
    expect(software['vxfs']['version']).to eql(nil)
  end
end
