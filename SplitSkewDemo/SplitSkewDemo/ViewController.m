//
//  ViewController.m
//  SplitSkewDemo
//
//  Created by Gavin Xiang on 2021/4/28.
//

#import "ViewController.h"
#import "SplitSkewView.h"

@interface ViewController ()

@property (nonatomic, strong) SplitSkewView *splitSkewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = 200;
    CGFloat height = 300;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, width, height)];
    customView.layer.borderColor = [UIColor orangeColor].CGColor;
    customView.layer.borderWidth = 1.f;
    [self.view addSubview:customView];
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:customView.bounds];
    [customView addSubview:iv];
    iv.image = [UIImage imageNamed:@"cat"];
    
    UILabel *text = [[UILabel alloc] initWithFrame:customView.bounds];
    text.numberOfLines = 0;
    [customView addSubview:text];
    text.text = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.May you have enough happiness to make you sweet,enough trials to make you strong,enough sorrow to keep you human,enough hope to make you happy? Always put yourself in others’shoes.If you feel that it hurts you,it probably hurts the other person, too.The happiest of people don’t necessarily have the best of everything;they just make the most of everything that comes along their way.Happiness lies for those who cry,those who hurt, those who have searched,and those who have tried,for only they can appreciate the importance of people have touched their lives.Love begins with a smile,grows with a kiss and ends with a tear.The brightest future will always be based on a forgotten past, you can’t go on well in lifeuntil you let go of your past failures and heartaches.When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying.Please send this message to those people who mean something to you,to those who have touched your life in one way or another,to those who make you smile when you really need it,to those that make you see the brighter side of things when you are really down,to those who you want to let them know that you appreciate their friendship.And if you don’t, don’t worry,nothing bad will happen to you,you will just miss out on the opportunity to brighten someone’s day with this message.";
    
    UISwitch *switchBtn = [UISwitch new];
    [switchBtn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventValueChanged];
    [customView addSubview:switchBtn];
    
    [NSLayoutConstraint activateConstraints:@[
        [switchBtn.topAnchor constraintEqualToAnchor:customView.topAnchor],
        [switchBtn.leadingAnchor constraintEqualToAnchor:customView.leadingAnchor]
    ]];
    
    [self setupSplitSkew:customView];
}


- (void)setupSplitSkew:(UIView *)sourceView {
    SplitSkewView *splitSkew = [[SplitSkewView alloc] initWithFrame:CGRectOffset(sourceView.frame, 0, CGRectGetHeight(sourceView.frame) + 20)];
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
    splitSkew.splits = [splits copy];
    splitSkew.skews =[skews copy];
    [splitSkew refresh];
    
    _splitSkewView = splitSkew;
}

- (void)switchBtnClicked:(UISwitch *)sender {
    [_splitSkewView refresh];
}

@end
