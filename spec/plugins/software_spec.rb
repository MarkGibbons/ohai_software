#
# Cookbook Name:: ohai_software
#
# Copyright 2015, Nordstrom, Inc.
#
# All rights reserved - Do Not Redistribute
#

require 'ohai'
require 'ostruct'
require 'spec_helper'

describe Ohai::System, 'Software plugin - solaris happy path' do
  before(:each) do
    @plugin = get_plugin('software.rb')
    puts 'Check the software.rb plugin for errors. Loading failed' unless @plugin
    allow(@plugin).to receive(:collect_os).and_return(:solaris2)
    allow(@plugin).to receive(:shell_out).and_return(OpenStruct.new(stdout: 'not stubbed'))
    allow(@plugin).to receive(:shell_out).with('/opt/quest/bin/vastool -v').and_return(vas_version)
    allow(@plugin).to receive(:shell_out).with('/usr/bin/vmware-toolbox-cmd -v').and_return(vmware_version)
    allow(@plugin).to receive(:shell_out).with('modinfo').and_return(vxfs_version_solaris)
    allow(File).to receive(:executable?).and_call_original
    allow(File).to receive(:executable?).with('/opt/quest/bin/vastool').and_return(true)
    allow(File).to receive(:executable?).with('/usr/bin/vmware-toolbox-cmd').and_return(true)
    allow(File).to receive(:executable?).with('/usr/ccs/bin/vmware-toolbox-cmd').and_return(true)
    allow(File).to receive(:executable?).with('/usr/sbin/vxprint').and_return(true)
    @plugin.run
  end

  it 'Run successfully' do
    expect { @plugin }.to_not raise_error
  end

  it 'Return a Mash' do
    expect @plugin.to be_a_kind_of(Mash)
  end

  it 'vas version' do
    expect(@plugin[:software][:vas][:version]).to eq '4.1.0.21267'
  end

  it 'vmware version' do
    expect(@plugin[:software][:vmware][:version]).to eq '8.6.11.26309'
  end

  it 'vxfs version' do
    expect(@plugin[:software][:vxfs][:version]).to eq '5.1SP1RP4'
  end

  it 'vas installed' do
    expect(@plugin[:software][:vas][:installed]).to eq true
  end

  it 'vmware installed' do
    expect(@plugin[:software][:vmware][:installed]).to eq true
  end

  it 'vxfs installed' do
    expect(@plugin[:software][:vxfs][:installed]).to eq true
  end
end

describe Ohai::System, 'Software plugin - no version programs found' do
  before(:each) do
    @plugin = get_plugin('software.rb')
    puts 'Check the software.rb plugin for errors. Loading failed' unless @plugin
    allow(@plugin).to receive(:collect_os).and_return(:linux)
    allow(@plugin).to receive(:shell_out).and_return(OpenStruct.new(stdout: 'not stubbed'))
    allow(@plugin).to receive(:shell_out).with('/opt/quest/bin/vastool -v').and_return(vas_version)
    allow(@plugin).to receive(:shell_out).with('vmware-toolbox-cmd -v').and_return(vmware_version)
    allow(@plugin).to receive(:shell_out).with('modinfo').and_return(vxfs_version_none)
    allow(@plugin).to receive(:shell_out).with('modinfo vxfs').and_return(vxfs_version_none)
    allow(File).to receive(:executable?).and_call_original
    allow(File).to receive(:executable?).with('/opt/quest/bin/vastool').and_return(false)
    allow(File).to receive(:executable?).with('/usr/bin/vmware-toolbox-cmd').and_return(false)
    allow(File).to receive(:executable?).with('/usr/ccs/bin/vmware-toolbox-cmd').and_return(false)
    allow(File).to receive(:executable?).with('/usr/sbin/vxprint').and_return(false)
    @plugin.run
  end

  it 'Run successfully' do
    expect { @plugin }.to_not raise_error
  end

  it 'Return a Mash' do
    expect @plugin.to be_a_kind_of(Mash)
  end

  it 'vas version' do
    expect(@plugin[:software][:vas][:version]).to eq nil
  end

  it 'vmware version' do
    expect(@plugin[:software][:vmware][:version]).to eq nil
  end

  it 'vxfs version' do
    expect(@plugin[:software][:vxfs][:version]).to eq nil
  end

  it 'vas not installed' do
    expect(@plugin[:software][:vas][:installed]).to eq false
  end

  it 'vmware not installed' do
    expect(@plugin[:software][:vmware][:installed]).to eq false
  end

  it 'vxfs not installed' do
    expect(@plugin[:software][:vxfs][:installed]).to eq false
  end
end

