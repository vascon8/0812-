//
//  WaterFlowViewController.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "WaterFlowViewController.h"

@interface WaterFlowViewController ()

@end

@implementation WaterFlowViewController
- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    self.waterFlowView = [[WaterFLowView alloc]initWithFrame:frame];
    self.view = self.waterFlowView;
    self.waterFlowView.dataSource = self;
    self.waterFlowView.delegate = self;
}

#pragma mark - waterFLowView dataSource
- (NSInteger)waterFlowView:(WaterFLowView *)waterFlowView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//- (NSInteger)numberOfColumnInWaterFlowView:(WaterFLowView *)waterFlowView
//{
//    return 3;
//}
- (WaterFlowViewCell *)waterFlowView:(WaterFLowView *)waterFlowView waterFlowViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *WaterFlowViewCellID = @"WaterFlowViewCell";
#warning need update
    WaterFlowViewCell *cell = [waterFlowView dequeueReuseableCellWithIdentifier:WaterFlowViewCellID];
    return cell;
}
#pragma mark - waterFLowView delegate
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
#pragma mark scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.waterFlowView waterFlowViewdidScroll];
}
#pragma mark - rotate
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.waterFlowView reloadData];
}
@end
