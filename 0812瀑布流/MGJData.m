//
//  MGJData.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "MGJData.h"

@implementation MGJData

+ (MGJData *)mgjDataWithDict:(NSDictionary *)dict
{
    MGJData *m = [[MGJData alloc]init];
    [m setValuesForKeysWithDictionary:dict];
    return m;
}
- (NSString *)description{
    return [NSString stringWithFormat:@"<MGJData:%p>:h:%@ w:%@ price:%@ img:%@",self,self.h,self.w,self.price,self.img];
}
@end
