//
//  UIView+Quadrilateral.h
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Quadrilateral)

// Set's frame to bounding box of quad and applies transform
- (void)transformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

@end

NS_ASSUME_NONNULL_END
