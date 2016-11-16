class cots (
  Array[String] $requested_apps,


) {
  debug::break()
  #$all_apps = cots::resolve_dependencies($requested_apps)
  #notice($all_apps)
  # $all_apps.each | String $app_name, String $parameters | {
  #   cots::application{$app_name:
  #     *=> $parameters
  #   }
  # }
}
