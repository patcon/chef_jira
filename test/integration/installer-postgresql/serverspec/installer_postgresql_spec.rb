require 'spec_helper'
require 'json'

$node = ::JSON.parse(File.read('/tmp/test-helper/node.json'))

describe 'Postgresql' do
  $node['postgresql']['client']['packages'].each do |pkg|
    describe package(pkg) do
      its(:version) { should >= '9.0' }
    end
  end

  describe port(5432) do
    it { should be_listening }
  end
end

describe 'JIRA' do
  it_behaves_like 'jira behind the apache proxy'
end
