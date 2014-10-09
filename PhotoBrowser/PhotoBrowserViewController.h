//
//  PhotoBrowserViewController.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserView.h"

@protocol PhotoBrowserViewControllerDelegate <NSObject>
@optional
- (void)photoBrowserView:(PhotoBrowserView *)photoBrowserView disEndAtIndex:(NSInteger)index;

@end

@interface PhotoBrowserViewController : UIViewController

@property (assign,nonatomic) NSInteger currentIndex;
@property (strong,nonatomic) NSArray *photoList;
@property (weak,nonatomic) id<PhotoBrowserViewControllerDelegate>delegate;

- (void)showPhotoBrowserViewWithFrame:(CGRect)frame;

@end
