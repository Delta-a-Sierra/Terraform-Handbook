control 'operating_system' do
  title 'Operating system controls'
  desc "Checks that the host's operating system is correctly configured."
  tag 'operating_system', 'ubuntu'
  describe command('lsb_release -a') do
    its('stdout') { should match (/Ubuntu 16.04/) }
  end
end

control 'operating_system' do
  title 'Checks services'
  desc "Checks services are enabled and running."
  services = [ 'cron', 'rsyslog' ]
  services.each do |service|
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end 
  end
end