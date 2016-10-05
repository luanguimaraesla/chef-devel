execute 'apt-get update'
package 'build-essential'
gem_package 'pkgr'

# fixing bug with nokogiri
# run bundle config --local build.nokogiri "--use-system-libraries --with-xml2-include=/usr/include/libxml2>
# with the owner of the application inside the repo if necessary
package 'libxslt-dev'
package 'libxml2-dev'
