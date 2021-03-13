#!/usr/bin/ruby

command = ARGV.first
version = ARGV[1]
scripts_dir = File.dirname(__FILE__)
puts __FILE__ + " command is #{command}"

usage = <<-EOF
Usage:
    $ ruby static_library_env.rb COMMAND
Commands:
    setup           $ ruby ttsdk.rb setup                 Setup static library dependant environment with specific version
    clean           $ ruby ttsdk.rb clean                 Clean static library dependant environment
EOF

if command == "help" or command.nil?
  puts usage
else
  podfile = File.join(scripts_dir, "../Podfile")
  if command == "setup"
    IO.write(podfile, File.open(podfile) do |f|
        f.read.gsub(/^\s*#\s*ttsdk_pods/) { |matched| matched.gsub(/#\s*ttsdk_pods/, "ttsdk_pods") }
      end
    )
    unless version.nil?
      replacement =  version == "local" ? ":path => \'..\'" : "\'#{version}\'"
      IO.write(podfile, File.open(podfile) do |f|
          f.read.gsub(/^\s*pod\s*\'TTSDK\',\s*(\'.*\'|:path\s*=>\s*\'..\'),\s*:subspecs/) do |matched| 
            matched.gsub(/pod\s*\'TTSDK\',\s*(\'.*\'|:path\s*=>\s*\'..\'),\s*:subspecs/, "pod \'TTSDK\', #{replacement}, :subspecs") 
          end
        end
      )
    end
  elsif command == "clean"
    IO.write(podfile, File.open(podfile) do |f|
        f.read.gsub(/^\s*ttsdk_pods/) { |matched| matched.gsub(/ttsdk_pods/, "# ttsdk_pods") }
      end
    )
  end
end