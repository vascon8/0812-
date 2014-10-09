//
//  WaterFLowView.m
//  0812瀑布流
//
//  Created by xinliu on 14-8-11.
//  Copyright (c) 2014年 xinliu. All rights reserved.
//

#import "WaterFLowView.h"

#define kCellMargin 2

@interface WaterFLowView ()
{
//    NSMutableArray *_cellFrames;
    NSMutableArray *_indexPaths;
    
    CGFloat cellY[10];
    NSMutableArray *_tempIndexPaths;
    
    NSMutableSet *_reuseableCellSet;
    NSMutableDictionary *_visibleCellDict;
}
@property (assign,nonatomic) NSInteger rows;
@property (assign,nonatomic) NSInteger columns;
@end

@implementation WaterFLowView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        self.backgroundColor = [UIColor lightGrayColor];
//    }
//    
//    return self;
//}

#pragma mark - setFrame
- (void)setCellFrameWithIndexPaths:(NSArray *)indexPaths
{

    CGFloat W = (self.bounds.size.width-kCellMargin*(self.columns+1)) / self.columns;
    
    for (NSIndexPath *indexPath in indexPaths)
    {
        NSInteger col = indexPath.row%self.columns;
        CGFloat H = [self.delegate heightForRowAtIndexPath:indexPath];
//        CGFloat W = kWaterFlowViewCellWidth;
        CGFloat X = col*(W+kCellMargin)+kCellMargin;
        CGFloat Y = cellY[col];
        CGRect frame = CGRectMake(X, Y, W, H);
        cellY[col] += H;
        
        [_cellFrames addObject:[NSValue valueWithCGRect:frame]];
    }
    
    CGFloat maxH = cellY[0];
    for (int i=1; i<self.columns; i++) {
        if (cellY[i]>maxH) {
            maxH = cellY[i];
        }
    }
    self.contentSize = CGSizeMake(self.bounds.size.width, maxH);
}
#pragma mark - addSubview
- (void)loadCell
{
    for (NSIndexPath *indexPath in _indexPaths) {
        CGRect frame = [_cellFrames[indexPath.row]CGRectValue];
        WaterFlowViewCell *cell = _visibleCellDict[indexPath];
        if ([self isCellVisible:frame]) {
            if (!cell) {
                cell = [self.dataSource waterFlowView:self waterFlowViewCellForRowAtIndexPath:indexPath];
                cell.frame = frame;
                [self addSubview:cell];
                [_visibleCellDict setObject:cell forKey:indexPath];
            }
        }
        else{
            if (cell) {
                [_reuseableCellSet addObject:cell];
                [_visibleCellDict removeObjectForKey:indexPath];
                [cell removeFromSuperview];
            }
        }
        
    }NSLog(@"subVIews:%d,reuseSet:%d",self.subviews.count,_reuseableCellSet.count);
}
- (BOOL)isCellVisible:(CGRect)frame
{
    return (CGRectGetMaxY(frame)>self.contentOffset.y && frame.origin.y<self.contentOffset.y+self.bounds.size.height);
}
#pragma mark - scroll
- (void)waterFlowViewdidScroll
{
    [self loadCell];
    
    if (self.contentOffset.y+self.frame.size.height+200>self.contentSize.height) {
        [self.dataSource refreshData];
        [self appendCellFrame];
        [self appendCellWillLoad];
    }
    
}
#pragma mark - append data
- (void)appendCellFrame
{
    NSInteger oldRows = _rows;
    self.rows = [self.dataSource waterFlowView:self numberOfRowsInSection:0];
    if (_tempIndexPaths==nil) {
        _tempIndexPaths = [NSMutableArray arrayWithCapacity:_rows-oldRows];
    }
    else{
        [_tempIndexPaths removeAllObjects];
    }
    
    for (int i=oldRows; i<_rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_tempIndexPaths addObject:indexPath];
        [_indexPaths addObject:indexPath];
    }
    [self setCellFrameWithIndexPaths:_tempIndexPaths];
}
- (void)appendCellWillLoad
{

    for (NSIndexPath *indexPath in _tempIndexPaths) {
        CGRect frame = [_cellFrames[indexPath.row]CGRectValue];
        WaterFlowViewCell *cell = _visibleCellDict[indexPath];
        if ([self isCellVisible:frame]) {
            if (!cell) {
                cell = [self.dataSource waterFlowView:self waterFlowViewCellForRowAtIndexPath:indexPath];
                cell.frame = frame;
                [self addSubview:cell];
                [_visibleCellDict setObject:cell forKey:indexPath];
            }
        }
        else{
            if (cell) {
                [_reuseableCellSet addObject:cell];
                [_visibleCellDict removeObjectForKey:indexPath];
                [cell removeFromSuperview];
            }
        }
        
    }
}
#pragma mark - cache data
- (void)initCacheData
{
     _rows = [self.dataSource waterFlowView:self numberOfRowsInSection:0];
    
    for (int i=0; i<_columns; i++) {
        cellY[i] = kCellMargin;
    }
    
    NSInteger col = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnInWaterFlowView:)]) {
        col = [self.dataSource numberOfColumnInWaterFlowView:self];
    }
    _columns = col;
    
    if (_cellFrames == Nil) {
        _cellFrames = [NSMutableArray array];
    }
    else
    {
        [_cellFrames removeAllObjects];
    }
    
    if (_indexPaths == Nil) {
        _indexPaths = [NSMutableArray arrayWithCapacity:self.rows];
    }
    else{
        [_indexPaths removeAllObjects];
    }
    for (int i=0; i<self.rows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [_indexPaths addObject:indexPath];
    }
    
    if (_reuseableCellSet == Nil) {
        _reuseableCellSet = [NSMutableSet set];
    }
    
    if (_visibleCellDict == nil) {
        _visibleCellDict = [NSMutableDictionary dictionary];
    }
    else{
#warning removeSUbviews
        [_visibleCellDict enumerateKeysAndObjectsUsingBlock:^(id key, WaterFlowViewCell *cell, BOOL *stop) {
            [cell removeFromSuperview];
            [_reuseableCellSet addObject:cell];
        }];
        [_visibleCellDict removeAllObjects];
    }
}
#pragma mark - reloadData
- (void)reloadData
{
    [self initCacheData];
    [self setCellFrameWithIndexPaths:_indexPaths];
    [self loadCell];
}
- (WaterFlowViewCell *)dequeueReuseableCellWithIdentifier:(NSString *)reuseidentifier
{
#warning need update
    static int w=1;
    WaterFlowViewCell *cell = [_reuseableCellSet anyObject];
    if (cell) {
        [_reuseableCellSet removeObject:cell];
    }
    else{
        cell = [[WaterFlowViewCell alloc]initWithReuseIdentifier:reuseidentifier];
        NSLog(@"alloc cellfor row--------%d,subVIews:%d",w++,self.subviews.count);
    }
    
    return cell;
}
#pragma mark - piravate method
#warning variable would be better
- (NSInteger)rows
{
    _rows = [self.dataSource waterFlowView:self numberOfRowsInSection:0];
    return _rows;
}
- (NSInteger)columns
{
    NSInteger col = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnInWaterFlowView:)]) {
        col = [self.dataSource numberOfColumnInWaterFlowView:self];
    }
    _columns = col;
    return _columns;
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterFlowView:didSelectRowAtIndexPath:)]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    [_visibleCellDict enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, WaterFlowViewCell *cell, BOOL *stop) {
        if(CGRectContainsPoint(cell.frame, loc)){
            [self.delegate waterFlowView:self didSelectRowAtIndexPath:indexPath];
            *stop = YES;
        }
    }];

}
@end
