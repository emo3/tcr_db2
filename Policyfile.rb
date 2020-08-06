# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'tcr_db2'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'tcr_db2::make_tcr'

# Specify a custom source for a single cookbook:
cookbook 'tcr_db2',      path: '.'
cookbook 'db2',          git: 'https://github.com/emo3/db2.git'
cookbook 'server_utils', git: 'https://github.com/emo3/server_utils.git'
