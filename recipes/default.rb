#
# Cookbook Name:: setup-user
# Recipe:: default
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

Chef::Config[:cookbook_path].each{|elem|
  if File.exists?(File.join(elem, "/nginx/templates/default/", node['nginx']['template_dir']))
    conf_dir = File.join(elem, "/nginx/templates/default/", node['nginx']['template_dir'])
    Dir.chdir conf_dir
    confs = Dir::glob("**/*")

    confs.each do |t|
      if File::ftype("#{conf_dir}/#{t}") == "file"
        template "/etc/nginx/#{t}" do
          owner "root"
          group "root"
          mode 00644
          source "#{node['nginx']['template_dir']}/#{t}"
          notifies :restart, "service[nginx]"
        end
      else
        directory "/etc/nginx/#{t}" do
          owner "root"
          group "root"
          mode 00755
        end
      end
    end
  end
}
