require 'spec_helper'
require 'json'

$node = ::JSON.parse(File.read('/tmp/test-helper/node.json'))

describe 'Java' do
  describe command('java -version 2>&1') do
    its(:exit_status) { should eq 0 }
  end
end

describe 'Postgresql' do
  describe command('psql --version') do
    its(:stdout) { should contain($node['postgresql']['version']) }
  end

  describe port(5432) do
    it { should be_listening }
  end
end

describe 'JIRA' do
  it_behaves_like 'jira behind the apache proxy'
end
