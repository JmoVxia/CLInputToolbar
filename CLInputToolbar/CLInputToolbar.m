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
@property (nonatomic, strong) UITextView *textView;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;
/**当前键盘是否可见*/
@property (nonatomic, assign) BOOL keyboardIsVisiable;
/**是否需要加1*/
@property (nonatomic, assign) BOOL needAdd;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendBtn;
/**发送回调*/
@property (nonatomic, copy) inputTextBlock inputTextBlock;

@end

@implementation CLInputToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0,CLscreenHeight, CLscreenWidth, 50);
        [self initView];
        [self addEventListening];
    }
    return self;
}

-(void)initView {
    self.backgroundColor = [UIColor whiteColor];
    
    self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 1)];
    self.topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    [self addSubview:self.topLine];
    
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.CLheight - 1, self.CLwidth, 1)];
    self.bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    [self addSubview:self.bottomLine];
    
    self.edgeLineView = [[UIView alloc]init];
    self.edgeLineView.CLwidth = self.CLwidth - CLButtonWidth - 30;
    self.edgeLineView.CLleft = 10;
    self.edgeLineView.layer.cornerRadius = 5;
    self.edgeLineView.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
    self.edgeLineView.layer.borderWidth = 1;
    self.edgeLineView.layer.masksToBounds = YES;
    [self addSubview:self.edgeLineView];
    
    self.textView = [[UITextView alloc] init];;
    self.textView.CLwidth = self.CLwidth - CLButtonWidth - 46;
    self.textView.CLleft = 18;
    self.textView.enablesReturnKeyAutomatically = YES;
    self.textView.delegate = self;
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    self.textView.scrollsToTop = NO;
    self.textView.textContainerInset = UIEdgeInsetsZero;
    self.textView.textContainer.lineFragmentPadding = 0;
    [self addSubview:self.textView];
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.CLwidth = self.textView.CLwidth - 10;
    self.placeholderLabel.textColor = RGBACOLOR(0, 0, 0, 0.5);
    self.placeholderLabel.CLleft = 23;
    [self addSubview:self.placeholderLabel];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - CLButtonWidth - 10, self.CLheight - CLButtonHeight - 10, CLButtonWidth, CLButtonHeight)];
    [self.sendBtn.layer setBorderWidth:1.0];
    [self.sendBtn.layer setCornerRadius:5.0];
    self.sendBtn.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
    self.sendBtn.enabled = NO;
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(didClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
    self.fontSize = 20;
    self.textViewMaxLine = 3;
}
// 添加通知
-(void)addEventListening {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (!fontSize || _fontSize < 20) {
        _fontSize = 20;
    }
    self.textView.font = [UIFont systemFontOfSize:_fontSize];
    self.placeholderLabel.font = self.textView.font;
    CGFloat lineH = self.textView.font.lineHeight;
    self.CLheight = ceil(lineH) + 10 + 10;
    self.textView.CLheight = lineH;
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine <= 0) {
        _textViewMaxLine = 3;
    }
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
}
- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.CLy = CLscreenHeight;
    }];
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendBtn.enabled = NO;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }else{
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.8) forState:UIControlStateNormal];
    }
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.CLheight = contentSizeH;
    }else{
        textView.CLheight = maxTextViewHeight;
    }
    self.CLheight = ceil(textView.CLheight) + 10 + 10;
    self.CLbottom = CLscreenHeight - _keyboardHeight;
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}
// 发送按钮
-(void)didClickSendBtn {
    if (self.inputTextBlock) {
        self.inputTextBlock(self.textView.text);
    }
}
- (void)inputToolbarSendText:(inputTextBlock)sendText{
    self.inputTextBlock = sendText;
}
- (void)popToolbar{
    self.fontSize = _fontSize;
    [self.textView becomeFirstResponder];
}
// 发送成功 清空文字 更新输入框大小
-(void)bounceToolbar {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
    [self endEditing:YES];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.edgeLineView.CLheight = self.textView.CLheight + 10;
    self.textView.CLcenterY = self.CLheight * 0.5;
    self.placeholderLabel.CLheight = self.textView.CLheight;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
    self.sendBtn.CLcenterY = self.CLheight * 0.5;
    self.edgeLineView.CLcenterY = self.CLheight * 0.5;
    self.bottomLine.CLy = self.CLheight - 1;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
