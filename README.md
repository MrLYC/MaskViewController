# MaskViewController
通用型遮罩层，类似于UIPopoverController，但是更轻量级，适用于临时气泡弹窗等。

###优势
* 相比UIPopoverController，独有随时随地可以show的优势（类似UIAlertView）不用指定加载某层view，也不需要从vc present。
* 提供以下四种使用场景类型，根据不同的使用需求可以进行设置。
```objc
typedef NS_ENUM(NSUInteger, MMaskControllerType) {
    MMaskControllerDefault,                     //  1.调用dismiss消失
    MMaskControllerTipDismiss,                  //  2.调用dismiss消失、点击遮罩层消失
    MMaskControllerDelayDismiss,                //  3.调用dismiss消失、延迟时间消失
    MMaskControllerAll                          //  4.调用dismiss消失、点击遮罩层消失、延迟时间消失
};
```

同时提供一下两个常用属性：
```objc
@property (assign, nonatomic) BOOL animation;               //  消失和出现是否有动画.default NO
@property (assign, nonatomic) BOOL contentViewCenter;       //  内容是否显示在中心.default NO
```
