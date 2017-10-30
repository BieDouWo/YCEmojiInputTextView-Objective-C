//
//  ViewController.m
//  YCEmojiInputTextViewDemo
//
//  Created by 别逗我 on 2017/10/30.
//  Copyright © 2017年 YuChengGuo. All rights reserved.
//

#import "ViewController.h"
#import "YCChatInputPanelView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    YCChatInputPanelView *chatInputPanelView = [[YCChatInputPanelView alloc] init];
    [self.view addSubview:chatInputPanelView];
}

@end
