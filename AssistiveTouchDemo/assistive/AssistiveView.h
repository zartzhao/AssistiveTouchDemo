//
//  AssistiveView.h
//
//  可拖动的悬浮View的父类
//  Created by zart.zhao on 2016/10/12.
//

#import <UIKit/UIKit.h>

@protocol AssistiveTouchDelegate;
@interface AssistiveView : UIView


@property (nonatomic,weak) id<AssistiveTouchDelegate> delegate;


/**
 *  设置浮窗能够滑动的区域
 */
-(void)setLimitRect:(CGRect)rect;
/**
 *  是否可以吸附顶部和底部
 */
-(void)setAdsorptionTop:(BOOL)top andBottom:(BOOL)bottom;
/**
 *  设置中心在X和Y轴上比较距离。
 *  比较关系为 center距离左侧或者右侧的距离-x <= center距离顶部或者底部的距离时，
 *  则会吸附在左右两侧，否则吸附在顶部或者底部。
 */
-(void)setLimitX:(CGFloat)x andY:(CGFloat)y;

/**
 *  拖动时调用此方法，如果子类需要处理，可以继承后修改。
 */
-(void)locationChange:(UIGestureRecognizer*)gestureRecognizer;
@end


@protocol AssistiveTouchDelegate <NSObject>
@optional
//悬浮窗点击事件
-(void)assistiveTouch;
@end
