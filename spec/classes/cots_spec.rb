require 'spec_helper'
require 'shared_contexts'

describe 'cots' do
  # by default the hiera integration uses hiera data from the shared_contexts.rb file
  # but basically to mock hiera you first need to add a key/value pair
  # to the specific context in the spec/shared_contexts.rb file
  # Note: you can only use a single hiera context per describe/context block
  # rspec-puppet does not allow you to swap out hiera data on a per test block
  #include_context :hiera

  # below is the facts hash that gives you the ability to mock
  # facts on a per describe/context block.  If you use a fact in your
  # manifest you should mock the facts below.
  let(:facts) do
    {}
  end

  # below is a list of the resource parameters that you can override.
  # By default all non-required parameters are commented out,
  # while all required parameters will require you to add a value
  let(:params) do
    {
      :requested_apps => ['developer'],

    }
  end
  # add these two lines in a single test block to enable puppet and hiera debug mode


  it do
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
    is_expected.to contain_cots__application("winzip")
        .with({
            :entry_type => 'item',
            :installer_location => 'http://download.winzip.com/gl/nkln/winzip21.exe',
            :installer_provider => 'windows',
            :description => 'Unzip utility',
            :dependencies => [],
            :package_name => 'winzip',
          })
  end

  it do
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
    is_expected.to contain_cots__application("7zip")
        .with({
            :entry_type => 'item',
            :installer_location => 'http://www.7-zip.org/a/7z1604-x64.exe',
            :installer_provider => 'windows',
            :description => 'Unzip utility',
            :dependencies => [],
            :package_name => '7zip',
          })
  end

  it do
    Puppet::Util::Log.level = :debug
    Puppet::Util::Log.newdestination(:console)
    is_expected.to contain_cots__application("atom")
        .with({
            :entry_type => 'item',
            :installer_location => 'https://github.com/atom/atom/releases/download/v1.12.3/atom-windows.zip',
            :installer_provider => 'windows',
            :description => 'Code Editor',
            :dependencies => ['7zip'],
            :package_name => 'atom',
          })
  end

end
