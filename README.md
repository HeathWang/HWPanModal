
# HWPanModal
HWPanModal is used to present controller and drag to dismiss.

Inspired by [**PanModal**](https://github.com/slackhq/PanModal), thanks.

<div  align="center">    
<img src="./HWPanModal_example.gif" width = "225" height = "413.4" alt="example" align=center/>
</div>

## Features
1. Supports any type of `UIViewController`
2. Seamless transition between modal and content
3. Support two kinds of GestureRecognizer
    1. UIPanGestureRecognizer, direction is UP & Down.
    2. UIScreenEdgePanGestureRecognizer, you can swipe on screen edge to dismiss controller. 

## Compatibility
**iOS 8.0+**, support Objective-C & Swift.

### Dependency

[KVOController - facebook](https://github.com/facebook/KVOController)

Because Objective-C KVO is hard to use, so I use KVOController = =

## Installation
<a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>

```ruby
pod 'HWPanModal', '~> 0.2.4'
```

## How to use

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

@end
```

Where you need to present this Controller.

```Objective-C
#import <HWPanModal/HWPanModal.h>
[self presentPanModal:[HWBaseViewController new]];
```

yeah! Easy.

## Example

1. Clone this git.
2. open the terminal， go to the `Example` Folder.
3. `pod install --verbose`
4. Double click HWPanModal.xcworkspace, and run.

## Change Log
* 0.2.0
    Add screen edge interactive gesture. Default this function is closed, implement `- (BOOL)allowScreenEdgeInteractive;` to config it.
    
    ```Objective-C
    - (BOOL)allowScreenEdgeInteractive {
        return YES;
    }
    ```
* 0.2.1
    * Fix when rotate presented controller, the UI is not correct.
* 0.2.2
    * Screen edge pan interactive bug fix.
* 0.2.3
    * iOS8+ rotate bug fix.    
* 0.2.4
    * UI bug fix.
    * Improve drag indicator animate.    

## License

<b>HWPanModal</b> is released under a MIT License. See LICENSE file for details.


