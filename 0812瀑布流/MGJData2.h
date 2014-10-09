//
//  MGJData2.h
//  瀑布流
//
//  Created by xinliu on 14-7-30.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGJData2 : NSObject

@property (strong,nonatomic) NSNumber *h;
@property (strong,nonatomic) NSNumber *w;
@property (strong,nonatomic) NSURL *img;
@property (strong,nonatomic) NSString *price;

+ (id)dataWithDict:(NSDictionary *)dict;
@end
