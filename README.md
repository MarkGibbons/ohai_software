ohai_software Cookbook
======================
This cookbook adds the software ohai plugin to the list of plugins the ohai
cookbook should install. The goal of the software plugin is to gather version
informaton about specific software packages.  The current list is
vas, vmware and vxfs.

Limitations
===========

Dependencies
============


Usage
=====
Add `ohai_software` to the metadata of a cookbook that runs on your server.
If you don't already have the `ohai` recipe in your runlist it will need to be
added near the top as well.

Ohai Attributes Set by Plugins
==============================
*  software[:<pkg>][:installed] Check to see if the package is installed
*  software[:<pkg>][:version] Gather the package version. Returns nil if unable
   to get a version.
