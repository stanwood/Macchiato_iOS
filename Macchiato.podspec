Pod::Spec.new do |s|
  s.name             = 'Macchiato'
  s.version          = '0.5'
  s.summary          = 'UITesting tool that runs your tests from a simple JSON file'
  s.description      = <<-DESC
Stanwood iOS UITesting tool
                       DESC

  s.homepage         = 'https://github.com/stanwood/Macchiato_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stanwood' => 'ios.frameworks@stanwood.io' }
  s.source           = { :git => 'https://github.com/stanwood/Macchiato_iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  
  s.source_files = 'Macchiato/Classes/**/*'
  s.frameworks = 'XCTest'
end
