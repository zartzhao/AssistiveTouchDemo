//
//  JitterAssistiveView.m
//  AssistiveTouchDemo
//
//  Created by zart.zhao on 2016/10/13.
//  Copyright © 2016年 zart. All rights reserved.
//

#import "JitterAssistiveView.h"

#define JITTER_INTERVAL 0.5f    //抖动间隙动画
#define JITTER_DURATION 0.5f    //抖动的动画时长
#define JITTER_FRAME_COUNT 10   //抖动动画的总帧数


@implementation JitterAssistiveView{
    UIView *bottomBall;//底部圆球
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addBottomView];
    }
    return self;
}

-(void)addBottomView{
    CGFloat size = 90;
    bottomBall = [[UIView alloc]initWithFrame:CGRectMake(0,0, size, size)];
    bottomBall.layer.masksToBounds = YES;
    bottomBall.layer.cornerRadius = size*0.5f;
    bottomBall.backgroundColor = [UIColor redColor];
    [self addSubview:bottomBall];
}


//改变位置
-(void)locationChange:(UIGestureRecognizer*)gestureRecognizer
{
    [super locationChange:gestureRecognizer];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //暂停动画
        [self pauseLayer:bottomBall.layer];
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //回复动画
        [self performSelector:@selector(resumeAnimation) withObject:nil afterDelay:0.4f];
    }
}


-(void)resumeAnimation{
    [self resumeLayer:bottomBall.layer];
}

-(void)startAnimation{
    
    float duration = JITTER_DURATION+JITTER_INTERVAL;//抖动的时长为0.5f;
    float frameDuration = JITTER_DURATION / JITTER_FRAME_COUNT;
    float frameTime = frameDuration/duration;
    //球动画
    CAKeyframeAnimation *trans = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    NSArray *values = @[@(0)  , @(-20), @(-2)  , @(-16)  , @(0)  , @(0)];
    NSArray *times =  @[@(0.0), @(frameTime*3), @(frameTime*5), @(frameTime*7), @(frameTime*9), @(1.0)];
    trans.values = values;
    trans.keyTimes = times;
    trans.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    trans.autoreverses = NO;
    trans.duration = duration;
    trans.removedOnCompletion = NO;
    trans.fillMode = kCAFillModeForwards;
    trans.repeatCount = INFINITY;
    [bottomBall.layer addAnimation:trans forKey:@"trans"];
}

//暂停layer上面的动画
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}


@end
