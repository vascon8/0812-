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
#import "MGJData2.h"

@interface MainViewController ()<PhotoBrowserViewControllerDelegate>
{
    NSMutableArray *_MGJData;
    NSMutableArray *_photoModel;
    NSInteger _columns;
    
    BOOL _isLoadingData;
}
@end

@implementation MainViewController
- (void)loadWebData
{
    _isLoadingData = YES;
    NSString *str = @"http://www.mogujie.com/book/ajax?firstscreen=1&book=eyJ1c2VySWQiOm51bGwsImN1cnJlbnRJZCI6ImJvb2tfMWZlbjd3ZmRhNHU4IiwicHJlSWQiOm51bGwsImFjdGlvbiI6ImNsb3RoaW5nIiwiaXNfYWRtaW4iOmZhbHNlLCJsZWltdSI6eyJmX2NpZCI6MTQyNzMsIm5hbWUiOiJcdTg4NjNcdTY3MGQiLCJlX25hbWUiOiJjbG90aGluZyIsIm1fY2lkcyI6IjE2IiwidF9jaWRzIjoiIzE2IyAjNTAwMDg4ODEjICM1MDAwODg4MiMgIzUwMDA4ODgzIyAjNTAwMDg4ODQjICM1MDAwODg4NSMgIzUwMDA4ODg2IyAjNTAwMDg4ODgjICM1MDAwODg4OSMgIzUwMDA4ODkwIyAjNTAwMTAzOTQjICM1MDAxMTQwNCMgIzUwMDEyMzU0IyAjNTAwMTI3NjYjICM1MDAxMjc3MSMgIzUwMDEyNzcyIyAjNTAwMTI3NzMjICM1MDAxMjc3NCMgIzUwMDEyNzc2IyAjNTAwMTI3NzcjICM1MDAxMjc3OCMgIzUwMDEyNzgxIyAjNTAwMTI3ODQjICM1MDAxMjc4Iiwia2V5d29yZHMiOiIiLCJrX2NpZHMiOiIiLCJsZXZlbCI6MSwidG9wX2ZfY2lkIjoxNDI3MywicGFyZW50X2ZfY2lkIjowLCJsZXZlbHMiOiIjMTQyNzMjIiwic29ydCI6MywibW9iaWxlU29ydCI6MCwiaGlnaGxpZ2h0IjowLCJzdHlsZSI6MSwiZXh0cmFfYml0IjowLCJob3QiOiIiLCJkYXBlaSI6IiIsImZhc2hpb24iOiIiLCJleHRyYSI6bnVsbCwiZGVzY3JpcHRpb24iOiIiLCJ2aXNpYWJsZSI6MSwidXBkYXRlZCI6MTM5MzU1ODYyMywiY3JlYXRlZCI6MTM5MzU1NzA0MiwiaXNEZWxldGVkIjowLCJ0d2l0dGVySWQiOjAsInNlYXJjaF9kaXJlY3QiOjAsInNlYXJjaF9rZXl3b3JkcyI6IiIsImF0dHJOYW1lcyI6IiIsImF0dHJJZHMiOiIiLCJpc0RhbnBpbiI6MCwiZGFucGluRGVzY3JpcHQiOiIiLCJuZXdfbV9jaWRzIjpudWxsLCJzaG93X2Zyb250IjoxLCJzaG93X2xldmVsIjozLCJzdWJzaXRlIjowLCJ1c2VyR3JvdXAiOjAsImFyZWFJZHMiOiIwIiwic2ltaWxhcl9mX2NpZHMiOiIiLCJwYWlyX2ZfY2lkcyI6IiIsImZfaWNvbiI6IiIsImZfZGVzYyI6IiIsInRyYWRlX2NpZHMiOiIjNjgzIyIsIm1vYmlsZV9mX2ljb24iOiIiLCJjYXRlX3Nob3ciOjAsIm1vYmlsZV9zaG93IjowLCJmcm9udF9kZXNjIjpudWxsLCJjdXN0b21UeXBlIjowLCJ1dG90YWwiOjE3MzQ3MCwiY3VzdG9tVGFnIjpudWxsfSwiZl9jaWQiOjE0MjczLCJwYWdlIjoxLCJzb3J0IjoicG9wIiwiZklkIjpbXSwiZiI6IiIsInRhZyI6IiIsImRmcm9udCI6eyJzaG9wcGluZ19hZGRmb2xsb3ciOiJcL2pzMlwvbW9kdWxlLWFkZGZvbGxvdy5qcyxcL2pzMlwvbW9kdWxlLWFkZGZhdi5qcyIsImNhcHRjaGEiOiJcL2pzXC9tb2R1bGUtY2FwdGNoYS5qcyIsInNob3BpbmdfbmF2RmxvYXQiOiJcL2Nzc1wvc2hvcHBpbmdcL21vZHVsZU5hdkZsb2F0LmNzcyxcL2pzXC9zaG9wcGluZ1wvbW9kdWxlTmF2RmxvYXQuanMiLCJ0cmFkZV9kZWJ0X3JlbWluZCI6IlwvY3NzXC90cmFkZVwvcGFnZS1kZWJ0LXJlbWluZC5jc3MsXC9qc1wvdHJhZGVcL3BhZ2UtZGVidC1yZW1pbmQtZmxvYXQuanMiLCJ0cmFkZV9uZXdlcl9hX2FsZXJ0IjoiXC9qc1wvdHJhZGVcL3BhZ2UtbmV3ZXItYWN0aXZlLWFsZXJ0LmpzIn0sImFkIjpudWxsLCJ5b3VkaWFuIjpudWxsLCJ5b3VwaW4iOm51bGwsIm1pblByaWNlIjpudWxsLCJtYXhQcmljZSI6bnVsbCwic2giOm51bGwsInNsIjpudWxsLCIyNGhvdCI6bnVsbCwiMjRkaXNjb3VudCI6bnVsbCwiY3VzdG9tIjp7ImFjdGlvbiI6bnVsbH19&col=4&eventId=&lastTweetId=&location=clothing&page=1&pageName=welcome&total=&totalCol=4";
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:Nil];
    NSArray *arr2 = dict[@"result"][@"feeds"];
    for (NSDictionary *dict in arr2) {
        if (dict[@"picUrl"]) {
            MGJData2 *data = [MGJData2 dataWithDict:dict];
            //becarful: ni bigPic so the _photModel no update
            PhotoModel *p = [[PhotoModel alloc]init];
            p.img = dict[@"img"];
            p.w = dict[@"w"];
            p.h = dict[@"h"];
            [_photoModel addObject:p];
            [_MGJData addObject:data];
        }
    }
}
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
//    [self.waterFlowView reloadData];
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
- (void)refreshData
{
    if (!_isLoadingData) {
        [self loadWebData];
    }
}
#pragma mark - waterFlowView delegate
- (void)waterFlowView:(WaterFLowView *)waterFlowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@",indexPath);
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
//    CGRect animationFrame = [self.view convertRect:frame toView:Nil];
//    NSLog(@"%@,%@",NSStringFromCGRect(frame),NSStringFromCGRect(animationFrame));
    [self.waterFlowView scrollRectToVisible:frame animated:NO];
    
    //取这个，而不是上面那个
    CGRect animationFrame = [self.view convertRect:frame toView:Nil];
    [_photoModel[index] setSrcFrame:animationFrame];
//    NSLog(@"%@",NSStringFromCGRect(animationFrame));
}
#pragma mark - rotate
#warning willAnimateRotation  willRotation different
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//
////    [self.waterFlowView reloadData];
//    [(WaterFLowView *)self.view reloadData];
//    NSLog(@"%@ %@ %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(self.view.bounds),NSStringFromCGRect(self.waterFlowView.bounds));
//}
@end
