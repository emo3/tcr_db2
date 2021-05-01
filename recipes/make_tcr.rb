# Cookbook:: tcr_db2
# Recipe:: make_tcr
#
# Copyright:: 2021, Ed Overton
#
######
# used the following to create password
# openssl passwd -1 -salt $(openssl rand -base64 6) P@ssw0rd
######

# This will setup my values for TCR
node.default['db2']['port_number']     = '60008'
node.default['db2']['instance_name']   = 'TCRDB'
node.default['db2']['db2inst1-user']   = 'omni01'
node.default['db2']['db2inst1-group']  = 'omnadm'
node.default['db2']['db2inst1-home']   = "/home/#{node['db2']['db2inst1-user']}"
node.default['db2']['db2fence1-user']  = 'omni01f'
node.default['db2']['db2fence1-group'] = 'omnadm'
node.default['db2']['db2fence1-home']  = "/home/#{node['db2']['db2fence1-user']}"
node.default['db2']['db2user1-user']   = 'tcr001'
node.default['db2']['db2user1-group']  = 'omnadm'
node.default['db2']['db2user1-home']   = "/home/#{node['db2']['db2user1-user']}"
node.default['db2']['db2_password']    = 'P@ssw0rd'
node.default['db2']['db2_epassword']   = '$1$xaVDw1NS$NmyxP1YTnqenTM8LmEO2f.'

package node['tcr_db2']['packages']

include_recipe 'db2::default'
include_recipe 'db2::installfp'
include_recipe 'db2::instance'
## create TCRDB database
include_recipe '::create_tcrdb'
## create REPORTER instance
node.default['db2']['instance_name'] = 'REPORTER'
include_recipe '::create_reporter'
