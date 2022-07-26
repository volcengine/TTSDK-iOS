#!/usr/bin/ruby

require 'xcodeproj'

include Xcodeproj::Project::Object

command = ARGV.first
version = ARGV[1]
scripts_dir = File.dirname(__FILE__)
puts __FILE__ + " command is #{command}"

usage = <<-EOF
Usage:
    $ ruby dynamic_library_env.rb COMMAND
Commands:
    setup           $ ruby ttsdk.rb setup [VERSION]       Setup dynamic library dependant environment with specific version
    clean           $ ruby ttsdk.rb clean                 Clean dynamic library dependant environment
EOF

if command == "help" or command.nil?
  puts usage
else
  display_name = "TTSDKFramework.framework"
  display_image_name = "TTSDKImageFramework.framework"
  IO.readlines(File.join(scripts_dir, "../../TTSDK.podspec")).each { |line| version = line.chop.split("=")[-1].strip[1...-1] if line =~ /spec\.version\s*\=\s*\".*\"/ } if version.nil?
  lib_download_url = "http://sf1-hscdn-tos.pstatp.com/obj/cloud-common/ttsdk/iOS/TTSDKFramework-#{version}-ta.zip"
  project_path = File.join(scripts_dir, "../TTSDKDemo.xcodeproj")
  project = Xcodeproj::Project.open(project_path)
  target = project.targets.select { |target| target.name == "TTSDKDemo" }.first
  group = project.groups.select { |group| group.display_name == "extern" }.first

  file_reference = project.objects.select { |object| object.display_name == display_name and object.instance_of? PBXFileReference }.first
  image_file_reference = project.objects.select { |object| object.display_name == display_image_name and object.instance_of? PBXFileReference }.first
  ##
  build_file = project.objects.select { |object| object.display_name == display_name and object.instance_of? PBXBuildFile }.first
  image_build_file = project.objects.select { |object| object.display_name == display_image_name and object.instance_of? PBXBuildFile }.first

  copy_files_build_phases = target.copy_files_build_phases.select { |build_phase| build_phase.name == "Embed Frameworks" }.first

  if command == "setup"
    puts "dynamic library environment will be setup..."
    if file_reference.nil?
      file_reference = group.new_reference(display_name)
      image_file_reference = group.new_reference(display_image_name)
    end
  
    if build_file.nil?
      build_file = copy_files_build_phases.add_file_reference(file_reference)
      build_file.settings = {
        "ATTRIBUTES" => [ 
          :CodeSignOnCopy, 
          :RemoveHeadersOnCopy,
        ]
      }
      #
      image_build_file = copy_files_build_phases.add_file_reference(image_file_reference)
      image_build_file.settings = {
        "ATTRIBUTES" => [ 
          :CodeSignOnCopy, 
          :RemoveHeadersOnCopy,
        ]
      }
    end
    unless File.exist?(file_reference.real_path)
      system <<-EOF
        echo "start to download library from #{lib_download_url}..."
        curl #{lib_download_url} -o #{file_reference.real_path}.zip
        unzip -o -d #{group.real_path} #{file_reference.real_path}.zip
        rm -rf #{file_reference.real_path}.zip
      EOF
    end
    puts "dynamic library environment did setup..."
  elsif command == "clean"
    puts "begin to clean dynamic library environment..."
    unless file_reference.nil?
      FileUtils.rm_rf(file_reference.real_path)
      copy_files_build_phases.remove_file_reference(file_reference)
      copy_files_build_phases.remove_file_reference(image_file_reference)
      file_reference.remove_from_project()
      image_file_reference.remove_from_project()
    end
    puts "cleaning dynamic library environment finished..."
  end

  project.save
end