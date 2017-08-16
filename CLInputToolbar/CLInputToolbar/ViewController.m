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
@interface ViewController ()<CLInputToolbarDelegate>
@property (nonatomic, strong) CLInputToolbar *inputToolbar;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, self.view.CLwidth - 20, 100)];
    [self.btn setBackgroundColor:[UIColor redColor]];
    [self.btn setTitle:@"点我" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(didTouchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    // 输入框
    [self setTextViewToolbar];
}

-(void)setTextViewToolbar {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.CLheight, self.view.CLwidth, 50)];
    self.inputToolbar.textViewMaxLine = 5;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholderLabel.text = @"请输入...";
    [self.maskView addSubview:self.inputToolbar];
}

-(void)didTouchBtn {
    self.maskView.hidden = NO;
    [self.inputToolbar.textInput becomeFirstResponder];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.inputToolbar.textInput resignFirstResponder];
    self.maskView.hidden = YES;
}
#pragma mark - ZInputToolbarDelegate
-(void)inputToolbar:(CLInputToolbar *)inputToolbar sendContent:(NSString *)sendContent {
    [self.btn setTitle:sendContent forState:UIControlStateNormal];
    // 清空输入框文字
    [self.inputToolbar sendSuccessEndEditing];
}

@end