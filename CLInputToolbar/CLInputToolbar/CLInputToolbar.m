//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

//按钮高
#define CLButtonHeight 30
//按钮宽
#define CLButtonWidth 50

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@interface CLInputToolbar ()<UITextViewDelegate>
/**文本输入框*/
@property (nonatomic, strong) UITextView *textInput;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;
/**当前键盘是否可见*/
@property (nonatomic, assign) BOOL keyboardIsVisiable;
/**是否需要加1*/
@property (nonatomic, assign) BOOL needAdd;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendBtn;
/**原始Y*/
@property (nonatomic, assign) CGFloat origin_y;
/**记录上一次的行*/
@property (nonatomic, assign) NSInteger lastLine;

@end

@implementation CLInputToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.origin_y = frame.origin.y;
        [self initView];
        [self addEventListening];
    }
    return self;
}

-(void)initView {
    self.backgroundColor = [UIColor whiteColor];
    self.textViewMaxLine = 4;
    
    self.textInput = [[UITextView alloc] init];;
    self.textInput.CLwidth = self.CLwidth - CLButtonWidth - 46;
    self.textInput.CLleft = 18;
    self.textInput.enablesReturnKeyAutomatically = YES;
    self.textInput.delegate = self;
    self.textInput.layoutManager.allowsNonContiguousLayout = NO;
    self.textInput.scrollsToTop = NO;
    self.textInput.textContainerInset = UIEdgeInsetsZero;
    self.textInput.textContainer.lineFragmentPadding = 0;
    [self addSubview:self.textInput];
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.CLwidth = self.CLwidth - CLButtonWidth - 30;
    self.placeholderLabel.CLleft = 10;
    self.placeholderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.placeholderLabel.font = self.textInput.font;
    self.placeholderLabel.layer.cornerRadius = 5;
    self.placeholderLabel.layer.borderColor = RGBACOLOR(227, 228, 232, 1).CGColor;
    self.placeholderLabel.layer.borderWidth = 1;
    self.placeholderLabel.layer.masksToBounds = YES;
    [self addSubview:self.placeholderLabel];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - CLButtonWidth - 10, self.CLheight - CLButtonHeight - 10, CLButtonWidth, CLButtonHeight)];
    //边框圆角
    [self.sendBtn.layer setBorderWidth:1.0];
    [self.sendBtn.layer setCornerRadius:5.0];
    self.sendBtn.layer.borderColor=[UIColor grayColor].CGColor;
    self.sendBtn.enabled = NO;
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(didClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
    
    self.fontSize = 20;

}
-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (!fontSize || _fontSize < 20) {
        _fontSize = 20;
    }
    self.textInput.font = [UIFont systemFontOfSize:_fontSize];
    CGFloat lineH = self.textInput.font.lineHeight;
    self.CLheight = ceil(lineH) + 10 + 10;
    self.textInput.CLheight = lineH;
    self.placeholderLabel.CLheight = lineH + 10;
    self.textInput.CLcenterY = self.CLheight * 0.5;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
    self.sendBtn.CLcenterY = self.CLheight * 0.5;
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 4;
    }
}
// 添加通知
-(void)addEventListening {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}
#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = keyboardFrame.origin.y - self.CLheight;
    }];
    self.keyboardIsVisiable = YES;
    if (self.keyIsVisiableBlock) {
        self.keyIsVisiableBlock(YES);
    }
}
- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = self.origin_y;
    }];
    self.keyboardIsVisiable = NO;
    if (self.keyIsVisiableBlock) {
        self.keyIsVisiableBlock(NO);
    }
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholderLabel.text = _placeholder;
        self.sendBtn.enabled = NO;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }else{
        self.placeholderLabel.text = @"";
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.9) forState:UIControlStateNormal];
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 0)];
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat contentH = contentSizeH - _fontSize;
    NSInteger line = (contentH) / (lineH);
    if (line == 0) {
        _needAdd = YES;
    }
    if (_needAdd) {
        line ++;
    }
    if (line <= self.textViewMaxLine) {
        textView.CLheight = contentSizeH;
    }
    self.CLheight = self.textInput.CLheight + 10 + 10;
    self.CLbottom = CLscreenHeight - _keyboardHeight;
    self.placeholderLabel.CLheight = self.textInput.CLheight + 10;
    self.textInput.CLcenterY = self.CLheight * 0.5;
    self.sendBtn.CLcenterY = self.CLheight * 0.5;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
}
// 发送按钮
-(void)didClickSendBtn {
    if ([_delegate respondsToSelector:@selector(inputToolbarSendString:)]) {
        [_delegate inputToolbarSendString:self.textInput.text];
    }
}
- (void)popToolbar{
    self.fontSize = _fontSize;
    [self.textInput becomeFirstResponder];
}
// 发送成功 清空文字 更新输入框大小
-(void)bounceToolbar {
    self.textInput.text = nil;
    [self.textInput.delegate textViewDidChange:self.textInput];
    [self endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
