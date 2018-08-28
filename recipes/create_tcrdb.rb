#
# Cookbook Name:: tcr_db2
# Recipe:: create_tcrdb
#
# Copyright 2018, OvertonClan
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

binary_dir = Chef::Config[:file_cache_path]

log "db2 list database directory|grep #{node['db2']['instance_name']}"
log node['db2']['db2inst1-user']

execute 'start_db2' do
  command "#{node['db2']['db2inst1-home']}/sqllib/adm/db2start"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/adm"
  user node['db2']['instance_name']
  not_if 'ps -ef | pgrep db2vend', user: node['db2']['db2inst1-user']
end

execute 'pre_tcr' do
  command "echo 'TCR'> #{node['db2']['db2user1-home']}/tcr"
  user  node['db2']['db2user1-user']
  group node['db2']['db2user1-group']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/tcr.orig") }
end

# make backup copy of profile
copy_file 'copy tcr' do
  old_file "#{node['db2']['db2user1-home']}/tcr"
  file_ext '.bak'
  not_if { File.exist?("#{node['db2']['db2user1-home']}/tcr.orig") }
  action :copy
end

template "#{binary_dir}/#{node['tcr_db2']['tcr_sql']}" do
  source "#{node['tcr_db2']['tcr_sql']}.erb"
  variables(
    tcr_db: node['db2']['instance_name'],
    instance_acct: node['db2']['db2user1-user']
  )
  mode '0644'
  not_if "db2 list database directory | grep #{node['db2']['instance_name']}", user: node['db2']['db2inst1-user']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/tcr.orig") }
end

execute 'tcr_schema' do
  command "#{node['db2']['db2inst1-home']}/sqllib/bin/db2 \
  -tmf #{binary_dir}/#{node['tcr_db2']['tcr_sql']}"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/bin"
  user node['db2']['db2inst1-user']
  not_if "db2 list database directory | grep #{node['db2']['instance_name']}", user: node['db2']['db2inst1-user']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/tcr.orig") }
  action :run
end

file "#{binary_dir}/#{node['tcr_db2']['tcr_sql']}" do
  action :delete
end

# rename profile
copy_file 'rename tcr' do
  old_file "#{node['db2']['db2user1-home']}/tcr"
  file_ext '.bak'
  file_ext1 '.orig'
  not_if { File.exist?("#{node['db2']['db2user1-home']}/tcr.orig") }
  action :move
end
