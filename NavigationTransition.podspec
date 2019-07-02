#
# Be sure to run `pod lib lint NavigationTransition.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NavigationTransition'
  s.version          = '1.1.2'
  s.summary          = 'Deal with navigation transition and custom navigation bar.'

  s.homepage         = 'https://github.com/DouKing/NavigationTransition'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DouKing' => 'wyk8916@gmail.com' }
  s.source           = { :git => 'https://github.com/DouKing/NavigationTransition.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NavigatinTransition/Transition/**/*'
  
  # s.resource_bundles = {
  #   'NavigationTransition' => ['NavigationTransition/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

end
