//
//  ViewController.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "ViewController.h"
#import "UIView+CLSetRect.h"
#import "CLInputToolbar.h"
@interface ViewController ()
@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, self.view.cl_width - 20, 100)];
    [self.btn setBackgroundColor:[UIColor orangeColor]];
    [self.btn setTitle:@"点我" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(didTouchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    // 输入框
    [self setTextViewToolbar];
}

-(void)setTextViewToolbar {
    self.inputToolbar = [[CLInputToolbar alloc] init];
    self.inputToolbar.textViewMaxLine = 3;
    self.inputToolbar.fontSize = 20;
    self.inputToolbar.placeholder = @"请输入...";
    self.inputToolbar.showMaskView = YES;
    __weak __typeof(self) weakSelf = self;
    [self.inputToolbar inputToolbarSendText:^(NSString *text) {
        __typeof(&*weakSelf) strongSelf = weakSelf;
        NSLog(@"%@",strongSelf.inputToolbar.inputText);
        [strongSelf.btn setTitle:text forState:UIControlStateNormal];
        // 清空输入框文字
        [strongSelf.inputToolbar clearText];
    }];
}

-(void)didTouchBtn {
    [self.inputToolbar showToolbar];
}


@end
