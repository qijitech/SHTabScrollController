#
# Be sure to run `pod lib lint SHTabScrollController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'SHTabScrollController'
s.version          = '0.3.3'
s.summary          = 'Inspired by Netease News.'
s.homepage         = 'https://github.com/harushuu/SHTabScrollController'
s.screenshots      = 'https://github.com/harushuu/SHTabScrollController/raw/master/Screenshots.gif'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { '@harushuu' => 'hunter4n@gmail.com' }
s.source           = { :git => 'https://github.com/harushuu/SHTabScrollController.git', :tag => s.version }
s.platform     = :ios, '8.0'
s.requires_arc = true
s.source_files = 'SHTabScrollController/*'
s.frameworks = 'UIKit'
s.dependency 'SHButton', '~> 0.1.8'
end
