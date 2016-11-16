# See https://docs.puppet.com/puppet/4.5/reference/lang_write_functions_in_puppet.html
# for more information on native puppet functions.

# Example Documention for function using puppet strings
# https://github.com/puppetlabs/puppetlabs-strings
# When given two numbers, returns the one that is larger.
# You could have a several line description here if you wanted,
# but I don't have much to say about this function.
#
# @example using two integers
#   $bigger_int = max(int_one, int_two)
#
# @return [Integer] the larger of the two parameters
#
# @param num_a [Integer] the first number to be compared
# @param num_b [Integer] the second number to be compared
function cots::resolve_dependencies(Array[String] $apps) {
  $apps.map | String $app_name | {
    $application_name = $app_name
    $metadata = lookup({name => 'cots::app_metadata', value_type => Hash})
    #debug::break()
    # if no dependencies this will return an empty array
    $dependencies = cots::resolve_dependencies($metadata['dependencies'])
    # add the dependencies first then the app
    $dependencies + metadata
  }.flatten()
}
