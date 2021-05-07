//
//  ViewController.m
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import "ViewController.h"
#import "SplitSkewView.h"
#import "SelfSplitSkewView.h"
#import "BCMeshTransformView.h"
#import "UIView+Quadrilateral.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) SplitSkewView *splitSkewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = 200;
    CGFloat height = 300;
    CGFloat originX = 50;
    CGFloat originY = 100;
    SelfSplitSkewView *customView = [[SelfSplitSkewView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    customView.backgroundColor = [UIColor whiteColor];
    customView.layer.borderColor = [UIColor orangeColor].CGColor;
    customView.layer.borderWidth = 1.f;
    [self.view addSubview:customView];
    _customView = customView;
    
    UIView *positionView = [[UIView alloc] initWithFrame:customView.frame];
    positionView.backgroundColor = [UIColor whiteColor];
    positionView.layer.borderColor = [UIColor orangeColor].CGColor;
    positionView.layer.borderWidth = 1.f;
    [self.view addSubview:positionView];
    [self.view sendSubviewToBack:positionView];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:customView.bounds];
    // add a view hierarchy to a contentView, subviews of contentView will get mesh-transformed
    [customView addSubview:iv];
    iv.image = [UIImage imageNamed:@"cat"];
    
    UILabel *text = [[UILabel alloc] initWithFrame:customView.bounds];
    text.numberOfLines = 0;
    // add a view hierarchy to a contentView, subviews of contentView will get mesh-transformed
    [customView addSubview:text];
    text.text = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.May you have enough happiness to make you sweet,enough trials to make you strong,enough sorrow to keep you human,enough hope to make you happy? Always put yourself in others’shoes.If you feel that it hurts you,it probably hurts the other person, too.The happiest of people don’t necessarily have the best of everything;they just make the most of everything that comes along their way.Happiness lies for those who cry,those who hurt, those who have searched,and those who have tried,for only they can appreciate the importance of people have touched their lives.Love begins with a smile,grows with a kiss and ends with a tear.The brightest future will always be based on a forgotten past, you can’t go on well in lifeuntil you let go of your past failures and heartaches.When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying.Please send this message to those people who mean something to you,to those who have touched your life in one way or another,to those who make you smile when you really need it,to those that make you see the brighter side of things when you are really down,to those who you want to let them know that you appreciate their friendship.And if you don’t, don’t worry,nothing bad will happen to you,you will just miss out on the opportunity to brighten someone’s day with this message.";
    
    UISwitch *switchBtn = [UISwitch new];
    [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventValueChanged];
    // add a view hierarchy to a contentView, subviews of contentView will get mesh-transformed
    [customView addSubview:switchBtn];
    [NSLayoutConstraint activateConstraints:@[
        [switchBtn.topAnchor constraintEqualToAnchor:customView.topAnchor],
        [switchBtn.leadingAnchor constraintEqualToAnchor:customView.leadingAnchor]
    ]];
    
//    [self rotateAndPerspectiveTransform];
//    [self transfromEntireToFitQuadrilateral];
    
    [self transformSplitToFitQuadrilateral];
    
//    [self setupSelfSplitSkew:customView];
    
    // apply a mesh
//    customView.meshTransform = [self simpleMeshTransform];
    
    [self setupSplitSkew:customView];
}

- (void)transfromEntireToFitQuadrilateral {
    CGFloat width = CGRectGetWidth(_customView.frame);
    CGFloat height = CGRectGetHeight(_customView.frame);
    CGFloat originX = CGRectGetMinX(_customView.frame);
    CGFloat originY = CGRectGetMinY(_customView.frame);
    /// !!! Verty important config
    _customView.layer.anchorPoint = CGPointZero;
    [_customView transformToFitQuadTopLeft:CGPointMake(originX + 20, originY + 40)
                                 topRight:CGPointMake(originX + width - 10, originY - 10)
                               bottomLeft:CGPointMake(originX + 10, originY + height - 10)
                              bottomRight:CGPointMake(originX + width - 30, originY + height - 30)];
}

