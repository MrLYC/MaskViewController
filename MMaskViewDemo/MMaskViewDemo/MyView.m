//
//  MyView.m
//  MMaskViewDemo
//
//  Created by 马权 on 3/10/15.
//  Copyright (c) 2015 maquan. All rights reserved.
//

#import "MyView.h"

@implementation MyView
- (void)dealloc
{
    [super dealloc];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    [super removeObserver:observer forKeyPath:keyPath context:context];
}

- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    [super addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    [super removeObserver:observer forKeyPath:keyPath];
}

@end
