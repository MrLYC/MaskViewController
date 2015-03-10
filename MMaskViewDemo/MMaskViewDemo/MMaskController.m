//
//  MMaskView.m
//  MMaskViewDemo
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import "MMaskController.h"

#define SYSTEM_VERSION [UIDevice currentDevice].systemVersion.floatValue
#define CURRENT_DEVICE [UIDevice currentDevice].userInterfaceIdiom

@interface MMaskController () <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIView *contentView;          //  内容层。
@property (assign, nonatomic) BOOL animation;               //  消失和出现是否有动画,default NO
@property (assign, nonatomic) BOOL contentViewCenter;       //  内容是否显示在中心。

@end

@implementation MMaskController

- (void)dealloc
{
    [_maskView release];
    _maskView = nil;
    [_contentView release];
    _contentView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _contentViewCenter = NO;
        _animation = NO;
        
        _maskView = [[UIView alloc] init];
        //  8.0+ 和 8.0-加的地方不一样。
        if (SYSTEM_VERSION < 8.0) {
            [[[[UIApplication sharedApplication].keyWindow subviews] objectAtIndex:0] addSubview:_maskView];
            _maskView.frame = ((UIView *)[[[UIApplication sharedApplication].keyWindow subviews] objectAtIndex:0]).bounds;
        }
        //  8.0+加载keyWindow上，因为在8.0+的系统上，keyWindow上的view会跟随转屏旋转。
        else
        {
            [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
            _maskView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        }
    
        //  添加转屏通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    return self;
}

- (instancetype)initWithContentView:(UIView *)view {
    self = [self init];
    if (self) {
        self.contentView = view;
        [_maskView addSubview:self.contentView];
    }
    return self;
}

- (instancetype)initMaskController:(MMaskControllerType)type
                   withContentView:(UIView *)view
                         animation:(BOOL)animation
                     contentCenter:(BOOL)contentCenter
                         delayTime:(CGFloat)delayTime {
    self = [self initWithContentView:view];
    if (self) {
        self.animation = animation;
        self.contentViewCenter = contentCenter;
        
        //  默认类型
        if (type == MMaskControllerDefault) {
            
        }
        
        //  点击消失
        if (type == MMaskControllerTipDismiss) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
            tapGesture.delegate = self;
            [_maskView addGestureRecognizer:tapGesture];
            [tapGesture release];
        }
        
        //  延迟消失
        if (type == MMaskControllerDelayDismiss) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
        }
        
        //
        if (type == MMaskControllerAll) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
            tapGesture.delegate = self;
            [_maskView addGestureRecognizer:tapGesture];
            [tapGesture release];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:delayTime];
        }
    }
    return self;
}

- (void)show {
    //  如果设置了内容中心，就显示在中心
    if (_contentViewCenter) {
        self.contentView.center = _maskView.center;
    }
    //  如果设置了动画，要进行动画。
    if (_animation) {
        [self showAnimation:^{
            
        }];
    }
}

- (void)dismiss {
    
    //  如果点击调用隐藏，那么取消延时隐藏。
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    
    if ([_delegate respondsToSelector:@selector(maskControllerWillDismiss:)]) {
        [_delegate maskControllerWillDismiss:self];
    }
    
    if (_animation) {
        [self dismissAnimation:^{
            [_maskView removeFromSuperview];
            if ([_delegate respondsToSelector:@selector(maskControllerDidDismiss:)]) {
                [_delegate maskControllerDidDismiss:self];
            }
        }];
    }
    else {
        if ([_delegate respondsToSelector:@selector(maskControllerDidDismiss:)]) {
            [_maskView removeFromSuperview];
            [_delegate maskControllerDidDismiss:self];
        }
    }
}

- (void)showAnimation:(void (^)())complete {
    _contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    _maskView.alpha = 0.01;
    [UIView animateWithDuration:.3 animations:^{
        _contentView.transform = CGAffineTransformMakeScale(1, 1);
        _contentView.alpha = 1.0;
        _maskView.alpha = 1.0;
        if (complete) {
            complete();
        }
    }];
}

- (void)dismissAnimation:(void (^)())complete {
    [UIView animateWithDuration:.3 animations:^(){
        _contentView.transform = CGAffineTransformMakeScale(.01, .01);
        _contentView.alpha = .1;
        _maskView.alpha = .1;
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
    }];
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
//  这个方法是当点击自定义contentView时，不要触发手势。 否则手就拦截了本身要传给contentView的手势消息。
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_maskView];
    if (CGRectContainsPoint(self.contentView.frame, point))
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -
#pragma mark - Notify
- (void)orientationDidChange:(NSNotification *)notify {
    CGFloat animateDuration;
    if (CURRENT_DEVICE == UIUserInterfaceIdiomPhone) {
        animateDuration = 0.3;
    }
    else {
        animateDuration = 0.4;
    }
    
    [UIView animateKeyframesWithDuration:animateDuration delay:0.0 options:(UIViewKeyframeAnimationOptionLayoutSubviews) animations:^{
        //  重新设置maskView的大小
        if (SYSTEM_VERSION < 8.0) {
            _maskView.frame = ((UIView *)[UIApplication sharedApplication].keyWindow.subviews[0]).bounds;
        }
        else {
            _maskView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        }
        
        //  重新设置contentView的位置
        if (_contentViewCenter) {
            _contentView.center = _maskView.center;
        }
        
        //  转屏触发contentView的layoutSubview:,重新布局
        [_contentView setNeedsDisplay];
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
