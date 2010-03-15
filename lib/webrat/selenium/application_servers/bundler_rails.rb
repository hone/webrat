require "webrat/selenium/application_servers/rails"

module Webrat
  module Selenium
    module ApplicationServers
      class BundlerRails < Webrat::Selenium::ApplicationServers::Rails

        def start_command
        "bundle exec mongrel_rails start -d --chdir='#{RAILS_ROOT}' --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} --pid #{pid_file} &"
        end

        def stop_command
        "bundle exec mongrel_rails stop -c #{RAILS_ROOT} --pid #{pid_file}"
        end

      end
    end
  end
end
