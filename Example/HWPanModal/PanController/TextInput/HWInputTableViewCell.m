//
//  HWInputTableViewCell.m
//  HWPanModal_Example
//
//  Created by heath wang on 2019/6/19.
//  Copyright © 2019 heath wang. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "HWInputTableViewCell.h"

@interface HWInputTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HWInputTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleBezel;
        _textField.delegate = self;

        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.width.equalTo(@300);
            make.centerY.equalTo(@0);
        }];
    }

    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}


@end
