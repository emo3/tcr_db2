name             'tcr_db2'
maintainer       'Ed Overton'
maintainer_email 'None'
license          'Apache 2.0'
description      'Installs/Configures IBM DB2 Enterprise Server version 10.5.x with TCR datbase'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
chef_version '>= 13.0'
supports 'redhat'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/tcr_db2/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/tcr_db2'
depends 'db2', '~> 1.0.0'
depends 'server_utils', '~> 0.1.0'
