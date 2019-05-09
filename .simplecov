SimpleCov.add_group 'mysql-utils', 'lib/.+.sh$'
SimpleCov.add_filter '.git' # Don't include .git
SimpleCov.add_filter 'tests' # Don't include tests folder
SimpleCov.add_filter 'get_coverage' # Don't include get_coverage script
SimpleCov.add_filter 'src' # Don't include get_coverage script
SimpleCov.add_filter 'utils' # Don't include get_coverage script
SimpleCov.add_filter 'lib/00-variables.sh' # Don't include variable declarations
