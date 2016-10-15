//
//  ViewController.m
//  AssistiveTouchDemo
//
//  Created by zart.zhao on 2016/10/13.
//  Copyright © 2016年 zart. All rights reserved.
//

#import "ViewController.h"
#import "JitterAssistiveView.h"

@interface ViewController ()<AssistiveTouchDelegate>{
    UILabel *labelTip;
    JitterAssistiveView *jitterAssistiveView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    UIButton * btn =[[UIButton alloc]init];
    
    btn.frame = CGRectMake((screenWidth - 100)*0.5f, ([UIScreen mainScreen].bounds.size.height - 100), 100, 40);
    [btn setBackgroundColor:[UIColor grayColor]];
    [btn setTitle:@"开始动画" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), screenWidth, 40)];
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.textColor = [UIColor grayColor];
    [self.view addSubview:labelTip];
    
    jitterAssistiveView = [[JitterAssistiveView alloc]initWithFrame:CGRectMake(0, 200, 90, 90)];
    [jitterAssistiveView setAdsorptionTop:YES andBottom:YES];
    jitterAssistiveView.delegate = self;
    [self.view addSubview:jitterAssistiveView];
    
}

-(void)startAnimation
{
    [jitterAssistiveView startAnimation];
}

-(void)assistiveTouch{
    
    labelTip.text = @"单点浮窗";
    [self performSelector:@selector(cleanLabel) withObject:nil afterDelay:1.0f];
}

-(void)cleanLabel{
    labelTip.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