- (void)transformSplitToFitQuadrilateral {
    CGFloat width = CGRectGetWidth(_customView.frame);
    CGFloat height = CGRectGetHeight(_customView.frame);
    CGFloat originX = CGRectGetMinX(_customView.frame);
    CGFloat originY = CGRectGetMinY(_customView.frame);
    
    /// !!! Verty important config
    _customView.layer.anchorPoint = CGPointZero;
    _customView.layer.transform = CATransform3DIdentity;
//    _customView.clipsToBounds = YES;
    // skew left part
    [_customView truelyTransformRect:CGRectMake(0, 0, width / 2, height)
                    ToFitQuadTopLeft:CGPointMake(originX + 20, originY + 40)
                            topRight:CGPointMake(originX + width / 2, originY)
                          bottomLeft:CGPointMake(originX, originY + height)
                         bottomRight:CGPointMake(originX + width / 2, originY + height)];
//    _customView.layer.frame = CGRectMake(originX, originY, width, height);
    // skew right part
//    [_customView truelyTransformRect:CGRectMake(width / 2, 0, width / 2, height)
//                    ToFitQuadTopLeft:CGPointMake(originX + width / 2 + 20, originY + 20)
//                            topRight:CGPointMake(originX + width, originY)
//                          bottomLeft:CGPointMake(originX + width / 2, originY + height)
//                         bottomRight:CGPointMake(originX + width, originY + height)];
//    _customView.layer.frame = CGRectMake(originX, originY, width, height);
}

#define DegreesToRadians(X) (M_PI * (X) / 180.0)
- (void)rotateAndPerspectiveTransform {
    CGFloat lastheading = 0;
    CGFloat lastangle = DegreesToRadians(0);
    CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
    rotationAndPerspectiveTransform1.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform1 =  CATransform3DRotate(rotationAndPerspectiveTransform1,- DegreesToRadians(lastheading) , 0.0f, 0.0f, 1.0f);
    CATransform3D rotationAndPerspectiveTransform2 = CATransform3DIdentity;
    rotationAndPerspectiveTransform2.m34 = 1.0 / -500;
    rotationAndPerspectiveTransform2 =  CATransform3DRotate(rotationAndPerspectiveTransform2, ( -lastangle  + 0.3 + M_PI ), 1.0f, 0.0f, 0.0f);
    _customView.layer.transform = CATransform3DConcat(rotationAndPerspectiveTransform1, rotationAndPerspectiveTransform2);
}

- (void)setupSelfSplitSkew:(SelfSplitSkewView *)selfSplitSkewView {
    NSMutableArray <NSValue *> *splits = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray <NSArray *> *skews = [NSMutableArray arrayWithCapacity:0];
    NSInteger rows = 4;
    NSInteger columns = 6;
    for (NSInteger i = 0; i < rows * columns; i ++) {
        NSInteger row = i / columns;
        NSInteger column = i % columns;
        CGFloat splitWidth = CGRectGetWidth(selfSplitSkewView.bounds) / columns;
        CGFloat splitHeight = CGRectGetHeight(selfSplitSkewView.bounds) / rows;
        CGRect rect = CGRectMake(column * splitWidth, row * splitHeight, splitWidth, splitHeight);
        [splits addObject:[NSValue valueWithCGRect:rect]];
        
        int absolute = splitWidth / 5;
        
        CGPoint topLeft = CGPointMake(rect.origin.x + arc4random() % absolute, rect.origin.y + (arc4random() % absolute));
        CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width + (arc4random() % absolute), rect.origin.y + (arc4random() % absolute));
        CGPoint bottomLeft = CGPointMake(rect.origin.x + (arc4random() % absolute), rect.origin.y + rect.size.height + (arc4random() % absolute));
        CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width + (arc4random() % absolute), rect.origin.y + rect.size.height + (arc4random() % absolute));
        
        NSArray *skewPoints = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:topLeft],
                          [NSValue valueWithCGPoint:topRight],
                          [NSValue valueWithCGPoint:bottomLeft],
                          [NSValue valueWithCGPoint:bottomRight],
                          nil];
        [skews addObject:skewPoints];
    }
    selfSplitSkewView.splits = [splits copy];
    selfSplitSkewView.skews =[skews copy];
    [selfSplitSkewView refresh];
}

