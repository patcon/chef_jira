require 'spec_helper'

describe 'chef_jira::apache2' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
