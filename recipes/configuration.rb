settings = Jira.settings(node)

directory node['jira']['home_path'] do
  owner node['jira']['user']
  action :create
  recursive true
end

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner node['jira']['user']
  mode '0644'
  variables :database => settings['database']
  notifies :restart, 'service[jira]', :delayed unless node['jira']['install_type'] == 'war'
end

subdir = (node['jira']['install_type'] == 'war') ? 'edit-webapp' : 'atlassian-jira'

template "#{node['jira']['install_path']}/#{subdir}/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  owner node['jira']['user']
  mode '0644'
  notifies :restart, 'service[jira]', :delayed
end
