
# HWPanModal 👍
<p style="align: left">
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/cocoapods/v/HWPanModal.svg?style=flat">
    </a>
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/cocoapods/p/HWPanModal.svg?style=flat">
    </a>
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/badge/support-ios%208%2B-orange.svg">
    </a>
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/badge/language-objective--c-blue.svg">
    </a>
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/cocoapods/l/HWPanModal.svg?style=flat">
    </a>
</p>


HWPanModal is used to present controller and drag to dismiss.

Inspired by [**PanModal**](https://github.com/slackhq/PanModal), thanks.

**My another project for pop controller:**[**HWPopController**](https://github.com/HeathWang/HWPopController)
[_中文文档说明_](https://github.com/HeathWang/HWPanModal/blob/master/README-CN.md)

## Snapshoot

<div style="text-align: center">
    <table>
        <tr>
            <th>Basic</th>
            <th>Blur background</th>
            <th>Keyboard handle</th>
            <th>App demo</th>          
        </tr>
        <tr>
            <td style="text-align: center">
            <img src="https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal_example.gif" width="200" />
            </td>
            <td style="text-align: center">
            <img src="https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal_example_3.gif" width="200"/>
            </td>
            <td style="text-align: center">
            <img src="https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal_example_4.gif" width="200"/>
            </td>
            <td style="text-align: center">
            <img src="https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal_example_2.gif" width="200"/>
            </td>
        </tr>
    </table>
</div>


## Features
1. Supports any type of `UIViewController`
2. Seamless transition between modal and content
3. Support two kinds of GestureRecognizer
    1. UIPanGestureRecognizer, direction is UP & Down.
    2. UIScreenEdgePanGestureRecognizer, you can swipe on screen edge to dismiss controller. 
4. Support write your own animation for presenting VC.
5. Support config animation `Duration`, `AnimationOptions`, `springDamping`.
6. Support config background alpha or `blur` background. Note: Dynamic change blur effect ONLY works on iOS9.0+.
7. Show / hide corner, indicator.
8. Auto handle UIKeyboard show/hide.

More config pls see [_HWPanModalPresentable.h_](https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal/Classes/Presentable/HWPanModalPresentable.h) declare.

## TODO

* [x] Handle keyboard show&dismiss.
* ~~Touch event can response to presenting VC.~~

## Compatibility
**iOS 8.0+**, support Objective-C & Swift.

### Dependency

[KVOController - facebook](https://github.com/facebook/KVOController)

Because Objective-C KVO is hard to use, so I use KVOController = =

## Installation
<a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>

```ruby
pod 'HWPanModal', '~> 0.2.9.3'
```

## How to use

### How to present from bottom
Your UIViewController need to conform `HWPanModalPresentable`. If you use default, nothing more will be written.

```Objective-C
#import <HWPanModal/HWPanModal.h>
@interface HWBaseViewController () <HWPanModalPresentable>

@end

@implementation HWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - HWPanModalPresentable
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeMaxTopInset, 44);
}
@end
```

Where you need to present this Controller.

```Objective-C
#import <HWPanModal/HWPanModal.h>
[self presentPanModal:[HWBaseViewController new]];
```

yeah! Easy.

### Change state, scrollView contentOffset, reload layout

When You present you Controller, you can change the UI.
Refer to `UIViewController+Presentation.h`.
* Change the state between short and long form. call `- (void)hw_panModalTransitionTo:(PresentationState)state;`
* Change ScrollView ContentOffset. call `- (void)hw_panModalSetContentOffset:(CGPoint)offset;`
* Reload layout. call `- (void)hw_panModalSetNeedsLayoutUpdate;`

### Custom Presenting VC Animation

Some guys want to animate Presenting VC when present/dismiss.
1. Create object conforms `HWPresentingViewControllerAnimatedTransitioning` .

    ```Objective-C
    
    @interface HWMyCustomAnimation : NSObject <HWPresentingViewControllerAnimatedTransitioning>
    
    @end
    
    @implementation HWMyCustomAnimation
    
    
    - (void)presentAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
        NSTimeInterval duration = [transitionContext mainTransitionDuration];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        // replace it.
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromVC.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    - (void)dismissAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
        NSTimeInterval duration = [transitionContext mainTransitionDuration];
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        // replace it.
        [UIView animateWithDuration:duration animations:^{
            toVC.view.transform = CGAffineTransformIdentity;
        }];
    }
    
    @end
    ```
1. Overwrite below two method.

    ```Objective-C
    - (BOOL)shouldAnimatePresentingVC {
        return YES;
    }
    
    - (id<HWPresentingViewControllerAnimatedTransitioning>)customPresentingVCAnimation {
        return self.customAnimation;
    }
    
    - (HWMyCustomAnimation *)customAnimation {
        if (!_customAnimation) {
            _customAnimation = [HWMyCustomAnimation new];
        }
        return _customAnimation;
    }
    ```

## Example

1. Clone this git.
2. open the terminal， go to the `Example` Folder.
3. `pod install --verbose`
4. Double click HWPanModal.xcworkspace, and run.

## Contact Me

Heath Wang
yishu.jay@gmail.com

## Change Log

[Click Me](https://github.com/HeathWang/HWPanModal/blob/master/ChangeLog.md)

## License

<b>HWPanModal</b> is released under a MIT License. See LICENSE file for details.


