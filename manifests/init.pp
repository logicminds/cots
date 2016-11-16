class cots (
  Array[String] $requested_apps,
) {
  $all_apps = cots::resolve($requested_apps)
  $all_apps.each | Hash $parameters | {
    cots::application{$parameters['name']:
      *=> $parameters
    }
  }
}
