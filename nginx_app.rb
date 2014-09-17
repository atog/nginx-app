#!/usr/bin/env ruby

nginx_sites_path = ARGV[0] || "/usr/local/etc/nginx/sites"
name = Dir.pwd.split(File::SEPARATOR).last
conf = File.join(nginx_sites_path, "#{name}.dev.conf")
File.open(conf, "w+") do |f|
  f.puts(DATA.read % [name, name, name, Dir.pwd, name])
end
File.open(File.join(Dir.pwd, "Procfile.local"), "w+") do |f|
  f.puts "web: bundle exec puma -b unix:/tmp/#{name}.sock"
end

__END__

upstream %s {
  server unix:/tmp/%s.sock;
}

server {
    listen      80;
    server_name %s.dev;
    client_max_body_size 4G;
    keepalive_timeout 5;

    root %s/public;

    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_pass_header X-Accel-Redirect;
        proxy_read_timeout 300s;
        if (!-f $request_filename) {
          proxy_pass http://%s;
          break;
        }
    }
}
