
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
    <a href="https://travis-ci.org/HeathWang/HWPanModal">
       <img src="https://travis-ci.org/HeathWang/HWPanModal.svg?branch=master">
    </a>
    <a href="https://codebeat.co/projects/github-com-heathwang-hwpanmodal-master">
        <img alt="codebeat badge" src="https://codebeat.co/badges/fb96e7ea-2320-4219-8f19-777674a97d0e" />
    </a>
</p>


HWPanModal is used to present controller and drag to dismiss. Similar with iOS13 default present Modal style.

Inspired by [**PanModal**](https://github.com/slackhq/PanModal), thanks.

[_中文文档说明_](https://github.com/HeathWang/HWPanModal/blob/master/README-CN.md)

**My another project for pop controller:**[**HWPopController**](https://github.com/HeathWang/HWPopController)

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
            <img src="images/HWPanModal_example.gif" width="180" />
            </td>
            <td style="text-align: center">
            <img src="images/HWPanModal_example_3.gif" width="180"/>
            </td>
            <td style="text-align: center">
            <img src="images/HWPanModal_example_4.gif" width="180"/>
            </td>
            <td style="text-align: center">
            <img src="images/HWPanModal_example_2.gif" width="180"/>
            </td>
        </tr>
    </table>
</div>

## Index

* <a href="#features">Features</a>
* <a href="#todo">TODO</a>
* <a href="#compatibility">Compatibility</a>
* <a href="#installation">Installation</a>
* <a href="#how-to-use">How to use</a>
* <a href="#example">Example</a>
* <a href="#contact-me">Contact Me</a>
* <a href="#change-log">Change Log</a>


## Features
1. Supports any type of `UIViewController` to present.
2. Support View which inherit from `HWPanModalContentView` to present.
3. Seamless transition between modal and content.
4. Support two kinds of dismissal gestureRecognizer interaction
    1. Pan gesture direction up&down
    2. Pan gesture direction right, you can swipe on screen edge to dismiss controller. 
5. Support write your own animation for presenting VC.
6. Support config animation `Duration`, `AnimationOptions`, `springDamping`.
7. Support config background alpha or `blur` background. Note: Dynamic change blur effect ONLY works on iOS9.0+.
8. Show / hide corner, indicator.
9. Auto handle UIKeyboard show/hide.
10. Hight customize indicator view.
11. Touch event response can pass through to presenting VC.
12. Config presented view shadow style.

More config pls see [_HWPanModalPresentable.h_](https://github.com/HeathWang/HWPanModal/blob/master/Sources/Presentable/HWPanModalPresentable.h) declare.

### What's different between UIViewController and HWPanModalContentView to present ?

From version 0.6.0, this framework support using `HWPanModalContentView` to present from bottom, that means we can add subview(inherit from `HWPanModalContentView`) to the target view that you want to show.

The different is `HWPanModalContentView` is just a view, and support some animations, unlike present ViewController, you will got ViewController life circle, and navigation stack.

`HWPanModalContentView` limit:
* Currently not support screen rotation.
* Not support edge horizontal pan to dismiss.
* Not support customize presentingVC animation. (There is no presentingVC for view).

## TODO

* [x] Handle keyboard show&dismiss.
* [x] High customize indicator view.
* [x] Edge Interactive dismissal can work on full screen and configable distance to left edge.
* [x] Touch event can response to presenting VC, working on it.
* [x] Strip the presented view container view, make it can use directly.

## Compatibility
**iOS 8.0+**, support Objective-C & Swift.

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
pod 'HWPanModal', '~> 0.9.9'
```

## How to use

### How to present UIViewController from bottom
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

### Change state, scrollView contentOffset, reload layout. IMPORTANT!

When You present you Controller, you can change the UI.
Refer to `UIViewController+Presentation.h`.
* Change the state between short and long form. call `- (void)hw_panModalTransitionTo:(PresentationState)state;`
* Change ScrollView ContentOffset. call `- (void)hw_panModalSetContentOffset:(CGPoint)offset;`
* Reload layout. call `- (void)hw_panModalSetNeedsLayoutUpdate;` 
    * **Note: When your scrollable changed it's contentSize, you _MUST_ reload the layout.**


### Custom Presenting VC Animation

Some guys want to animate Presenting VC when present/dismiss.
1. Create object conforms `HWPresentingViewControllerAnimatedTransitioning` .

    ```Objective-C
    
    @interface HWMyCustomAnimation : NSObject <HWPresentingViewControllerAnimatedTransitioning>
    
    @end
    
    @implementation HWMyCustomAnimation
    
    
    - (void)presentAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
        NSTimeInterval duration = [transitionContext transitionDuration];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        // replace it.
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromVC.view.transform = CGAffineTransformMakeScale(0.95, 0.95);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    - (void)dismissAnimateTransition:(id<HWPresentingViewControllerContextTransitioning>)transitionContext {
        // no need for using animating block.
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC.view.transform = CGAffineTransformIdentity;
    }
    
    @end
    ```
1. Overwrite below two method.

    ```Objective-C
    
    - (PresentingViewControllerAnimationStyle)presentingVCAnimationStyle {
        return PresentingViewControllerAnimationStyleCustom;
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
    
### Custom your own indicator view

You just need to create your own UIView, then adopt `HWPanModalIndicatorProtocol`.

In your presented controller, return it:

```Objective-C
- (nullable UIView <HWPanModalIndicatorProtocol> *)customIndicatorView {
    HWTextIndicatorView *textIndicatorView = [HWTextIndicatorView new];
    return textIndicatorView;
}
```

Here is `HWTextIndicatorView` code:

```Objective-C
@interface HWTextIndicatorView : UIView <HWPanModalIndicatorProtocol>

@end

@interface HWTextIndicatorView ()
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation HWTextIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // init the _stateLabel
        [self addSubview:_stateLabel];
    }
    return self;
}


- (void)didChangeToState:(HWIndicatorState)state {
    switch (state) {
        case HWIndicatorStateNormal: {
            self.stateLabel.text = @"Please pull down to dismiss";
            self.stateLabel.textColor = [UIColor whiteColor];
        }
            break;
        case HWIndicatorStatePullDown: {
            self.stateLabel.text = @"Keep pull down to dismiss";
            self.stateLabel.textColor = [UIColor colorWithRed:1.000 green:0.200 blue:0.000 alpha:1.00];
        }
            break;
    }
}

- (CGSize)indicatorSize {
    return CGSizeMake(200, 18);
}

- (void)setupSubviews {
    self.stateLabel.frame = self.bounds;
}

@end

```

### How to use HWPanModalContentView

You should always inherit from `HWPanModalContentView`. `HWPanModalContentView` conforms `HWPanModalPresentable` like the way using UIViewController.

```Objective-C
@interface HWSimplePanModalView : HWPanModalContentView

@end

@implementation HWSimplePanModalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // add view and layout.
    }
    
    return self;
}

// present it.
HWSimplePanModalView *simplePanModalView = [HWSimplePanModalView new];
[simplePanModalView presentInView:nil];
```
    
## Example

1. Clone this git.
2. open the terminal, run `pod install`
3. Double click HWPanModal.xcworkspace, and select a target to run.

###### I have wrote both **pure** `Objective-C` & `Swift`Examples , for most of the framework functions.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=HeathWang/HWPanModal&type=Date)](https://star-history.com/#HeathWang/HWPanModal&Date)

## Contact Me

Heath Wang
yishu.jay@gmail.com

### WeChat 

<p style="align: left">
    <a>
       <img src="images/groupChat.jpg" width="277">
    </a>
</p>

## Change Log

[Click Me](https://github.com/HeathWang/HWPanModal/blob/master/ChangeLog.md)

## License

<b>HWPanModal</b> is released under a MIT License. See LICENSE file for details.

