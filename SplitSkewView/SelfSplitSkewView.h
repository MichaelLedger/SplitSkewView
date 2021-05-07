//
//  SelfSplitSkewView.h
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelfSplitSkewView : UIView

@property (nonatomic, copy) NSArray <NSValue *> *splits;

@property (nonatomic, copy) NSArray <NSArray <NSValue *> *> *skews;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
