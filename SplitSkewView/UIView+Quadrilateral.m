//
//  UIView+Quadrilateral.m
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import "UIView+Quadrilateral.h"

@implementation UIView (Quadrilateral)

- (void)splitTransformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br splitId:(NSString *)splitId
{
    //NSAssert(CGPointEqualToPoint(self.layer.anchorPoint, CGPointZero),@"Anchor point must be (0,0)!");
    CGRect boundingBox = [[self class] boundingBoxForQuadTR:tr tl:tl bl:bl br:br];
    //self.frame = boundingBox;
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    layer.frame = CGRectMake(boundingBox.origin.x, boundingBox.origin.y, self.frame.size.width, self.frame.size.height);
    
    CGPoint frameTopLeft = boundingBox.origin;
    
    CATransform3D transform = [[self class] rectToQuad:self.bounds
                                                quadTL:CGPointMake(tl.x-frameTopLeft.x, tl.y-frameTopLeft.y)
                                                quadTR:CGPointMake(tr.x-frameTopLeft.x, tr.y-frameTopLeft.y)
                                                quadBL:CGPointMake(bl.x-frameTopLeft.x, bl.y-frameTopLeft.y)
                                                quadBR:CGPointMake(br.x-frameTopLeft.x, br.y-frameTopLeft.y)];
    
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.duration=0;
    ba.speed = 1000;
    ba.fillMode = kCAFillModeForwards;
    ba.removedOnCompletion = NO;
    ba.toValue= [NSValue valueWithCATransform3D:transform];
    [layer removeAnimationForKey:splitId];
    [layer addAnimation:ba forKey:splitId];
    
    CALayer *mainLayer = [CALayer layer];
    [mainLayer addSublayer:layer];
    [self.layer addSublayer:mainLayer];
    
//    [self.layer addSublayer:layer];
    
    //self.layer.transform = transform;
}

- (void)truelyTransformRect:(CGRect)rect ToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br;
{
//    NSAssert(CGPointEqualToPoint(self.layer.anchorPoint, CGPointZero),@"Anchor point must be (0,0)!");
    self.layer.anchorPoint = CGPointZero;
    CGRect boundingBox = [[self class] boundingBoxForQuadTR:tr tl:tl bl:bl br:br];
//    self.frame = boundingBox;
    self.frame = CGRectMake(boundingBox.origin.x, boundingBox.origin.y, self.frame.size.width, self.frame.size.height);
    
    CGPoint frameTopLeft = boundingBox.origin;

    CATransform3D transform = [[self class] rectToQuad:boundingBox
                                                quadTL:CGPointMake(tl.x-frameTopLeft.x, tl.y-frameTopLeft.y)
                                                quadTR:CGPointMake(tr.x-frameTopLeft.x, tr.y-frameTopLeft.y)
                                                quadBL:CGPointMake(bl.x-frameTopLeft.x, bl.y-frameTopLeft.y)
                                                quadBR:CGPointMake(br.x-frameTopLeft.x, br.y-frameTopLeft.y)];
    
//    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
//    ba.duration=0;
//    ba.speed = 1000;
//    ba.fillMode = kCAFillModeForwards;
//    ba.removedOnCompletion = NO;
//    ba.toValue= [NSValue valueWithCATransform3D:transform];
//    [self.layer removeAnimationForKey:matrixKey];
//    [self.layer addAnimation:ba forKey:matrixKey];
    
    //self.layer.transform = transform;
    
//    CGRect convertedRect = [self convertRect:rect fromView:self.superview];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.bounds = rect;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
    self.layer.transform = CATransform3DConcat(self.layer.transform, transform);
    
//    self.layer.mask = nil;
//    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
//    self.layer.frame = rect;
//    self.layer.frame = self.frame;
}

