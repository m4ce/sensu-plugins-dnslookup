#!/usr/bin/env ruby
#
# check-dnslookup.rb
#
# Author: Matteo Cerutti <matteo.cerutti@hotmail.co.uk>
#

require 'sensu-plugin/check/cli'
require 'resolv'

class CheckDnsLookUp < Sensu::Plugin::Check::CLI
  @@types = ["A", "PTR", "SRV", "CNAME", "SOA", "MX", "NS", "TXT"]

  option :domain,
         :description => "Domain to look up",
         :short => "-d <DOMAIN>",
         :long => "--domain <DOMAIN>",
         :required => true

  option :type,
         :description => "Record type (default: A)",
         :short => "-t <TYPE>",
         :long => "--type <TYPE>",
         :in => @@types,
         :proc => proc(&:upcase),
         :default => "A"

  option :server,
         :description => "Comma separated list of name server(s) for resolution",
         :short => "-s <SERVER>",
         :long => "--server <SERVER>",
         :proc => proc { |s| s.split(',') },
         :default => []

  option :timeout,
         :description => "DNS lookup timeout (default: 3)",
         :short => "-t <SECONDS>",
         :long => "--timeout <SECONDS>",
         :proc => proc(&:to_i),
         :default => 3

  option :warn,
         :description => "Warn instead of throwing a critical failure",
         :short => "-w",
         :long => "--warn",
         :boolean => true,
         :default => false

  def initialize()
    super
  end

  def run()
    query_type = Kernel.const_get("Resolv::DNS::Resource::IN::#{config[:type]}")

    if config[:server].size > 0
      dnsconf = {
        :nameserver => config[:server],
        :search => '',
        :ndots => 1,
      }
    else
      dnsconf = nil
    end

    dns = Resolv::DNS.new(dnsconf)
    dns.timeouts = 3

    begin
      resp = dns.getresource(config[:domain], query_type).inspect
      ok("Resolved #{config[:type]} record #{config[:domain]}")
      dns.close
    rescue
      dns.close
      message("Failed to look up #{config[:type]} record #{config[:domain]} (#{$!})")
      if config[:warn]
        warning
      else
        critical
      end
    end
  end
end
