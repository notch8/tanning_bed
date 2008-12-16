# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

load 'tasks/setup.rb'

ensure_in_path 'lib'
require 'tanning_bed'

task :default => 'spec:run'

PROJ.name = 'tanning_bed'
PROJ.authors = 'Rob Kaufman'
PROJ.email = 'rob@notch8.com'
PROJ.url = 'notch8.com'
PROJ.rubyforge.name = 'tanning_bed'

PROJ.spec.opts << '--color'

# EOF
