require 'yaml'

apps = ['developer']

def initialize
  @metadata = {}
end

def resolve(apps)
  resolved = []
  apps.map do | app |
    node = lookup(app)
    dep_resolve(node, resolved, [])
  end
  puts resolved.map { |app| app['name']}
end

# https://www.electricmonk.nl/log/2008/08/07/dependency-resolving-algorithm/
def dep_resolve(node, resolved, unresolved)
  unresolved.push(node)
  node['dependencies'].each  do | edge |
    edge_node = lookup(edge)  #gets metadata about node
    unless resolved.include?(edge_node)
      if unresolved.include?(edge_node)
        raise Exception
        #raise Exception('Circular reference detected: %s -&gt; %s' % (node.name, edge_node.name))
      end
      dep_resolve(edge_node, resolved, unresolved)
    end
  end
  resolved.push(node)
  unresolved.delete(node)
end

def lookup(app_name)
  unless @metadata.key?(app_name)
    data = YAML.load_file("./data/applications/#{app_name}.yaml")
    @metadata[app_name] = data['cots::app_metadata']
  end
  @metadata[app_name]
end

resolve(apps)
