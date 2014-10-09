//
//  PhotoModel.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property (assign,nonatomic) CGRect srcFrame;

@property (strong,nonatomic) NSNumber *h;
@property (strong,nonatomic) NSNumber *w;
@property (strong,nonatomic) NSURL *img;

@property (strong,nonatomic) UIImage *image;

+ (PhotoModel *)photoModelWithDict:(NSDictionary *)dict;
@end
