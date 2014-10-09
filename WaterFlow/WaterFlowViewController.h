//
//  WaterFlowViewController.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WaterFLowView.h"

@interface WaterFlowViewController : UIViewController<WaterFlowViewDataSource,WaterFlowViewDelegate>

@property (strong,nonatomic) WaterFLowView *waterFlowView;

@end
