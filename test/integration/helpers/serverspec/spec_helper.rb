require 'serverspec'
require 'json'

set :backend, :exec

$node = ::JSON.parse(File.read('/tmp/test-helper/node.json'))

shared_examples_for 'postgresql' do
  $node['postgresql']['server']['packages'].each do |pkg|
    describe package(pkg) do
      its(:version) { should >= '9.0' }
    end
  end

  describe port(5432) do
    it { should be_listening }
  end
end

shared_examples_for 'jira behind the apache proxy' do
  describe 'Tomcat' do
    describe port(8080) do
      it { should be_listening }
    end

    describe command("curl --noproxy localhost 'http://localhost:8080/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA * setup'") do
      its(:exit_status) { should eq 0 }
    end
  end

  describe 'Apache2' do
    describe port(80) do
      it { should be_listening }
    end

    describe port(443) do
      it { should be_listening }
    end

    describe command("curl --location --insecure --noproxy localhost 'http://localhost/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA * setup'") do
      its(:exit_status) { should eq 0 }
    end

    describe command("curl --insecure --noproxy localhost 'https://localhost/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA * setup'") do
      its(:exit_status) { should eq 0 }
    end
  end
end
