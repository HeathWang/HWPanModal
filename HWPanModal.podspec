#
# Be sure to run `pod lib lint HWPanModal.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HWPanModal'
  s.version          = '0.3.2.1'
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

  s.source_files = ['HWPanModal/Classes/**/*']
  s.public_header_files = ['HWPanModal/Classes/HWPanModal.h',
                           'HWPanModal/Classes/Presentable/HWPanModalPresentable.h',
                           'HWPanModal/Classes/Presentable/HWPanModalHeight.h',
                           'HWPanModal/Classes/Presentable/UIViewController+PanModalDefault.h',
                           'HWPanModal/Classes/Presenter/UIViewController+PanModalPresenter.h',
                           'HWPanModal/Classes/Presenter/HWPanModalPresenterProtocol.h',
                           'HWPanModal/Classes/Presentable/UIViewController+Presentation.h',
                           'HWPanModal/Classes/Animator/HWPresentingVCAnimatedTransitioning.h',
                           'HWPanModal/Classes/View/HWPanIndicatorView.h',
                           'HWPanModal/Classes/View/HWPanModalIndicatorProtocol.h',
                           'HWPanModal/Classes/Category/UINavigationController+HWPanModal.h'
                           ]
  s.dependency 'KVOController'
  
end
