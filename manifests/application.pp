define cots::application(
  Optional[String] $installer_location  = undef,
  Optional[String] $installer_provider  = undef,
  String $package_name                  = $name,
  Array[String] $dependencies           = [],
  String $description                   = '',
  Enum['item','group'] $entry_type      = 'item',
 ) {

   if $entry_type == 'item' {
     
   }
 }
