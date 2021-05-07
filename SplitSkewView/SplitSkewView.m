//
//  SplitSkewView.m
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import "SplitSkewView.h"
#import "UIView+Quadrilateral.h"
#import "SplitSkewDemo-Swift.h"

@interface SplitView : UIView

@property (nonatomic, strong) UIImageView *iv;

@end

@implementation SplitView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.userInteractionEnabled = NO;
    
    _iv = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:_iv];
}

@end

@implementation SplitSkewView

- (void)refresh {
    self.userInteractionEnabled = NO;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[SplitView class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    NSAssert(self.splits.count == self.skews.count, @"splits count must be equal to skews!");
    for (NSInteger i = 0; i < self.splits.count; i ++) {
        CGRect rect = self.splits[i].CGRectValue;
        SplitView *split = [[SplitView alloc] initWithFrame:rect];
        split.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1.f];
        split.layer.borderColor = [UIColor grayColor].CGColor;
        split.layer.borderWidth = .5f;
        
        // snapshot appointed area
        UIImage *snapshot = [self imageFromView:self.sourceView rect:rect];
        split.iv.image = snapshot;

//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            [ImageWriter writeImageToAlbumWithImage:snapshot albumName:@"SplitSkew"];
//        });
        
        // skew
        split.layer.anchorPoint = CGPointZero;
        [split transformToFitQuadTopLeft:self.skews[i][0].CGPointValue
                                topRight:self.skews[i][1].CGPointValue
                              bottomLeft:self.skews[i][2].CGPointValue
                             bottomRight:self.skews[i][3].CGPointValue];
        [self addSubview:split];
    }
}

// loading、drag need real time refresh, so it can't not make it!!!
// the snap is too small which need to be optimized later.
-(UIImage*)imageFromView:(UIView *) v rect:(CGRect) rect{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions((CGSizeMake(v.frame.size.width * scale, v.frame.size.height * scale)), NO, scale);//NO，YES 控制是否透明
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGRect myImageRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return smallImage;
}

@end
