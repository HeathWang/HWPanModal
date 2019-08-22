
# HWPanModal Change Log

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
* 0.2.6
    * Add `- (BOOL)shouldAnimatePresentingVC;` to config transition for PresentingVC.
* 0.2.6.1
    * fix when set UIScrollView contentOffset in `- (void)viewDidLoad;` cause first pan UI issue.
* 0.2.7.1
    * Now you can write your own custom presenting VC animation.
    * Refine comments and docs.
* 0.2.8
    * Now you can blur background.
        * overwrite `- (CGFloat)backgroundBlurRadius;`, return a value > 0.
    * Add a new delegate callback.
    
    ```Objective-C
        /**
         * When you pan present controller to dismiss, and the view's y <= shortFormYPos,
         * this delegate method will be called.
         * @param percent 0 ~ 1, 1 means has dismissed
         */
        - (void)panModalGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer dismissPercent:(CGFloat)percent;
    ```
        
* 0.2.8.1
    * Fix blur effect not working on iOS8.0.
* 0.2.9
    * UI issue fix.
    * Add auto handle keyboard show/hide.
* 0.2.9.1
    * Fix set scrollable showsVerticalScrollIndicator = NO, but doesn't work.
* 0.2.9.3
    * Add new config method.
        
        ```Objective-C
        /**
         * When there is text input view exists and becomeFirstResponder, will auto handle keyboard height.
         * Default is YES. You can disable it, handle it by yourself.
         */
        - (BOOL)isAutoHandleKeyboardEnabled;
        ```
* 0.2.9.4
    * Add config for keyboard offset from inputView bottom.
    
        ```Objective-C
        /**
         The offset that keyboard show from input view's bottom. It works when
         `isAutoHandleKeyboardEnabled` return YES.
        
         @return offset, default is 5.
         */
        - (CGFloat)keyboardOffsetFromInputView;
        ```   
* 0.2.9.5
    *  Add config for blur color
        
        ```Objective-C
        /**
         * blur background color
         * @return color, default is White Color.
         */
        - (nonnull UIColor *)backgroundBlurColor;
        ```
* 0.2.9.6
    * Fix set ScrollView contentInset top UI issue.   
* 0.3.0
    * Now you can custom your own indicator view. 
* 0.3.3
    * support `Carthage` 
        
        