describe Ohai::System, 'Software plugin - linux' do
  before(:each) do
    @plugin = get_plugin('software.rb')
    puts 'Check the software.rb plugin for errors. Loading failed' unless @plugin
    allow(@plugin).to receive(:collect_os).and_return(:linux)
    allow(@plugin).to receive(:shell_out).and_return(OpenStruct.new(stdout: 'not stubbed'))
    allow(@plugin).to receive(:shell_out).with('/opt/quest/bin/vastool -v').and_return(vas_version)
    allow(@plugin).to receive(:shell_out).with('/usr/bin/vmware-toolbox-cmd -v').and_return(vmware_version)
    allow(@plugin).to receive(:shell_out).with('modinfo').and_return(vxfs_version_solaris)
    allow(@plugin).to receive(:shell_out).with('modinfo vxfs').and_return(vxfs_version_linux)
    allow(File).to receive(:executable?).with('/opt/quest/bin/vastool').and_return(true)
    allow(File).to receive(:executable?).with('/usr/bin/vmware-toolbox-cmd').and_return(true)
    allow(File).to receive(:executable?).with('/usr/ccs/bin/vmware-toolbox-cmd').and_return(false)
    allow(File).to receive(:executable?).with('/usr/sbin/vxprint').and_return(true)
    @plugin.run
  end

  it 'Run successfully' do
    expect { @plugin }.to_not raise_error
  end

  it 'vmware version' do
    expect(@plugin[:software][:vmware][:version]).to eq '8.6.11.26309'
  end

  it 'vxfs version' do
    expect(@plugin[:software][:vxfs][:version]).to eq '5.0.30.00'
  end
end

def vmware_version
  OpenStruct.new(stdout:
    '8.6.11.26309 (build-1310128)
'
                )
end

def vxfs_version_none
  OpenStruct.new(stdout:
  '
'  
  )
end

def vxfs_version_solaris
  OpenStruct.new(stdout:
    ' 41 7bef6000  51628 316   1  vxdmp (VxVM 5.1SP1RP4 DMP Driver)
42 7ba00000 221b08 317   1  vxio (VxVM 5.1SP1RP4 I/O driver)
44 7beaef40   11a8 318   1  vxspec (VxVM 5.1SP1RP4 control/status d)
229 7bf893f8    d40 319   1  vxportal (VxFS 5.1SP1RP4 portal driver)
230 7a600000 206470  21   1  vxfs (VxFS 5.1SP1RP4 SunOS 5.10)
249 7a26c000   baa8 320   1  fdd (VxQIO 5.1SP1RP4 Quick I/O drive)
'
  )
end

def vxfs_version_linux
  OpenStruct.new(stdout:
    'filename:       /lib/modules/2.6.18-194.el5/veritas/vxfs/vxfs.ko
    version:        5.0.30.00
    description:    Veritas file system
    author:         Symantec Corporation
    license:        Proprietary. Send bug reports to support@veritas.com
    srcversion:     EA0089391273696173992B2
    depends:
    vermagic:       2.6.18-8.el5 SMP mod_unload gcc-4.1
    parm:           vxfs_ninode:Maximum number of vxfs inodes (int)
    parm:           vx_ifree_timelag:Seconds before scanning inode free list (long)
    parm:           vxfs_mbuf:Maximum memory used for vxfs buffer cache (charp)
    parm:           vxfs_maxdiospace:Maximum memory wired down for direct IO (charp)
    parm:           vxfs_mindiospace:Minimum memory wired down for direct IO (charp)
    parm:           vxfs_pmem:Physical memory to use as input for tuning curves (charp)
    parm:           vxfs_icachechunk:Maximum number of pages for each memory chunk used for VxFS inodes (int)
    parm:           vx_fiostats_tunable:Memory used for file I/O stats (int)
    parm:           vx_fiostats_winterval:FCL winterval for file I/O stats (int)
    parm:           vxfs_naio_threads_max:Maximum number of threads for native AIO (uint)
    parm:           vxfs_naio_threads_min:Minimum number of threads for native AIO (uint)
    parm:           vxfs_naio_plug_enable:Throttle native AIO on memory usage (uint)
    parm:           vxfs_sendfile_chunk:Number of pages to fetch for large sendfile transfers (uint)
    parm:           vxfs_sendfile_limit:Maximum number of processes in a sendfile main loop (uint)
    parm:           vxfs_sendfile_nfs:Setting to non-zero changes VxFS behaviour with sendfile from NFS (uint)
    parm:           vxfs_io_proxy_vxvm:Include VxVM devices in IO hand-off decisions (int)
    parm:           vxfs_io_proxy_level:Hand-off IO to worker threads for `raw` block devices when less than this number of bytes free on kernel stack (int)
    parm:           vxfs_io_proxy_pools:Number of IO pools for hand-off. (int)
    parm:           vxfs_io_proxy_time:If an IO has been waiting on an IO queue for this number of clock ticks, then create a new IO hand-off thread (int)
    parm:           vxfs_io_proxy_max:Maximum number of threads per IO handoff queue (int)
'
                )
end

def vas_version
  OpenStruct.new(stdout:
    'vastool: QAS Version 4.1.0.21267
Copyright 2014 Quest Software, Inc.  ALL RIGHTS RESERVED.
Protected by U.S. Patent Nos. 7,617,501, 7,895,332, 7,904,949, 8,086,710, 8,087,075, 8,245,242. Patents pending.
'
                )
end
