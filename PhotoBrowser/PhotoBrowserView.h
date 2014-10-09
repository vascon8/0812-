//
//  PhotoBrowserView.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@class PhotoBrowserView;

@protocol PhotoBrowserViewDelegate <NSObject>

- (void)photoBrowserView:(PhotoBrowserView *)photoBrowserView animationShowWithFrame:(CGRect)frame;

@end

@interface PhotoBrowserView : UIScrollView

@property (strong,nonatomic) PhotoModel *photoModel;
@property (strong,nonatomic) UIImageView *imgView;
@property (assign,nonatomic) BOOL isAnimation;
@property (weak,nonatomic)id<PhotoBrowserViewDelegate,UIScrollViewDelegate>delegate;

@end
