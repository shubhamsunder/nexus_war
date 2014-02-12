#
# Cookbook Name:: nexus_war
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
remote_file "#{node[:file_path1]}" do
         source "#{node[:file_source1]}"
	action :create_if_missing
       end

#remote_file "#{node[:file_path2]}" do
#         source "#{node[:file_source2]}"
#	action :create_if_missing
#       end

bash "install_tomcat" do
  user "root"
  code <<-EOH
    cd /usr/local/tomcat/bin
    sh startup.sh
  EOH
end

url = "http://#{node[:ipaddress]}:8080/#{node[:war_name]}"

ruby_block "start_phantom_checking" do
  block do
    require 'net/http'
    sleep(60)
    postData = Net::HTTP.post_form(URI.parse('http://10.114.90.164:8080/path'), {'url'=>"#{url}", 'ip'=>"#{node[:ipaddress]}"})
  end
  action :create
end

ruby_block "ruby code to notify orchestrator" do
	block do
		puts "==================================================================================================="
		puts "ruby block executed"
	end
	only_if { File.exist?("#{node[:file_path]}") }
end
