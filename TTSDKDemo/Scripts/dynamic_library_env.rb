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
  file_reference_list = [
    "TTSDKFramework.framework",
    "TTSDKImageFramework.framework",
    "byteaudio.framework",
    "VolcEngineRTC.framework",
    "TTFFmpeg.framework",
    "boringssl.framework",
    "crypto.framework",
    "libvcn.framework",
    "ffmpeg_dashdec.framework",
    "effect-sdk.framework",
  ]

  #
  IO.readlines(File.join(scripts_dir, "../../TTSDK.podspec")).each { |line| version = line.chop.split("=")[-1].strip[1...-1] if line =~ /spec\.version\s*\=\s*\".*\"/ } if version.nil?
  lib_download_url = "http://sf1-hscdn-tos.pstatp.com/obj/cloud-common/ttsdk/iOS/TTSDKFramework-#{version}-ta.zip"

  project_path = File.join(scripts_dir, "../TTSDKDemo.xcodeproj")
  # project setup
  project = Xcodeproj::Project.open(project_path)
  target = project.targets.select { |target| target.name == "TTSDKDemo" }.first
  group = project.groups.select { |group| group.display_name == "extern" }.first

  unless Dir.exist?(File.join(group.real_path, "TTSDKFramework.framework"))
    # Download Framework
    system <<-EOF
      echo "start to download library from #{lib_download_url}..."
      curl #{lib_download_url} -o #{group.real_path}/TTSDKFramework-ta.zip
      unzip -o -d #{group.real_path} #{group.real_path}/TTSDKFramework-ta.zip
      rm -rf #{group.real_path}/TTSDKFramework-ta.zip
    EOF
  end

  copy_files_build_phases = target.copy_files_build_phases.select { |build_phase| build_phase.name == "Embed Frameworks" }.first
  file_reference_list.each { |reference|
    if command == "setup"
      r = group.new_reference(reference)
      if Dir.exist?(r.real_path)
        puts "Add #{reference}"
        build_file = copy_files_build_phases.add_file_reference(r)
        build_file.settings = {
          "ATTRIBUTES" => [ 
            :CodeSignOnCopy, 
            :RemoveHeadersOnCopy,
          ]
        }
      end
    elsif command == "clean" 
      unless reference.nil?
        FileUtils.rm_rf(reference.real_path)
        copy_files_build_phases.remove_file_reference(reference)
        reference.remove_from_project()
      end
    end
  }
  project.save
end