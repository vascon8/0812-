//
//  MGJData2.m
//  瀑布流
//
//  Created by xinliu on 14-7-30.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "MGJData2.h"

@implementation MGJData2
+ (id)dataWithDict:(NSDictionary *)dict
{
    MGJData2 *data = [[self alloc]init];
    data.img = dict[@"picUrl"];
    data.price = dict[@"price"];
    data.w = dict[@"width"];
    data.h = dict[@"imgHeight"];
    return data;
}
- (NSString *)description{
        return [NSString stringWithFormat:@"<MGJData2:%p> h:%@ w:%@ price:%@ img:%@",self,self.h,self.w,self.price,self.img];
}
@end
