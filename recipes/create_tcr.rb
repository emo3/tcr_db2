# Cookbook:: tcr_db2
# Recipe:: create_tcr
#
# Copyright:: 2021, Ed Overton
#

binary_dir = Chef::Config[:file_cache_path]

execute 'start_tcr' do
  command "#{node['db2']['db2inst1-home']}/sqllib/bin/db2start"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/bin"
  not_if 'ps -ef|grep db2', user: node['db2']['db2inst1-user']
  action :run
end

template "#{binary_dir}/#{node['tcr_db2']['tcr_sql']}" do
  source "#{node['tcr_db2']['tcr_sql']}.erb"
  variables(
    tcr_db: node['db2']['instance_name'],
    instance_acct: node['db2']['db2inst1-user']
  )
  owner node['db2']['db2inst1-user']
  group node['db2']['db2inst1-group']
  mode '0644'
end

execute 'tcr_schema' do
  command "#{node['db2']['db2inst1-home']}/sqllib/bin/db2 \
  -tmf #{binary_dir}/#{node['tcr_db2']['tcr_sql']}"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/bin"
  action :run
end

file "#{binary_dir}/#{node['tcr_db2']['tcr_sql']}" do
  action :nothing
end
