//
//  ViewController.m
//  MMaskViewDemo
//
//  Created by 马权 on 3/9/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import "ViewController.h"
#import "MMaskController.h"
#import "MyView.h"

@interface ViewController ()<MMaskControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeContactAdd];
    but.frame = CGRectMake(0, 20, 50, 50);
    [but addTarget:self action:@selector(butAC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)butAC {
    //  1.初始化contentView
    UIView *view = [[MyView alloc] initWithFrame:CGRectMake(100, 50, 300, 200)];
    view.backgroundColor = [UIColor redColor];
    
    //  2.初始化maskController
    MMaskController *maskController = [[MMaskController alloc] initMaskController:MMaskControllerDelayDismiss
                                                                  withContentView:view
                                                                        animation:YES
                                                                    contentCenter:YES
                                                                        delayTime:3];
    //  3.设置代理。*注意*：消失回调中 [maskController release], 生命周期结束，类似于popoverController
    maskController.delegate = self;
    
    //  4.显示
    [maskController show];
    [view release];
}

#pragma mark -
#pragma mark - MMaskControllerDelegate
- (void)maskControllerDidDismiss:(MMaskController *)maskController {
    [maskController release];
    maskController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
