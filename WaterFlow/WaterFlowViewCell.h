//
//  WaterFlowViewCell.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaterFlowViewCell : UIView

@property (strong,nonatomic) UIImageView *imgView;
@property (strong,nonatomic) UILabel *textLabel;
@property (strong,readonly,nonatomic) NSString *reuseIdentifier;

- (WaterFlowViewCell *)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
