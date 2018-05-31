# create and run sql to create schema for TCR
binary_dir = Chef::Config[:file_cache_path]

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

execute 'create-tcr' do
  command "#{node['db2']['db2inst1-home']}/sqllib/bin/db2 \
  -tmf #{binary_dir}/#{node['tcr_db2']['tcr_sql']}"
  cwd binary_dir
  owner node['db2']['db2inst1-user']
  group node['db2']['db2inst1-group']
  action :run
end

file "#{binary_dir}/#{node['tcr_db2']['tcr_sql']}.sql" do
  action :nothing
end
