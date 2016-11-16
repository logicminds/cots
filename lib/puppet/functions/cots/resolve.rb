# extremely helpful documentation
# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:'cots::resolve') do
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet 4 will enforce these
  # change x and y to suit your needs although only one parameter is required
  def resolve(apps)
    @metadata = {}
    resolved = []
    apps.map do | app |
      node = lookup(app)
      dep_resolve(node, resolved, [])
    end
    resolved
  end

  # https://www.electricmonk.nl/log/2008/08/07/dependency-resolving-algorithm/
  def dep_resolve(node, resolved, unresolved)
    unresolved.push(node)
    node['dependencies'].each  do | edge |
      edge_node = lookup(edge)  # gets metadata about node
      unless resolved.include?(edge_node)
        if unresolved.include?(edge_node)
          Puppet.err(sprintf('Circular reference detected: %s > %s', node.name, edge_node.name))
        end
        dep_resolve(edge_node, resolved, unresolved)
      end
    end
    resolved.push(node)
    unresolved.delete(node)
  end

  # lookup app name either in the file or if already cached look in the metadata
  # variable
  def lookup(app_name)
    unless @metadata.key?(app_name)
      data = YAML.load_file("./data/applications/#{app_name}.yaml")
      @metadata[app_name] = data['cots::app_metadata']
    end
    @metadata[app_name]
  end

end
