//
//  SelfSplitSkewView.m
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/29.
//

#import "SelfSplitSkewView.h"
#import "UIView+Quadrilateral.h"
#import "SplitSkewDemo-Swift.h"

#define K_HEIGHT      100.0
#define K_PDD_WIDTH   20.0

@implementation SelfSplitSkewView

- (void)drawRect:(CGRect)rect {
    // Drawing code.
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 0);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 100, 100);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 0, 150);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, 50, 180);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)refresh {
    NSAssert(self.splits.count == self.skews.count, @"splits count must be equal to skews!");
    for (NSInteger i = 0; i < self.splits.count; i ++) {
//        CGRect rect = self.splits[i].CGRectValue;
        
        // skew
        self.layer.anchorPoint = CGPointZero;
        [self splitTransformToFitQuadTopLeft:self.skews[i][0].CGPointValue
                                topRight:self.skews[i][1].CGPointValue
                              bottomLeft:self.skews[i][2].CGPointValue
                             bottomRight:self.skews[i][3].CGPointValue
         splitId:[NSString stringWithFormat:@"%ld", i]];
    }
}

@end