- (void)transformToFitQuadTopLeft:(CGPoint)tl topRight:(CGPoint)tr bottomLeft:(CGPoint)bl bottomRight:(CGPoint)br
{
    
    NSAssert(CGPointEqualToPoint(self.layer.anchorPoint, CGPointZero),@"Anchor point must be (0,0)!");
    CGRect boundingBox = [[self class] boundingBoxForQuadTR:tr tl:tl bl:bl br:br];
//    self.frame = boundingBox;
    self.frame = CGRectMake(boundingBox.origin.x, boundingBox.origin.y, self.frame.size.width, self.frame.size.height);
    
    CGPoint frameTopLeft = boundingBox.origin;
    
    CATransform3D transform = [[self class] rectToQuad:self.bounds
                                                quadTL:CGPointMake(tl.x-frameTopLeft.x, tl.y-frameTopLeft.y)
                                                quadTR:CGPointMake(tr.x-frameTopLeft.x, tr.y-frameTopLeft.y)
                                                quadBL:CGPointMake(bl.x-frameTopLeft.x, bl.y-frameTopLeft.y)
                                                quadBR:CGPointMake(br.x-frameTopLeft.x, br.y-frameTopLeft.y)];
    
    CABasicAnimation* ba = [CABasicAnimation animationWithKeyPath:@"transform"];
    ba.duration=0;
    ba.speed = 1000;
    ba.fillMode = kCAFillModeForwards;
    ba.removedOnCompletion = NO;
    ba.toValue= [NSValue valueWithCATransform3D:transform];
    [self.layer removeAnimationForKey:@"ani"];
    [self.layer addAnimation:ba forKey:@"ani"];
    
    //self.layer.transform = transform;
}

+ (CGRect)boundingBoxForQuadTR:(CGPoint)tr tl:(CGPoint)tl bl:(CGPoint)bl br:(CGPoint)br
{
    CGRect boundingBox = CGRectZero;
    
    CGFloat xmin = MIN(MIN(MIN(tr.x, tl.x), bl.x),br.x);
    CGFloat ymin = MIN(MIN(MIN(tr.y, tl.y), bl.y),br.y);
    CGFloat xmax = MAX(MAX(MAX(tr.x, tl.x), bl.x),br.x);
    CGFloat ymax = MAX(MAX(MAX(tr.y, tl.y), bl.y),br.y);
    
    boundingBox.origin.x = xmin;
    boundingBox.origin.y = ymin;
    boundingBox.size.width = xmax - xmin;
    boundingBox.size.height = ymax - ymin;
    
    return boundingBox;
}

+ (CATransform3D)rectToQuad:(CGRect)rect
                     quadTL:(CGPoint)topLeft
                     quadTR:(CGPoint)topRight
                     quadBL:(CGPoint)bottomLeft
                     quadBR:(CGPoint)bottomRight
{
    return [self rectToQuad:rect quadTLX:topLeft.x quadTLY:topLeft.y quadTRX:topRight.x quadTRY:topRight.y quadBLX:bottomLeft.x quadBLY:bottomLeft.y quadBRX:bottomRight.x quadBRY:bottomRight.y];
}

// http://stackoverflow.com/questions/9470493/transforming-a-rectangle-image-into-a-quadrilateral-using-a-catransform3d
+ (CATransform3D)rectToQuad:(CGRect)rect
                    quadTLX:(CGFloat)x1a
                    quadTLY:(CGFloat)y1a
                    quadTRX:(CGFloat)x2a
                    quadTRY:(CGFloat)y2a
                    quadBLX:(CGFloat)x3a
                    quadBLY:(CGFloat)y3a
                    quadBRX:(CGFloat)x4a
                    quadBRY:(CGFloat)y4a
{
    CGFloat X = rect.origin.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    
    CGFloat y21 = y2a - y1a;
    CGFloat y32 = y3a - y2a;
    CGFloat y43 = y4a - y3a;
    CGFloat y14 = y1a - y4a;
    CGFloat y31 = y3a - y1a;
    CGFloat y42 = y4a - y2a;
    
    CGFloat a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
    CGFloat b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    CGFloat c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
    
    CGFloat d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
    CGFloat e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
    CGFloat f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));
    
    CGFloat g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
    CGFloat h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
    CGFloat i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));
    
    const double kEpsilon = 0.0001;
    
    if(fabs(i) < kEpsilon)
    {
        i = kEpsilon* (i > 0 ? 1.0 : -1.0);
    }
    
    CATransform3D transform = {a/i, d/i, 0, g/i, b/i, e/i, 0, h/i, 0, 0, 1, 0, c/i, f/i, 0, 1.0};
    
    return transform;
}

@end
