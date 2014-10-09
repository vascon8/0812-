//
//  WaterFlowViewCell.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "WaterFlowViewCell.h"

#define kTextFount [UIFont systemFontOfSize:12]
@implementation WaterFlowViewCell


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        
        _imgView = [[UIImageView alloc]init];
        [_imgView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imgView];
        
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = kTextFount;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        [self addSubview:_textLabel];
    }
    return self;
}
- (void)layoutSubviews
{
//    NSLog(@"layoutSUbview");
    //wrong
//    _imgView.frame = self.frame;
    _imgView.frame = self.bounds;
//    NSLog(@"%@",NSStringFromCGRect(_imgView.frame));
    NSString *str = _textLabel.text;
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
//    CGSize MaxSize = CGSizeMake(W, 20);
    
    CGRect rect = [str boundingRectWithSize:self.frame.size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kTextFount} context:Nil];
    CGFloat textW = rect.size.width;
    CGFloat textH = rect.size.height;
    CGRect frame = CGRectMake(W-textW-2, H-textH-2, textW, textH);
    _textLabel.frame = frame;
}

@end
