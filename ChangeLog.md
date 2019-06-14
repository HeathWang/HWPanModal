
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


