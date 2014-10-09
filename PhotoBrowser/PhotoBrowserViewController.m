//
//  PhotoBrowserViewController.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "PhotoBrowserViewController.h"
#import "PhotoModel.h"

@interface PhotoBrowserViewController ()<UIScrollViewDelegate,PhotoBrowserViewDelegate>
{
    UIScrollView *_scroll;
    
    CGFloat _pViewWidth;
    CGFloat _pViewHeight;
    
    NSMutableDictionary *_visiblePhotoBrowserViewDict;
    NSMutableSet *_reuseablePhotoBrowserViewSet;
}
@end

@implementation PhotoBrowserViewController

-(void)loadView
{
    UIScrollView *scroll = [[UIScrollView alloc]init];
    self.view = scroll;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    _scroll = scroll;
    _scroll.showsVerticalScrollIndicator = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
    _visiblePhotoBrowserViewDict = [NSMutableDictionary dictionary];
    _reuseablePhotoBrowserViewSet = [NSMutableSet set];
}
#pragma mark -exit PhotoBrowser
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    PhotoBrowserView *pView = _visiblePhotoBrowserViewDict[@(_currentIndex)];
    if ([self.delegate respondsToSelector:@selector(photoBrowserView:disEndAtIndex:)]) {
        [self.delegate photoBrowserView:pView disEndAtIndex:_currentIndex];

    }
    [UIView animateWithDuration:0.4f animations:^{
        [pView.imgView setFrame:pView.photoModel.srcFrame];
        [pView setBackgroundColor:[UIColor clearColor]];
        [_scroll setBackgroundColor:[UIColor clearColor]];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}
#pragma mark - scrollView delegat
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
#warning should is _scroll not scrollView,becoz phtobrowserview also a scroll view
    
    NSInteger currentPage = _scroll.contentOffset.x/scrollView.frame.size.width;
    NSInteger nextPage = currentPage+1;
    if (nextPage > _photoList.count-1) {
        nextPage = _photoList.count-1;
    }
    if (currentPage<0) {
        currentPage=0;
    }
    for (NSInteger i=currentPage; i<=nextPage; i++) {
            [self loadPhotoBrowserViewAtPage:i withAnimation:NO];
    }
}
- (void)loadPhotoBrowserViewAtPage:(NSInteger)pageNo withAnimation:(BOOL)isAnimation
{
    PhotoBrowserView *pView = _visiblePhotoBrowserViewDict[@(pageNo)];
    if (!pView) {
        PhotoBrowserView *pView = [self dequeueReusablePhotoBrowserView];

        CGRect frame = CGRectMake(_pViewWidth*pageNo, 0, _pViewWidth, _pViewHeight);
        pView.frame = frame;
        pView.isAnimation = isAnimation;
        pView.photoModel = _photoList[pageNo];
        [self.view addSubview:pView];
        [_visiblePhotoBrowserViewDict setObject:pView forKey:@(pageNo)];
    }

}
- (PhotoBrowserView *)dequeueReusablePhotoBrowserView
{
    PhotoBrowserView *pView = [_reuseablePhotoBrowserViewSet anyObject];
    if (!pView) {
        pView = [[PhotoBrowserView alloc]init];
        pView.delegate = self;
    }
    else{
        [_reuseablePhotoBrowserViewSet removeObject:pView];
    }
    return pView;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = _scroll.contentOffset.x/scrollView.frame.size.width;
    
    [_visiblePhotoBrowserViewDict enumerateKeysAndObjectsUsingBlock:^(id key,PhotoBrowserView *pView, BOOL *stop) {
        if (![key isEqualToValue:@(currentPage)]) {
            [_reuseablePhotoBrowserViewSet addObject:pView];
            [_visiblePhotoBrowserViewDict removeObjectForKey:key];
            [pView removeFromSuperview];
        }
    }];
    
    _currentIndex = currentPage;
}
#pragma mark - showPhotoBrowserView
- (void)showPhotoBrowserViewWithFrame:(CGRect)frame
{
    self.view.frame = frame;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    _pViewWidth = frame.size.width;
    _pViewHeight= frame.size.height;
    [self loadPhotoBrowserViewAtPage:_currentIndex withAnimation:YES];
    
    _scroll.contentSize = CGSizeMake(_pViewWidth*_photoList.count, 0);
    _scroll.contentOffset = CGPointMake(_currentIndex*_pViewWidth, 0);
    
    [keyWindow addSubview:self.view];
    [keyWindow.rootViewController addChildViewController:self];
}
#pragma mark - photoBrowserView delegate
- (void)photoBrowserView:(PhotoBrowserView *)photoBrowserView animationShowWithFrame:(CGRect)frame
{
    CGRect srcFrame = photoBrowserView.photoModel.srcFrame;
    photoBrowserView.imgView.frame = srcFrame;
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [UIView animateWithDuration:0.4f animations:^{
        photoBrowserView.imgView.frame = frame;
        [self.view setBackgroundColor:[UIColor lightGrayColor]];
    }];
}
#pragma mark - rotate
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
 
}
@end
