#!/usr/bin/env ruby
require "rubygems"
require "mustache"

class NginxApp < Mustache
  self.path = "~/Working/ruby/nginx-app/"
  self.template_extension = 'conf'

  attr_accessor :name, :port

  def initialize(name, port)
    @name, @port = name, port
  end

  def app_path
    Dir.pwd
  end

end

if $0 == __FILE__
  nginx_sites_path = "/usr/local/etc/nginx/sites"
  name = "#{Dir.pwd.split(File::SEPARATOR).last}.dev"
  conf = File.join(nginx_sites_path, "#{name}.conf")
  port = 8000 + (Dir.glob("#{nginx_sites_path}/*") - [conf]).length
  File.open(conf, "w+") do |f|
    f.puts NginxApp.new(name, port).to_text
  end
  File.open(File.join(Dir.pwd, "Procfile"), "w+") do |f|
    f.puts "web: bundle exec unicorn -p #{port}"
  end
end