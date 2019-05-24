
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
    <a href="https://cocoapods.org/pods/HWPanModal">
       <img src="https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic">
    </a>
</p>


HWPanModal 用于从底部弹出控制器（UIViewController），并用拖拽手势来关闭控制器。提供了自定义视图大小和位置，高度自定义弹出视图的各个属性。

APP中常见的从底部弹出视图，比如知乎APP的查看评论、抖音的评论查看、弹出分享等，可以通过该框架快速实现，只需专注于相应的视图编写。

参考 [**PanModal**](https://github.com/slackhq/PanModal), 感谢.

## 截图

<div  align="center">    
<img src="https://github.com/HeathWang/HWPanModal/blob/master/HWPanModal_example.gif" width = "225" height = "413.4" alt="example" align=center/>
</div>

## 功能
1. 支持任意类型的 `UIViewController`
2. 平滑的转场动画
3. 支持2种类型的手势操作
    1. UIPanGestureRecognizer, 上下拖拽视图
    2. UIScreenEdgePanGestureRecognizer, 侧滑关闭视图。
    
## 适配
**iOS 8.0+**, support Objective-C & Swift.

### 依赖

[KVOController - facebook](https://github.com/facebook/KVOController)


## 安装
<a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>

```ruby
pod 'HWPanModal', '~> 0.2.5'
```

## 如何使用

只需要视图控制器适配 `HWPanModalPresentable` 协议即可. 默认情况下，不用重写适配的各个方法，如果需要自定义，请实现协议方法。

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

如何弹出控制器？

```Objective-C
#import <HWPanModal/HWPanModal.h>
[self presentPanModal:[HWBaseViewController new]];
```

就是这么简单

## 例子

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
    * Add `- (BOOL)allowsTapBackgroundToDismiss;` to control whether can tap background to dismiss. 
* 0.2.5
    * file name update. 

## License

<b>HWPanModal</b> is released under a MIT License. See LICENSE file for details.


