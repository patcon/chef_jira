require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'chef_jira::default' do
  include Helpers::Jira
end
