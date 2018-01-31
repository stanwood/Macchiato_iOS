#
# Be sure to run `pod lib lint STWUITestingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'StanwoodUITesting'
  s.version          = '0.1.3'
  s.summary          = 'Stanwood iOS UITesting Tool'
  s.description      = <<-DESC
Stanwood iOS UITesting tool
                       DESC

  s.homepage         = 'https://github.com/stanwood/STWUITestingKit'
  s.license          = { :type => 'Private', :file => 'LICENSE' }
  s.author           = { 'talezion' => 'developer@stanwood.io' }
  s.source           = { :git => 'https://github.com/stanwood/STWUITestingKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'STWUITestingKit/Classes/**/*'
  s.frameworks = 'XCTest'
end
