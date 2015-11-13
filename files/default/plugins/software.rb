#
# Cookbook Name:: ohai_software
# Plugin Name:: software.rb
#
# Copyright 2015, Nordstrom, Inc.
#
# Apache2 license as specified in the License file.
#

Ohai.plugin(:Software) do
  provides 'software'

  def packages
    {
      # TODO: consider extracting license info
      vas: { version: :vas_version, installed: :vas_installed },
      vmware: { version: :vmware_version, installed: :vmware_installed, upgrade_available: :vmware_chk_upgrade },
      vxfs: { version: :vxfs_version, installed: :vxfs_installed }
    }
  end

  def vas_installed
    vastool ? true : false
  end

  def vmware_installed
    vmware ? true : false
  end

  def vxfs_installed
    ::File.executable?('/usr/sbin/vxprint')
  end

  def vas_version
    return unless vastool
    vtout = shell_out("#{vastool} -v").stdout
    md = vtout.match(/Version\s+(?<version>[.\d]+)/)
    md ? md[:version] : nil
  end

  def vastool
    pgm = '/opt/quest/bin/vastool'
    ::File.executable?(pgm) ? pgm : false
  end

  def vmware_chk_upgrade
    return unless vmware
    vmout = shell_out("#{vmware} upgrade status").stdout
    md = vmout.match(/(?<available>available)/)
    md ? true : false
  end

  def vmware_version
    return unless vmware
    vmout = shell_out("#{vmware} -v").stdout
    md = vmout.match(/^(?<version>[.\d]+)\s+/)
    md ? md[:version] : nil
  end

  def vmware
    pgm = '/usr/bin/vmware-toolbox-cmd'
    return pgm if ::File.executable?(pgm)
    pgm = '/usr/ccs/bin/vmware-toolbox-cmd'
    ::File.executable?(pgm) ? pgm : false
  end

  def vxfs_version
    os = collect_os
    case os.to_s
    when 'solaris2'
      vxfs_version_solaris2
    when 'linux'
      vxfs_version_linux
    end
  end

  def vxfs_version_solaris2
    modout = shell_out('modinfo').stdout
    md = modout.match(/^.+?vxfs\s+\(VxFS\s+(?<version>[.\w]+)/)
    md ? md[:version] : nil
  end

  def vxfs_version_linux
    modout = shell_out('modinfo vxfs').stdout
    md = modout.match(/^\s*version:\s+(?<version>[.\w]+)$/)
    md ? md[:version] : nil
  end

  collect_data(:default) do
    software = Mash.new unless software
    packages.each do |pkg_name, info_types|
      software[pkg_name] = Mash.new
      info_types.each do |type, info_method|
        software[pkg_name][type] =  send(info_method)
      end
    end
    software software
  end
end
