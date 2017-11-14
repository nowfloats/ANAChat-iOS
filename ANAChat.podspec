#
# Be sure to run `pod lib lint ANAChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ANAChat'
  s.version          = '0.2.7'
  s.summary          = 'ANAChat iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The Powerful **ANAChat**  iOS SDK allows you to integrate ANA to your app. Customise the UI according to your App Theme and you are all set. It is that simple!
DESC

  s.homepage         = 'https://github.com/Kitsune-tools/ANAChat-iOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'GNU LESSER GENERAL PUBLIC LICENSE', :file => 'LICENSE' }
  s.author           = { 'RakeshTatekonda' => 'rakesh.tatekonda@nowfloats.com' }
  s.source           = { :git => 'https://github.com/Kitsune-tools/ANAChat-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }

  s.ios.deployment_target = '8.0'
  s.source_files = 'ANAChat/Classes/**/*.{h,m,swift}'
  s.resource_bundles = {
     'ANAChat' => ['ANAChat/Classes/**/*.{storyboard,xib,xcassets,json,imageset,png,xcdatamodeld}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit'
    s.dependency 'Firebase/Messaging'
end