- (void)setupSplitSkew:(UIView *)sourceView {
    CGFloat width = 200;
    CGFloat height = 300;
    CGFloat originX = 50;
    CGFloat originY = 100;
    SplitSkewView *splitSkew = [[SplitSkewView alloc] initWithFrame:CGRectMake(originX, originY + height + 20, width, height)];
//    SplitSkewView *splitSkew = [[SplitSkewView alloc] initWithFrame:CGRectOffset(sourceView.frame, 0, CGRectGetHeight(sourceView.frame) + 20)];
//    SplitSkewView *splitSkew = [[SplitSkewView alloc] initWithFrame:sourceView.frame];
    splitSkew.backgroundColor = [UIColor whiteColor];
    splitSkew.layer.borderColor = [UIColor orangeColor].CGColor;
    splitSkew.layer.borderWidth = 1.f;
    splitSkew.sourceView = sourceView;
    [sourceView.superview addSubview:splitSkew];
    
    NSMutableArray <NSValue *> *splits = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray <NSArray *> *skews = [NSMutableArray arrayWithCapacity:0];
    NSInteger rows = 4;
    NSInteger columns = 6;
    for (NSInteger i = 0; i < rows * columns; i ++) {
        NSInteger row = i / columns;
        NSInteger column = i % columns;
        CGFloat splitWidth = CGRectGetWidth(sourceView.bounds) / columns;
        CGFloat splitHeight = CGRectGetHeight(sourceView.bounds) / rows;
        CGRect rect = CGRectMake(column * splitWidth, row * splitHeight, splitWidth, splitHeight);
        [splits addObject:[NSValue valueWithCGRect:rect]];
        
        int absolute = splitWidth / 4;
        
        CGPoint topLeft = CGPointMake(rect.origin.x + arc4random() % absolute, rect.origin.y + (arc4random() % absolute));
        CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width + (arc4random() % absolute), rect.origin.y + (arc4random() % absolute));
        CGPoint bottomLeft = CGPointMake(rect.origin.x + (arc4random() % absolute), rect.origin.y + rect.size.height + (arc4random() % absolute));
        CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width + (arc4random() % absolute), rect.origin.y + rect.size.height + (arc4random() % absolute));
        
        NSArray *skewPoints = [NSArray arrayWithObjects:
                          [NSValue valueWithCGPoint:topLeft],
                          [NSValue valueWithCGPoint:topRight],
                          [NSValue valueWithCGPoint:bottomLeft],
                          [NSValue valueWithCGPoint:bottomRight],
                          nil];
        [skews addObject:skewPoints];
    }
    splitSkew.splits = [splits copy];
    splitSkew.skews =[skews copy];
    [splitSkew refresh];
    
    _splitSkewView = splitSkew;
}

- (void)switchBtnClicked:(UISwitch *)sender {
    [_splitSkewView refresh];
}

#pragma mark - MeshTransform
- (BCMeshTransform *)simpleMeshTransform
{
    BCMeshVertex vertices[] = {
        {.from = {0.0, 0.0}, .to= {0.5, 0.0, 0.0}},
        {.from = {1.0, 0.0}, .to= {1.0, 0.0, 0.0}},
        {.from = {1.0, 1.0}, .to= {1.0, 1.0, 0.0}},
        {.from = {0.0, 1.0}, .to= {0.0, 1.0, 0.0}},
    };
    
    BCMeshFace faces[] = {
        {.indices = {0, 1, 2, 3}},
    };
    
    return [BCMeshTransform meshTransformWithVertexCount:4
                                                vertices:vertices
                                               faceCount:1
                                                   faces:faces
                                      depthNormalization:kBCDepthNormalizationNone];
}

@end
