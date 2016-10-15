//
//  AssistiveView.m
//
//  Created by zart.zhao on 2016/10/12.
//

#import "AssistiveView.h"


#define ViewWidth  self.frame.size.width
#define ViewHeight self.frame.size.height
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height


@implementation AssistiveView{
    CGPoint lastPoint;//记录上一次手指的位置
    
    CGRect limitRect;//View所能活动的区域范围，包括四个方向的临界
    BOOL adsorptionTop;//能否吸附顶部
    BOOL adsorptionBottom;//能否吸附底部
    //以下两个值，用于在拖动到四个角的位置时，判断是否吸附到左右两侧还是上下两端
    CGFloat limitX;//左右距离活动区域边界,默认40
    CGFloat limitY;//上下距离活动区域边界,默认20
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addGesture];
        limitRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        adsorptionTop = YES;
        adsorptionBottom = YES;
        limitX = 40.0f;
        limitY = 20.0f;
    }
    return self;
}


-(void)addGesture{
    //拖动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
    pan.delaysTouchesBegan = YES;
    [self addGestureRecognizer:pan];
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self addGestureRecognizer:tap];
}

//改变位置
-(void)locationChange:(UIGestureRecognizer*)gestureRecognizer
{
    
    CGPoint panPoint = [gestureRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //拖动开始
        lastPoint = CGPointMake(panPoint.x, panPoint.y);
    }else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //拖动过程中
        self.center = CGPointMake(self.center.x + panPoint.x-lastPoint.x, self.center.y+panPoint.y-lastPoint.y);
        lastPoint = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //拖动结束，释放，此时需要根据位置，将图片恢复到边缘位置
        //根据当前中心点的坐标，超过限定区域的一半，则在右侧，否则在左侧
        CGPoint endPoint ;
        CGPoint currentCenter = CGPointMake(self.center.x + panPoint.x-lastPoint.x, self.center.y+panPoint.y-lastPoint.y);
        CGFloat dxL = currentCenter.x - limitRect.origin.x - limitX;
        CGFloat dxR = CGRectGetMaxX(limitRect) - currentCenter.x - limitX;
        CGFloat dyT = currentCenter.y - limitRect.origin.y - limitY;
        CGFloat dyB = CGRectGetMaxY(limitRect) - currentCenter.y - limitY;
        CGFloat newX = currentCenter.x;
        CGFloat newY = currentCenter.y;
        //1、处理边界位置的情况
        if(currentCenter.x<(limitRect.origin.x + ViewWidth*0.5f)){
            //太靠左
            newX = (limitRect.origin.x + ViewWidth*0.5f);
        }
        if(currentCenter.x > (CGRectGetMaxX(limitRect) - ViewWidth*0.5f)){
            //太靠右
            newX = (CGRectGetMaxX(limitRect) - ViewWidth*0.5f);
        }
        
        if(currentCenter.y < (limitRect.origin.y + ViewHeight*0.5f)){
            //太靠上
            newY =  (limitRect.origin.y + ViewHeight*0.5f);
        }
        if(currentCenter.y > (CGRectGetMaxY(limitRect)- ViewHeight*0.5f)){
            //太靠下
            newY =  (CGRectGetMaxY(limitRect) - ViewHeight*0.5f);
        }
        
        //处理是在左侧还是在右侧
        if(currentCenter.x <= CGRectGetMidX(limitRect)){//在区域的左侧
            if(dyT <= dyB && dxL > dyT && adsorptionTop){//顶部
                newY = (limitRect.origin.y + ViewHeight*0.5f);
            }else if(dyT > dyB && dxL > dyB && adsorptionBottom){//底部
                newY =  (CGRectGetMaxY(limitRect) - ViewHeight*0.5f);
            }else{
                newX = (limitRect.origin.x + ViewWidth*0.5f);
            }
            
        }else{//在区域右侧
            if(dyT <= dyB && dxR > dyT && adsorptionTop){//顶部
                newY =  (limitRect.origin.y + ViewHeight*0.5f);
            }else if(dyT > dyB && dxR > dyB && adsorptionBottom){//底部
                newY =  (CGRectGetMaxY(limitRect) - ViewHeight*0.5f);
            }else{
                newX = (CGRectGetMaxX(limitRect) - ViewWidth*0.5f);
            }
        }
        
        endPoint = CGPointMake(newX, newY);
        [UIView animateWithDuration:0.2 animations:^{
            self.center = endPoint;
        }];
    }
}

//点击事件
-(void)click:(UITapGestureRecognizer*)t
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(assistiveTouch)]){
        [self.delegate assistiveTouch];
    }
}

-(void)setLimitRect:(CGRect)rect{
    limitRect = rect;
}
-(void)setAdsorptionTop:(BOOL)top andBottom:(BOOL)bottom{
    adsorptionTop = top;
    adsorptionBottom = bottom;
}
-(void)setLimitX:(CGFloat)x andY:(CGFloat)y{
    limitX = x;
    limitY = y;
    
}

@end
