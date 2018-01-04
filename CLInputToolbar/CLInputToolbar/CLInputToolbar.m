//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

//输入框高度
#define kInputHeight 34
//按钮高
#define kButtonH 30
//按钮宽
#define kButtonW 50
//按钮距离下边距离
#define kButtonMargin 10

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@interface CLInputToolbar ()<UITextViewDelegate>
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**文本输入框最高高度*/
@property (nonatomic, assign) NSInteger textInputMaxHeight;
/**文本输入框高度*/
@property (nonatomic, assign) CGFloat textInputHeight;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;
/**当前键盘是否可见*/
@property (nonatomic, assign) BOOL keyboardIsVisiable;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendBtn;
/**原始Y*/
@property (nonatomic, assign) CGFloat origin_y;
/**间隙*/
@property (nonatomic, assign) CGFloat padding;

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
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 0.5)];
    line.backgroundColor = RGBACOLOR(227, 228, 232, 1);
    [self addSubview:line];
    
    self.padding = self.CLheight - kInputHeight;
    
    self.textInput = [[UITextView alloc] init];;
    self.textInput.CLheight = kInputHeight;
    self.textInput.CLwidth = self.CLwidth - kButtonW - 30;
    self.textInput.CLleft = 10;
    self.textInput.CLcenterY = self.CLheight * 0.5;
    self.textInput.font = [UIFont systemFontOfSize:15];
    self.textInput.layer.cornerRadius = 5;
    self.textInput.layer.borderColor = RGBACOLOR(227, 228, 232, 1).CGColor;
    self.textInput.layer.borderWidth = 1;
    self.textInput.layer.masksToBounds = YES;
    self.textInput.returnKeyType = UIReturnKeySend;
    self.textInput.enablesReturnKeyAutomatically = YES;
    self.textInput.delegate = self;
    self.textInput.layoutManager.allowsNonContiguousLayout = NO;
    [self addSubview:self.textInput];
    
    self.placeholderLabel = [[UILabel alloc]init];
    self.placeholderLabel.CLheight = kInputHeight;
    self.placeholderLabel.CLwidth = self.CLwidth - kButtonW - 30;
    self.placeholderLabel.CLleft = 18;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
    self.placeholderLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.placeholderLabel.font = self.textInput.font;
    [self addSubview:self.placeholderLabel];
    
    self.sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - kButtonW - 10, self.CLheight - kButtonH - kButtonMargin, kButtonW, kButtonH)];
    //边框圆角
    [self.sendBtn.layer setBorderWidth:1.0];
    [self.sendBtn.layer setCornerRadius:5.0];
    self.sendBtn.layer.borderColor=[UIColor grayColor].CGColor;
    self.sendBtn.enabled = NO;
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(didClickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
}
- (void)setTextViewMaxLine:(NSInteger)textViewMaxLine {
    _textViewMaxLine = textViewMaxLine;
    if (!_textViewMaxLine || _textViewMaxLine == 0) {
        _textViewMaxLine = 4;
    }
    _textInputMaxHeight = ceil(self.textInput.font.lineHeight * (textViewMaxLine) + (textViewMaxLine - 1) * 6 +
                               self.textInput.textContainerInset.top + self.textInput.textContainerInset.bottom);
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:7];
    self.CLy = keyboardFrame.origin.y - self.CLheight;
    [UIView commitAnimations];
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
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length) {
        self.sendBtn.enabled = YES;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.9) forState:UIControlStateNormal];
    }else {
        self.sendBtn.enabled = NO;
        [self.sendBtn setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }
    // 判断是否有候选字符，如果不为nil，代表有候选字符
    if(textView.markedTextRange == nil){
        //记录光标位置
        NSUInteger loc = textView.selectedRange.location;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 6; // 字体的行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
        //还原光标位置
        textView.selectedRange = NSMakeRange(loc, 0);
    }
    
    CGFloat contentSizeH = self.textInput.contentSize.height;
    CGFloat lineH = self.textInput.font.lineHeight;
    CGFloat contentH = contentSizeH - 16;
    
    int line = contentH / lineH;
    
    if (line >self.textViewMaxLine) {
        CGPoint point = CGPointMake(0, (line -self.textViewMaxLine) * lineH + 8 + 18);
        [self.textInput setContentOffset:point animated:NO];
        self.textInput.CLheight = ceil(self.textViewMaxLine * lineH + 8 + 18);
    }else{
        self.textInput.CLheight = contentSizeH;
        [self.textInput setContentOffset:CGPointZero animated:YES];
    }
    self.CLheight = self.textInput.CLheight + _padding;
    self.CLbottom = CLscreenHeight - _keyboardHeight;
    self.textInput.CLcenterY = self.CLheight * 0.5;
    self.sendBtn.CLy = self.CLheight - kButtonH - kButtonMargin;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 点击return按钮
    if ([text isEqualToString:@"\n"]){
        if ([_delegate respondsToSelector:@selector(inputToolbarSendString:)]) {
            [_delegate inputToolbarSendString:self.textInput.text];
        }
        return NO;
    }
    return YES;
}
// 发送按钮
-(void)didClickSendBtn {
    if ([_delegate respondsToSelector:@selector(inputToolbarSendString:)]) {
        [_delegate inputToolbarSendString:self.textInput.text];
    }
}
- (void)popToolbar{
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
