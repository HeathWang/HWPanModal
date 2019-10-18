//
//  HWAutoSizePanModalContentView.m
//  HWPanModalDemo
//
//  Created by heath wang on 2019/10/18.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWAutoSizePanModalContentView.h"
#import <Masonry/Masonry.h>

@implementation HWAutoSizePanModalContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [UILabel new];
        label.text = @"Downstairs, the doctor left three different medicines in different colored capsules2 with instructions for giving them. One was to bring down the fever, another purgative3, the third to overcome an acid condition. The germs of influenza4 can only exist in an acid condition, he explained. He seemed to know all about influenza and said there was nothing to worry about if the fever did not go above one hundred and four degree. This was a light epidemic5 of flu and there was no danger if you avoided pneumonia6.\n"
        "Back in the room I wrote the boy's temperature down and made a note of the time to give the various capsules.";
        label.numberOfLines = 0;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
        }];
    }
    return self;
}


- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeIntrinsic, 0);
}

@end
