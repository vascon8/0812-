//
//  PhotoModel.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-13.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel
+ (PhotoModel *)photoModelWithDict:(NSDictionary *)dict
{
    PhotoModel *p = [[PhotoModel alloc]init];
    [p setValuesForKeysWithDictionary:dict];
    return p;
}
//+(PhotoModel *)photoModelWithSrcFrame:(CGRect)srcFrame imgUrl:(NSURL *)imgURl index:(NSInteger)index
//{
//    PhotoModel *p = [[PhotoModel alloc]init];
//    p.imgUrl = imgURl;
//    p.srcFrame = srcFrame;
//    p.index = index;
//    return p;
//}

#pragma mark - private method
- (NSString *)description
{
    return [NSString stringWithFormat:@"<PhotoModel:%p>imgurl:%@,srcFrame:%@",self,_img,NSStringFromCGRect(_srcFrame)];
}
@end
