//
//  ViewController.m
//  波纹加弹出动画
//
//  Created by mac on 2019/3/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height

#define ICONWIDTH 50
#define ICONDURATION 0.4

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f \
green:(g)/255.f \
blue:(b)/255.f \
alpha:(a)]

@interface ViewController ()<CAAnimationDelegate>
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *imgView1;
@property (strong, nonatomic) UIImageView *imgView2;
@property (strong, nonatomic) UIImageView *imgView3;
@property (strong, nonatomic) UIImageView *imgView4;
@property (strong, nonatomic) UIImageView *imgView5;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) CALayer *aniLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRadarAnimation];
    [self createBottomView];
    [self createButtonAndIcons];
}

- (void)createRadarAnimation {
    
    UIView *aniView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:aniView];
    aniView.backgroundColor = RGBA(253, 188, 54, 1);
    aniView.clipsToBounds = YES;
    
    CAShapeLayer *aniLayer = [CAShapeLayer layer];
    aniLayer.backgroundColor = RGBA(253, 222, 52, 1).CGColor;
    aniLayer.bounds = CGRectMake(0, 0, 60, 60);
    aniLayer.cornerRadius = 30;
    aniLayer.position = CGPointMake(SCREEN_WIDTH / 2, 360);
    
    //放大的动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1);
    scaleAnimation.toValue = @(10);
    
    //透明度
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@(0), @0.45, @0];
    opacityAnimation.keyTimes = @[@0, @(0.2), @1];
    
    //动画组
    CAAnimationGroup *aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[scaleAnimation,opacityAnimation];
    aniGroup.duration = 2;
    aniGroup.repeatCount = CGFLOAT_MAX;
    
    [aniLayer addAnimation:aniGroup forKey:NSStringFromSelector(_cmd)];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    [replicatorLayer addSublayer:aniLayer];
    replicatorLayer.instanceCount = 5;// 复制个数
    replicatorLayer.instanceDelay = 0.3;// 复制间隔
    [aniView.layer addSublayer:replicatorLayer];
    self.aniLayer = aniLayer;
}

- (void)createBottomView {
    self.bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, SCREEN_HEIGHT - 80)];
    [_bottomView setImage:[UIImage imageNamed:@"bg"]];
    [_bottomView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_bottomView];
}
- (void)createButtonAndIcons {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 100, 100);
    self.button.center = CGPointMake(SCREEN_WIDTH / 2, 360);
    [self.button setBackgroundImage:[UIImage imageNamed:@"click"] forState:UIControlStateNormal];
    self.button.layer.cornerRadius = 50;
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    self.imgView1.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
    self.imgView1.center = self.button.center;
    
    self.imgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    self.imgView2.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
    self.imgView2.center = self.button.center;
    
    self.imgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    self.imgView3.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
    self.imgView3.center = self.button.center;
    
    self.imgView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    self.imgView4.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
    self.imgView4.center = self.button.center;
    
    self.imgView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"a"]];
    self.imgView5.frame = CGRectMake(0, 0, ICONWIDTH, ICONWIDTH);
    self.imgView5.center = self.button.center;
    
    [self.view addSubview:_imgView1];
    [self.view addSubview:_imgView2];
    [self.view addSubview:_imgView3];
    [self.view addSubview:_imgView4];
    [self.view addSubview:_imgView5];
    [self.view addSubview:_button];
}

- (void)clickAction:(UIButton *)button {
    //停止雷达动画
    [self.aniLayer removeAllAnimations];
    
    //底部位移动画
    CABasicAnimation *positionAnimation = nil;
    positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 2.0f;
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 40)];
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    positionAnimation.delegate = self;
    [self.bottomView.layer addAnimation:positionAnimation forKey:NSStringFromSelector(_cmd)];
    
    //button关键帧动画
    CAKeyframeAnimation *keyAni = nil;
    keyAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAni.duration = 2.0f;
    keyAni.values = @[@(1.5),@(1.0),@(1.5),@(1.0)];
    [button.layer addAnimation:keyAni forKey:NSStringFromSelector(_cmd)];
    
    //小图标位移动画
    CABasicAnimation *baseAni1 = nil;
    baseAni1 = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAni1.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2 - ICONWIDTH * 2 - 20, 120)];
    baseAni1.duration = ICONDURATION;
    baseAni1.removedOnCompletion = NO;
    baseAni1.fillMode = kCAFillModeForwards;
    [self.imgView1.layer addAnimation:baseAni1 forKey:NSStringFromSelector(_cmd)];
    
    CABasicAnimation *baseAni2 = nil;
    baseAni2 = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAni2.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2 - ICONWIDTH - 10, 120)];
    baseAni2.duration = ICONDURATION;
    baseAni2.beginTime = CACurrentMediaTime() + ICONDURATION;
    baseAni2.removedOnCompletion = NO;
    baseAni2.fillMode = kCAFillModeForwards;
    [self.imgView2.layer addAnimation:baseAni2 forKey:NSStringFromSelector(_cmd)];
    
    CABasicAnimation *baseAni3 = nil;
    baseAni3 = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAni3.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2, 120)];
    baseAni3.duration = ICONDURATION;
    baseAni3.beginTime = CACurrentMediaTime() + ICONDURATION * 2;
    baseAni3.removedOnCompletion = NO;
    baseAni3.fillMode = kCAFillModeForwards;
    [self.imgView3.layer addAnimation:baseAni3 forKey:NSStringFromSelector(_cmd)];
    
    CABasicAnimation *baseAni4 = nil;
    baseAni4 = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAni4.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2 + ICONWIDTH + 10, 120)];
    baseAni4.duration = ICONDURATION;
    baseAni4.beginTime = CACurrentMediaTime() + ICONDURATION * 3;
    baseAni4.removedOnCompletion = NO;
    baseAni4.fillMode = kCAFillModeForwards;
    [self.imgView4.layer addAnimation:baseAni4 forKey:NSStringFromSelector(_cmd)];
    
    CABasicAnimation *baseAni5 = nil;
    baseAni5 = [CABasicAnimation animationWithKeyPath:@"position"];
    baseAni5.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2 + ICONWIDTH * 2 + 20, 120)];
    baseAni5.duration = ICONDURATION;
    baseAni5.beginTime = CACurrentMediaTime() + ICONDURATION * 4;
    baseAni5.removedOnCompletion = NO;
    baseAni5.fillMode = kCAFillModeForwards;
    [self.imgView5.layer addAnimation:baseAni5 forKey:NSStringFromSelector(_cmd)];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.button.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

