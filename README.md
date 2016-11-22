# Certified Off The Shelf

## Warning
This module is currently under development, do not use.

## Purpose
The purpose of this module is to install any piece of software by declaring it with data.
Think of this like the bundler app for puppet.

## Usage
In order to use this module you simple need to do the following:

```puppet
class{'cots':
  requested_apps  => ['developer']
}
```
or supply data to hiera `cots::requested_apps: ['developer']`

```puppet
include cots
```

## Defining new apps
Adding new apps to the certified list can be accomplished by adding a new file entry under `data/applications`
in this module.  Each file must be named after the app name.  This file supplies the metadata that 
puppet will use to install each app and satisfy it's dependencies if any. 

Example: 

```
data
└── applications
    ├── 7zip.yaml
    ├── atom.yaml
    ├── developer.yaml
    └── winzip.yaml
``` 
   
Required App metadata
   
```yaml
cots::app_metadata:
  name: # name of the app (must match filename)
  dependencies: ['7zip']  # any dependencies supplied as an array/list
  description: 'Code Editor'  # description of app, only used by humans
  installer_location: https://github.com/atom/atom/releases/download/v1.12.3/atom-windows.zip  # where to fetch the installer
  installer_provider: 'windows'  # installer provider, similar to package provider
  entry_type: item  # one of item or group
  
```  

### app metadata spec
Below is the spefication for the app metadata.  

```yaml
installer_provider:
   type: string
   values:
     - windows
     - msi
     - yum
     - rpm
     - iim
     - chocolatey
     - tar
     - gzip
     
entry_type:
   type: string
   values:
     - item
     - group
name:
  type: string

dependencies:
  type: Array[String]


installer_location:
  type: string

```

## Example Use case
So if you wanted to install a group that contains multiple applications you can use the group type
which will in turn resolve all of the defined dependencies.

If we look at the app metadata for the developer group we can see that the developer group has
three dependencies which will all get resolved and installed via puppet.  This allows you to create
install groups that can even depend on other install groups to install any number of applications.

```yaml
cots::app_metadata:
  name: developer
  dependencies: ['winzip', 'atom', '7zip']
  description: 'Group for Development Applications'
  entry_type: group
```


## Dependency Resolution
In order to resolve all of the app's dependencies we need to run the app metadata through a special 
function called: cots::resolve('app_name').  This function will return a hash of all the apps and their metadata
to be used in a each loop. 