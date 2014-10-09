//
//  PhotoBrowserView.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "UIImageView+WebCache.h"

@interface PhotoBrowserView ()
//{
//    UIImageView *_imgView;
//}
@end


@implementation PhotoBrowserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc]init];
        [self addSubview:imgView];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView = imgView;
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
#pragma mark - exitPhotoBrowser
#pragma mark - private method
- (void)setPhotoModel:(PhotoModel *)photoModel
{
    _photoModel = photoModel;
    if (_photoModel.image) {
        [_imgView setImage:_photoModel.image];
        [self adjustFrame];
    }
    else{
        UIImage *img = [[UIImage alloc]init];
        __unsafe_unretained PhotoBrowserView *pView = self;
        [_imgView setImageWithURL:_photoModel.img placeholderImage:img options:SDWebImageCacheMemoryOnly|SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            pView.photoModel.image = image;
            [pView adjustFrame];
        }];
    }
//    [_imgView setImageWithURL:photoModel.img];
    
//    
//    NSLog(@"%@ %@",NSStringFromCGRect(_imgView.frame),NSStringFromCGSize(_imgView.image.size));
}
- (void)adjustFrame
{
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    CGFloat imgW = _imgView.image.size.width;
    CGFloat imgH = _imgView.image.size.height;
    CGFloat delta = viewW/imgW;

    if (delta<1.0) {
        imgW = viewW;
        imgH = imgH*delta;
    }
    
    
    CGRect tempFrame = CGRectMake(0, 0, imgW, imgH);
    tempFrame.origin.x = (viewW-imgW)/2;
    if (imgH<viewH) {
        tempFrame.origin.y = (viewH-imgH)/2;
    }
    else
    {
        self.contentSize = CGSizeMake(viewW, imgH);
    }
//    NSLog(@"%@",NSStringFromCGRect(_imgView.frame));
    
    if (self.isAnimation) {
        
        [self.delegate photoBrowserView:self animationShowWithFrame:tempFrame];
        
//        [_imgView setFrame:self.photoModel.srcFrame];
//        self.backgroundColor = [UIColor clearColor];
//        [UIView animateWithDuration:0.4f animations:^{
//            _imgView.frame = tempFrame;
//            self.backgroundColor = [UIColor lightGrayColor];
//        }];
    }
    else{
        _imgView.frame = tempFrame;
//        self.backgroundColor = [UIColor lightGrayColor];
    }

    

}
@end
