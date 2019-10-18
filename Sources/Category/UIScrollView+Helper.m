//
//  UIScrollView+Helper.m
//  Pods
//
//  Created by heath wang on 2019/10/15.
//

#import "UIScrollView+Helper.h"

@implementation UIScrollView (Helper)

- (BOOL)isScrolling {
    return (self.isDragging && !self.isDecelerating) || self.isTracking;
}

@end
