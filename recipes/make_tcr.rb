#
# Cookbook Name:: tcr_db2
# Recipe:: make_tcr
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
######
# used the following to create password
# openssl passwd -1 -salt $(openssl rand -base64 6) P@ssw0rd
######
# This will setup my values for TCR
node.default['db2']['db2-db-list']     = %w(TCRDB)
node.default['db2']['port_number']     = '60008'
node.default['db2']['instance_name']   = 'TCRDB'
node.default['db2']['db2inst1-user']   = 'omni01'
node.default['db2']['db2inst1-group']  = 'omnadm'
node.default['db2']['db2inst1-home']   = "/home/#{node['db2']['db2inst1-user']}"
node.default['db2']['db2fence1-user']  = 'omni01f'
node.default['db2']['db2fence1-group'] = 'dbfence'
node.default['db2']['db2fence1-home']  = "/home/#{node['db2']['db2fence1-user']}"
node.default['db2']['db2user1-user']   = 'tcr001'
node.default['db2']['db2user1-group']  = 'omnadm'
node.default['db2']['db2user1-home']   = "/home/#{node['db2']['db2user1-user']}"
node.default['db2']['db2_password']    = 'P@ssw0rd'
node.default['db2']['db2_epassword']   = '$1$xaVDw1NS$NmyxP1YTnqenTM8LmEO2f.'
include_recipe 'db2::default'
include_recipe 'db2::installfp'
include_recipe 'db2::instance'
include_recipe '::create_tcr'
