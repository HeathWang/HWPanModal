#
# Be sure to run `pod lib lint HWPanModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWPanModal'
  s.version          = '0.9.7'
  s.summary          = 'HWPanModal is used to present controller and drag to dismiss.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HWPanModal presents controller from bottom and drag to dismiss, high customize.
                       DESC

  s.homepage         = 'https://github.com/HeathWang/HWPanModal'
  s.license          = { :type => 'MIT'}
  s.author           = { 'heathwang' => 'yishu.jay@gmail.com' }
  s.source           = { :git => 'https://github.com/HeathWang/HWPanModal.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = ['Sources/**/*']
  s.public_header_files = ['Sources/**/*.h']
  
end
