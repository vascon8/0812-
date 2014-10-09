//
//  MGJData.h
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGJData : NSObject

@property (strong,nonatomic) NSURL *img;
@property (strong,nonatomic) NSString *price;
@property (strong,nonatomic) NSNumber *h;
@property (strong,nonatomic) NSNumber *w;

@property (strong,nonatomic) NSURL *largeImgURL;

+(MGJData *)mgjDataWithDict:(NSDictionary *)dict;
@end
