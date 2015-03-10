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
    UIView *view = [[MyView alloc] initWithFrame:CGRectMake(100, 50, 300, 200)];
    view.backgroundColor = [UIColor redColor];
    
    MMaskController *maskController = [[MMaskController alloc] initMaskController:MMaskControllerDelayDismiss
                                                                  withContentView:view
                                                                        animation:YES
                                                                    contentCenter:YES
                                                                        delayTime:3];
    maskController.delegate = self;
    [maskController show];
    [view release];
}

- (void)maskControllerDidDismiss:(MMaskController *)maskController {
    [maskController release];
    maskController = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
