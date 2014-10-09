//
//  MainViewController.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "MainViewController.h"
#import "MGJData.h"
#import "UIImageView+WebCache.h"
#import "PhotoBrowserViewController.h"
#import "PhotoModel.h"

@interface MainViewController ()<PhotoBrowserViewControllerDelegate>
{
    NSMutableArray *_MGJData;
    NSMutableArray *_photoModel;
    NSInteger _columns;
    
    BOOL _isLoadingData;
}
@end

@implementation MainViewController

- (void)loadLocalData
{
    _isLoadingData = YES;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"mogujie.plist" ofType:Nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *arr = dict[@"result"][@"list"];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];
    NSMutableArray *arrMPhoto = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSDictionary *dict in arr) {
        NSDictionary *show = dict[@"show"];
        NSDictionary *showLarge = dict[@"showLarge"];
        MGJData *data = [MGJData mgjDataWithDict:show];
        PhotoModel *p = [PhotoModel photoModelWithDict:showLarge];
        [arrM addObject:data];
        [arrMPhoto addObject:p];
    }
    _MGJData = arrM;
    _photoModel = arrMPhoto;
    _columns = 3;
    
    _isLoadingData = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_MGJData == Nil) {
        _MGJData = [NSMutableArray array];
    }
    if (_photoModel ==nil) {
        _photoModel = [NSMutableArray array];
    }
    
    [self loadLocalData];
}
#pragma mark waterFLowView dataSource
- (NSInteger)waterFlowView:(WaterFLowView *)waterFlowView numberOfRowsInSection:(NSInteger)section
{
    return _MGJData.count;
}
- (NSInteger)numberOfColumnInWaterFlowView:(WaterFLowView *)waterFlowView
{   
    UIDevice *device = [UIDevice currentDevice];
    if (device.orientation==UIDeviceOrientationLandscapeLeft ||device.orientation == UIDeviceOrientationLandscapeRight) {
        _columns = 4;
    }
    else{
        _columns = 3;
    }
    return _columns;
}
- (WaterFlowViewCell *)waterFlowView:(WaterFLowView *)waterFlowView waterFlowViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"myCell";
    WaterFlowViewCell *cell = [waterFlowView dequeueReuseableCellWithIdentifier:CellID];

    MGJData *data = _MGJData[indexPath.row];
    [cell.imgView setImageWithURL:data.img];
    [cell.textLabel setText:data.price];
    return cell;
}
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGJData *data = _MGJData[indexPath.row];
    CGFloat W = [data.w floatValue];
    CGFloat H = [data.h floatValue];
    CGFloat cellW = self.waterFlowView.bounds.size.width/_columns;
    CGFloat cellH = cellW/W * H;
#warning need update
    return cellH;
}
#pragma mark - waterFlowView delegate
- (void)waterFlowView:(WaterFLowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoBrowserViewController *photoController = [[PhotoBrowserViewController alloc]init];
    photoController.currentIndex = indexPath.row;

    [_MGJData enumerateObjectsUsingBlock:^(MGJData *data, NSUInteger idx, BOOL *stop) {
#warning need update frame
        CGRect frame = [self.waterFlowView.cellFrames[idx] CGRectValue];
        CGRect srcFrame = [self.view convertRect:frame toView:Nil];
        PhotoModel *p = _photoModel[idx];
        p.srcFrame = srcFrame;
    }];
    photoController.photoList = _photoModel;
    photoController.delegate = self;
    [photoController showPhotoBrowserViewWithFrame:self.view.frame];
}
#pragma mark - photoBrowserview delegate
- (void)photoBrowserView:(PhotoBrowserView *)photoBrowserView disEndAtIndex:(NSInteger)index
{
    CGRect frame = [self.waterFlowView.cellFrames[index] CGRectValue];
    [self.waterFlowView scrollRectToVisible:frame animated:NO];
    
    CGRect animationFrame = [self.view convertRect:frame toView:Nil];
    [_photoModel[index] setSrcFrame:animationFrame];
}
@end
