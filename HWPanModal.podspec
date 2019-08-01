#
# Be sure to run `pod lib lint HWPanModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWPanModal'
  s.version          = '0.2.9.6'
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

  s.source_files = ['HWPanModal/Classes/Layout/**/*', 'HWPanModal/Classes/Animator/**/*', 'HWPanModal/Classes/Controller/**/*',
                    'HWPanModal/Classes/Delegate/**/*', 'HWPanModal/Classes/Presentable/**/*', 'HWPanModal/Classes/Presenter/**/*',
                    'HWPanModal/Classes/View/**/*', 'HWPanModal/Classes/HWPanModal.h']
  s.public_header_files = ['HWPanModal/Classes/HWPanModal.h', 'HWPanModal/Classes/Presentable/HWPanModalPresentable.h', 'HWPanModal/Classes/Presentable/HWPanModalHeight.h',
                           'HWPanModal/Classes/Presentable/UIViewController+PanModalDefault.h', 'HWPanModal/Classes/Presenter/UIViewController+PanModalPresenter.h', 'HWPanModal/Classes/Presenter/HWPanModalPresenterProtocol.h',
                           'HWPanModal/Classes/Presentable/UIViewController+Presentation.h', 'HWPanModal/Classes/Animator/HWPresentingVCAnimatedTransitioning.h']
  s.dependency 'KVOController'
  
end
