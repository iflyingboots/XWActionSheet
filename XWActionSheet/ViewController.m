//
//  ViewController.m
//  XWActionSheet
//
//  Created by Xin Wang on 11/23/16.
//  Copyright © 2016 Xin Wang. All rights reserved.
//

#import "ViewController.h"
#import "XWActionSheetView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XWActionSheetView *actionSheet = [[XWActionSheetView alloc] initWithTitles:@[@"椰子鸡", @"炸猪排", @"重庆火锅"]];
    actionSheet.caption = @"今天吃什么";
    [actionSheet show];
    [actionSheet observeTapEventWithHandler:^(NSUInteger index, NSString *title, XWActionSheetItemType type) {
        NSLog(@">> %@, %@, %@", @(index), title, @(type));
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
