name             'tcr_db2'
maintainer       'Ed Overton'
maintainer_email 'None'
license          'Apache 2.0'
description      'Installs/Configures IBM DB2 Enterprise Server version 10.5.x with TCR datbase'
long_description 'Installs/Configures IBM DB2 Enterprise Server version 10.5.x with TCR datbase'
version          '0.1.0'
chef_version '>= 13.0'
supports 'redhat'
supports 'centos'

issues_url 'https://github.com/<insert_org_here>/tcr_db2/issues' if respond_to?(:issues_url)
source_url 'https://github.com/<insert_org_here>/tcr_db2'

depends 'db2'
depends 'server_utils'
