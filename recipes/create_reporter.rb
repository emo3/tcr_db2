#
# Cookbook Name:: tcr_db2
# Recipe:: create_reporter
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

execute 'start_db2_rpt' do
  command "#{node['db2']['db2inst1-home']}/sqllib/adm/db2start"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/adm"
  user node['db2']['instance_name']
  not_if 'ps -ef | pgrep db2vend', user: node['db2']['db2inst1-user']
end

execute 'pre_rpt' do
  command "echo 'RPT'> #{node['db2']['db2user1-home']}/rpt"
  user  node['db2']['db2user1-user']
  group node['db2']['db2user1-group']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/rpt.orig") }
end

# make backup copy of profile
copy_file 'copy rpt' do
  old_file "#{node['db2']['db2user1-home']}/rpt"
  file_ext '.bak'
  not_if { File.exist?("#{node['db2']['db2user1-home']}/rpt.orig") }
  action :copy
end

template "#{binary_dir}/#{node['tcr_db2']['rpt_sql']}" do
  source "#{node['tcr_db2']['rpt_sql']}.erb"
  variables(
    tcr_db: node['db2']['instance_name'],
    instance_acct: node['db2']['db2user1-user']
  )
  mode '0644'
  not_if "db2 list database directory | grep #{node['db2']['instance_name']}", user: node['db2']['db2inst1-user']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/rpt.orig") }
end

execute 'rpt_schema' do
  command "#{node['db2']['db2inst1-home']}/sqllib/bin/db2 \
  -td@ -vf #{binary_dir}/#{node['tcr_db2']['rpt_sql']}"
  cwd "#{node['db2']['db2inst1-home']}/sqllib/bin"
  user node['db2']['db2inst1-user']
  not_if "db2 list database directory | grep #{node['db2']['instance_name']}", user: node['db2']['db2inst1-user']
  not_if { File.exist?("#{node['db2']['db2user1-home']}/rpt.orig") }
  action :run
end

file "#{binary_dir}/#{node['tcr_db2']['rpt_sql']}" do
  action :delete
end
