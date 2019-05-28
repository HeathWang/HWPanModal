#
# Be sure to run `pod lib lint HWPanModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWPanModal'
  s.version          = '0.2.6'
  s.summary          = 'HWPanModal is used to present controller and drag to dismiss.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HWPanModal is used to present controller and drag to dismiss. Inspire to PanModal.
                       DESC

  s.homepage         = 'https://github.com/HeathWang/HWPanModal'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'heathwang' => 'yishu.jay@gmail.com' }
  s.source           = { :git => 'https://github.com/HeathWang/HWPanModal.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HWPanModal/Classes/**/*'
  s.public_header_files = 'HWPanModal/Classes/**/*.h'
  s.dependency 'KVOController'
  
  # s.resource_bundles = {
  #   'HWPanModal' => ['HWPanModal/Assets/*.png']
  # }

  # s.frameworks = 'UIKit', 'MapKit'
  
end
