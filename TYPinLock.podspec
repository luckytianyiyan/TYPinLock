#
# Be sure to run `pod lib lint TYPinLock.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TYPinLock'
  s.version          = '0.1.0'
  s.summary          = 'A sample pinlock.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#   s.description      = <<-DESC
# TODO: Add long description of the pod here.
#                        DESC

  s.homepage         = 'https://github.com/luckytianyiyan/TYPinLock'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luckytianyiyan' => 'luckytianyiyan@wacai.com' }
  s.source           = { :git => 'https://github.com/luckytianyiyan/TYPinLock.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/luckytianyiyan'

  s.ios.deployment_target = '7.0'

  s.source_files = 'TYPinLock/Classes/**/*'
  s.private_header_files = 'TYPinLock/Classes/private/*.h'

  s.resource_bundles = {
    'TYPinLock' => ['TYPinLock/Assets/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'LocalAuthentication'
  # s.dependency 'AFNetworking', '~> 2.3'
end
