//
//  CLInputToolbar.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import "CLInputToolbar.h"
#import "UIView+CLSetRect.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface CLInputToolbar ()<UITextViewDelegate>
/*遮罩*/
@property (nonatomic, strong) UIView *maskView;
/**文本输入框*/
@property (nonatomic, strong) UITextView *textView;
/**边框*/
@property (nonatomic, strong) UIView *edgeLineView;
/**顶部线条*/
@property (nonatomic, strong) UIView *topLine;
/**底部线条*/
@property (nonatomic, strong) UIView *bottomLine;
/**textView占位符*/
@property (nonatomic, strong) UILabel *placeholderLabel;
/**发送按钮*/
@property (nonatomic, strong) UIButton *sendButton;
/*keyWindow*/
@property (nonatomic, strong) UIWindow *keyWindow;
/**键盘高度*/
@property (nonatomic, assign) CGFloat keyboardHeight;
/**发送回调*/
@property (nonatomic, copy) inputToolBarSendBlock sendBlock;

@end

@implementation CLInputToolbar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0,0, CLscreenWidth, 50);
        [self initView];
    }
    return self;
}
-(void)initView {
    self.backgroundColor = [UIColor whiteColor];
    //顶部线条
    [self addSubview:self.topLine];
    //底部线条
    [self addSubview:self.bottomLine];
    //边框
    [self addSubview:self.edgeLineView];
    //输入框
    [self addSubview:self.textView];
    //占位文字
    [self addSubview:self.placeholderLabel];
    //发送按钮
    [self addSubview:self.sendButton];
    self.fontSize = 20;
    self.textViewMaxLine = 3;
}

-(void)setFontSize:(CGFloat)fontSize{
    _fontSize = fontSize;
    if (!fontSize || _fontSize < 18) {
        _fontSize = 18;
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

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    if (textView.text.length == 0) {
        self.sendButton.enabled = NO;
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
    }else{
        self.sendButton.enabled = YES;
        [self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 1.0) forState:UIControlStateNormal];
    }
    CGFloat contentSizeH = textView.contentSize.height;
    CGFloat lineH = textView.font.lineHeight;
    CGFloat maxTextViewHeight = ceil(lineH * self.textViewMaxLine + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxTextViewHeight) {
        textView.CLheight = contentSizeH;
    }else{
        textView.CLheight = maxTextViewHeight;
    }
    
    CGFloat newHeight = ceil(textView.CLheight) + 10 + 10;
    CGFloat change = newHeight - self.CLheight;
    if (change != 0) {
        self.CLheight = newHeight;
        self.CLtop = self.CLtop - change;
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}
- (void)tapActions:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dissmissToolbar];
}
- (NSString *)inputText {
    return self.textView.text;
}
// 发送按钮
-(void)didClicksendButton {
    if (self.sendBlock) {
        self.sendBlock(self.textView.text);
    }
}
- (void)inputToolbarSendText:(inputToolBarSendBlock)sendBlock{
    self.sendBlock = sendBlock;
}
- (void)showToolbar{
    if (_showMaskView) {
        [self.keyWindow addSubview:self.maskView];
    }
    [self.keyWindow addSubview:self];
    self.fontSize = _fontSize;
    [self.textView becomeFirstResponder];
}
-(void)dissmissToolbar {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
    [self endEditing:YES];
    [self removeFromSuperview];
    if (_showMaskView) {
        [self.maskView removeFromSuperview];
    }
}
- (void)clearText {
    self.textView.text = nil;
    [self.textView.delegate textViewDidChange:self.textView];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat newHeight = ceil(_textView.CLheight) + 10 + 10;
    CGFloat change = newHeight - self.CLheight;
    if (change != 0) {
        self.CLheight = newHeight;
        self.CLtop = self.CLtop - change;
    }
    self.edgeLineView.CLheight = self.textView.CLheight + 10;
    self.textView.CLcenterY = self.CLheight * 0.5;
    self.placeholderLabel.CLheight = self.textView.CLheight;
    self.placeholderLabel.CLcenterY = self.CLheight * 0.5;
    self.sendButton.CLcenterY = self.CLheight * 0.5;
    self.edgeLineView.CLcenterY = self.CLheight * 0.5;
    self.bottomLine.CLy = self.CLheight - 1;
}
//MARK:JmoVxia---懒加载
- (UIView *) maskView{
    if (_maskView == nil){
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CLscreenWidth, CLscreenHeight)];
        _maskView.backgroundColor = [UIColor lightGrayColor];
        _maskView.alpha = 0.5;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActions:)];
        [_maskView addGestureRecognizer:tapGestureRecognizer];
    }
    return _maskView;
}
- (UIView *) topLine{
    if (_topLine == nil){
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 1)];
        _topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    }
    return _topLine;
}
- (UIView *) bottomLine{
    if (_bottomLine == nil){
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.CLheight - 1, self.CLwidth, 1)];
        _bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
    }
    return _bottomLine;
}
- (UIView *) edgeLineView{
    if (_edgeLineView == nil){
        _edgeLineView = [[UIView alloc]init];
        _edgeLineView.CLwidth = self.CLwidth - 50 - 30;
        _edgeLineView.CLleft = 10;
        _edgeLineView.layer.cornerRadius = 5;
        _edgeLineView.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
        _edgeLineView.layer.borderWidth = 1;
        _edgeLineView.layer.masksToBounds = YES;
    }
    return _edgeLineView;
}
- (UITextView *) textView{
    if (_textView == nil){
        _textView = [[UITextView alloc] init];;
        _textView.CLwidth = self.CLwidth - 50 - 46;
        _textView.CLleft = 18;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.scrollsToTop = NO;
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.inputAccessoryView = self;
    }
    return _textView;
}
- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil){
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.CLwidth = self.textView.CLwidth - 10;
        _placeholderLabel.textColor = RGBACOLOR(0, 0, 0, 0.5);
        _placeholderLabel.CLleft = 23;
    }
    return _placeholderLabel;
}
- (UIButton *) sendButton{
    if (_sendButton == nil){
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - 50 - 10, self.CLheight - 30 - 10, 50, 30)];
        [_sendButton.layer setBorderWidth:1.0];
        [_sendButton.layer setCornerRadius:5.0];
        _sendButton.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
        _sendButton.enabled = NO;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(didClicksendButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UIWindow *) keyWindow{
    if (_keyWindow == nil){
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}















@end
