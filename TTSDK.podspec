Pod::Spec.new do |spec|

    spec.name         = "TTSDK"
    spec.version      = "1.0.6.0"
    spec.summary      = "A short description of TTSDK."
    spec.description  = <<-DESC
      A long description of TTSDK.
                     DESC
  
    spec.homepage     = "https://github.com/volcengine/TTSDK-iOS"
  
    spec.license      = "MIT"
  
    spec.author       = { "chenzhaojie" => "chenzhaojie@bytedance.com" }
    spec.platform     = :ios, "8.0"
  
    spec.source       = { :git => 'git@github.com:volcengine/TTSDK-iOS.git', :tag => "#{spec.version}" }
  
    spec.subspec 'Core' do |subspec|
      subspec.public_header_files = [
        'TTSDK/VCloudPandora/**/*.h',
      ]
      subspec.source_files = [
        'TTSDK/VCloudPandora/**/*',
      ]
      subspec.vendored_libraries = [
        'TTSDK/VCloudPandora/**/*.a',
        'TTSDK/TTVideoSetting/**/*.a',
      ]
      subspec.frameworks = [
        'CoreMotion',
        'CoreMedia',
        'MetalKit',
        'OpenAL',
        'VideoToolBox',
        'AudioToolBox',
        'AVFoundation',
      ]
      subspec.libraries = 'stdc++', 'z', 'xml2', 'iconv'
    end

    spec.subspec 'PlayerCore' do |subspec|
      subspec.public_header_files = [
        'TTSDK/TTPlayerSDK/TTPlayerSDK/TTPlayer/TTPlayerDef.h',
      ]
      subspec.source_files = [
        'TTSDK/TTPlayerSDK/TTPlayerSDK/TTPlayer/TTPlayerDef.h',
      ]
      subspec.vendored_libraries = [
        'TTSDK/TTPlayerSDK/**/*.a',
        'TTSDK/audiosdk/**/*.a',
        'TTSDK/boringssl/**/*.a',
      ]
      subspec.resources = [
        'TTSDK/TTPlayerSDK/TTPlayerSDK/Assets/ttplayer.metallib',
      ]
    end
  
    spec.subspec 'LivePull' do |subspec|
      subspec.public_header_files = [
        'TTSDK/TTVideoLive/**/*.h',
      ]
      subspec.source_files = [
        'TTSDK/TTVideoLive/**/*',
      ]
      subspec.vendored_libraries = [
        'TTSDK/TTVideoLive/**/*.a',
      ]
      subspec.dependency 'TTSDK/PlayerCore'
    end
  
    spec.subspec 'LivePush' do |subspec|
      subspec.public_header_files = [
        'TTSDK/LiveStreamFramework/prj/ios/LiveStreamFramework/**/*.h',
      ]
      subspec.source_files = [
        'TTSDK/LiveStreamFramework/**/*',
      ]
      subspec.vendored_libraries = [
        'TTSDK/LiveStreamFramework/**/*.a',
      ]
      subspec.frameworks = [
        'VideoToolBox',
      ]
    end
  
    spec.subspec 'Player' do |subspec|
      subspec.public_header_files = [
        'TTSDK/TTVideoEngine/**/*.h',
      ]
      subspec.source_files = [
        'TTSDK/TTVideoEngine/**/*',
      ]
      subspec.exclude_files = [
        'TTSDK/TTVideoEngine/TTVideoEngine/Classes/License/TTLicenseManager.h',
      ]
      subspec.vendored_libraries = [
        'TTSDK/TTVideoEngine/**/*.a',
        'TTSDK/TTTopSignature/**/*.a',
        'TTSDK/MDLMediaDataLoader/**/*.a',
      ]
      subspec.dependency 'TTSDK/PlayerCore'
    end
  
  end
  
