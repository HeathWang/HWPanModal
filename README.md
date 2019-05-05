# HWPanModal
HWPanModal is used to present controller and drag to dismiss.
Inspired by [PanModal](https://github.com/slackhq/PanModal), thanks.
*I just use Objective-C to implement it, only a practice.*


## Compatibility
**iOS 8.0+**, support Objective-C & Swift.

## Installation
<a href="https://guides.cocoapods.org/using/using-cocoapods.html" target="_blank">CocoaPods</a>

```ruby
pod 'HWPanModal', '~> 0.1.1'
```

## How to use

Your UIViewController need to conform `HWPanModalPresentable`. If you use default, nothing more will be written.


```Objective-C
@interface HWBaseViewController () <HWPanModalPresentable>

@end

@implementation HWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
```

Then present this Controller.


```Objective-C
[self presentPanModal:[HWBaseViewController new]];
```

yeah! Easy.

## More tips

to be done.


## License

<b>HWPanModal</b> is released under a MIT License. See LICENSE file for details.


