//
//  MMaskView.h
//  MMaskViewDemo
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMaskControllerType) {
    MMaskControllerDefault,                     //  调用dismiss消失
    MMaskControllerTipDismiss,                  //  调用dismiss消失、点击遮罩层消失
    MMaskControllerDelayDismiss,                //  调用dismiss消失、延迟时间消失
    MMaskControllerAll                          //  调用dismiss消失、点击遮罩层消失、延迟时间消失
};

@class MMaskController;

@protocol MMaskControllerDelegate <NSObject>

@optional
- (void)maskControllerWillDismiss:(MMaskController *)maskController;

- (void)maskControllerDidDismiss:(MMaskController *)maskController;     /*you maybe need release instance here*/

@end

@interface MMaskController : NSObject

@property (assign, nonatomic) id<MMaskControllerDelegate> delegate;
@property (retain, nonatomic, readonly) UIView *maskView;               //  可设置遮罩层颜色

/**
 *  条件初始化一个遮罩。
 *
 *  @param type 类型
 *  @param view 内容层
 *
 *  @return 实例
 */
- (instancetype)initMaskController:(MMaskControllerType)type
                   withContentView:(UIView *)view
                         animation:(BOOL)animation
                     contentCenter:(BOOL)contentCenter
                         delayTime:(CGFloat)delayTime;

/**
 *  显示maskController的内容
 */
- (void)show;

/**
 *  消失掉maskController
 */
- (void)dismiss;

@end
