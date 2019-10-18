//
//  HWPanModalIndicatorProtocol.h
//  HWPanModal
//
//  Created by heath wang on 2019/8/9.
//

typedef NS_ENUM(NSUInteger, HWIndicatorState) {
    HWIndicatorStateNormal NS_SWIFT_NAME(normal),     // origin state
    HWIndicatorStatePullDown NS_SWIFT_NAME(pull),   // drag down state
};

static CGFloat const kIndicatorYOffset = 5;

@protocol HWPanModalIndicatorProtocol <NSObject>

/**
 * When user drags, the state will change.
 * You can change your UI here.
 * @param state The state when drag changed.
 */
- (void)didChangeToState:(HWIndicatorState)state;

/**
 * Tell the size of the indicator.
 */
- (CGSize)indicatorSize;

/**
 * You can layout your UI here if you need.
 * This method called when indicator added to super view
 */
- (void)setupSubviews;

@end

