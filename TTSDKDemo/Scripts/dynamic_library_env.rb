#!/usr/bin/ruby

require 'xcodeproj'

include Xcodeproj::Project::Object

command = ARGV.first
puts __FILE__ + " command is #{command}"

usage = <<-EOF
Usage:
    $ ruby dynamic_library_env.rb COMMAND
Commands:
    setup           $ ruby ttsdk.rb setup       Setup dynamic library dependant environment
    clean           $ ruby ttsdk.rb clean       Clean dynamic library dependant environment
EOF

if command == "help"
  puts usage
else
  display_name = "TTSDKFramework.framework"
  scripts_dir = File.dirname(__FILE__)
  project_path = File.join(scripts_dir, "../TTSDKDemo.xcodeproj")
  project = Xcodeproj::Project.open(project_path)
  target = project.targets.select { |target| target.name == "TTSDKDemo" }.first
  group = project.groups.select { |group| group.display_name == "extern" }.first

  file_reference = project.objects.select { |object| object.display_name == display_name and object.instance_of? PBXFileReference }.first
  build_file = project.objects.select { |object| object.display_name == display_name and object.instance_of? PBXBuildFile }.first

  if file_reference.nil? || build_file.nil?
    puts "dynamic library environment will be setup..."
  else
    puts "dynamic library environment is ok..."
  end

  if file_reference.nil?
    file_reference = group.new_reference(display_name)
    # puts file_reference.inspect
  end

  if build_file.nil?
    copy_files_build_phases = target.copy_files_build_phases.select { |build_phase| build_phase.name == "Embed Frameworks" }.first
    build_file = copy_files_build_phases.add_file_reference(file_reference)
    build_file.settings = {
      "ATTRIBUTES" => [ 
        :CodeSignOnCopy, 
        :RemoveHeadersOnCopy,
      ]
    }
    # puts build_file.inspect
  end

  project.save
end