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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
    [self.maskView addGestureRecognizer:tap];
    
    
    [self.view addSubview:self.maskView];
    self.maskView.hidden = YES;
    self.inputToolbar = [[CLInputToolbar alloc] initWithFrame:CGRectMake(0,self.view.CLheight, self.view.CLwidth, 50)];
    self.inputToolbar.textViewMaxLine = 4;
    self.inputToolbar.fontSize = 28;
    self.inputToolbar.delegate = self;
    self.inputToolbar.placeholder = @"  请输入...";
    [self.maskView addSubview:self.inputToolbar];
}

-(void)didTouchBtn {
    self.maskView.hidden = NO;
    [self.inputToolbar popToolbar];
}
-(void)tapActions:(UITapGestureRecognizer *)tap {
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;
}
#pragma mark - ZInputToolbarDelegate
- (void)inputToolbarSendString:(NSString *)string {
    [self.btn setTitle:string forState:UIControlStateNormal];
    // 清空输入框文字
    [self.inputToolbar bounceToolbar];
    self.maskView.hidden = YES;

}


@end
