//
//  WaterFLowView.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WaterFlowViewCell.h"

@class WaterFLowView;

@protocol WaterFlowViewDataSource <NSObject>
- (NSInteger)waterFlowView:(WaterFLowView *)waterFlowView numberOfRowsInSection:(NSInteger)section;
- (WaterFlowViewCell *)waterFlowView:(WaterFLowView *)waterFlowView waterFlowViewCellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfColumnInWaterFlowView:(WaterFLowView *)waterFlowView;
- (void)refreshData;
@end


@protocol WaterFlowViewDelegate <NSObject,UIScrollViewDelegate>
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)waterFlowView:(WaterFLowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end



@interface WaterFLowView : UIScrollView

@property (weak,nonatomic) id<WaterFlowViewDelegate>delegate;
@property (weak,nonatomic) id<WaterFlowViewDataSource>dataSource;
@property (strong,nonatomic) NSMutableArray *cellFrames;


- (void)reloadData;
- (WaterFlowViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)reuseidentifier;
- (void)waterFlowViewdidScroll;
@end


