//
//  UIView+Quadrilateral.h
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Quadrilateral)

- (void)splitTransformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br splitId:(NSString *)splitId;

// Phonily Set's frame to bounding box of quad and applies transform
- (void)transformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

// Truely Set's part rect to bounding box of quad and applies transform
- (void)truelyTransformRect:(CGRect)rect ToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;

@end

NS_ASSUME_NONNULL_END
