# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end


ensure_in_path 'lib'
require 'tanning_bed'

task :default => 'spec:run'

Bones {
  name  'tanning_bed'
  authors  'Rob Kaufman'
  email    'rob@notch8.com'
  url      'http://notch8.com'
  rubyforge.name = 'tanning_bed'
  spec.opts << '--color'
  depend_on 'solr-ruby', '0.8'
  depend_on 'tanning_bed_solr', :development => true
}


# EOF
