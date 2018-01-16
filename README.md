
#前言
一款聊天类型的APP，文字输入框是必不可少的，在此简单写了一个Demo供大家参考，希望能够抛砖引玉。
#思路
为了方便封装UI，将UITextView封装到一个UIView中。UIView内部需要监听键盘的弹出和消失，根据文字动态计算UITextView的高度，达到指定的最高高度后，UITextView高度不变化，文字自动上移。
####1.基本UI框架搭建
UI比较简单，就不细说了，具体代码如下。
```
-(void)initView {
self.backgroundColor = [UIColor whiteColor];
//顶部线条
self.topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.CLwidth, 1)];
self.topLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
[self addSubview:self.topLine];
//底部线条
self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.CLheight - 1, self.CLwidth, 1)];
self.bottomLine.backgroundColor = RGBACOLOR(0, 0, 0, 0.2);
[self addSubview:self.bottomLine];
//边框
self.edgeLineView = [[UIView alloc]init];
self.edgeLineView.CLwidth = self.CLwidth - 50 - 30;
self.edgeLineView.CLleft = 10;
self.edgeLineView.layer.cornerRadius = 5;
self.edgeLineView.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
self.edgeLineView.layer.borderWidth = 1;
self.edgeLineView.layer.masksToBounds = YES;
[self addSubview:self.edgeLineView];
//输入框
self.textView = [[UITextView alloc] init];;
self.textView.CLwidth = self.CLwidth - 50 - 46;
self.textView.CLleft = 18;
self.textView.enablesReturnKeyAutomatically = YES;
self.textView.delegate = self;
//关闭连续布局
self.textView.layoutManager.allowsNonContiguousLayout = NO;
self.textView.scrollsToTop = NO;
//去掉自带的间距
self.textView.textContainerInset = UIEdgeInsetsZero;
self.textView.textContainer.lineFragmentPadding = 0;
[self addSubview:self.textView];
//占位文字
self.placeholderLabel = [[UILabel alloc] init];
self.placeholderLabel.CLwidth = self.textView.CLwidth - 10;
self.placeholderLabel.textColor = RGBACOLOR(0, 0, 0, 0.5);
self.placeholderLabel.CLleft = 23;
[self addSubview:self.placeholderLabel];
//发送按钮
self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.CLwidth - 50 - 10, self.CLheight - 30 - 10, 50, 30)];
[self.sendButton.layer setBorderWidth:1.0];
[self.sendButton.layer setCornerRadius:5.0];
self.sendButton.layer.borderColor = RGBACOLOR(0, 0, 0, 0.5).CGColor;
self.sendButton.enabled = NO;
self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16];
[self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
[self.sendButton setTitleColor:RGBACOLOR(0, 0, 0, 0.2) forState:UIControlStateNormal];
[self.sendButton addTarget:self action:@selector(didClicksendButton) forControlEvents:UIControlEventTouchUpInside];
[self addSubview:self.sendButton];
self.fontSize = 20;
self.textViewMaxLine = 3;
}
```
####2.监听键盘弹出和收回
输入框需要跟随键盘的弹出和收回，监听键盘相对应的通知事件，根据键盘弹出时间等做出相应的处理。
```
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
```
####3.根据文字动态改变输入框高度
在UITextView代理中，通过文字计算需要的高度，判断是否达到最大高度，没有达到的情况就改变输入框的高度，超过最大高度，文字上移，高度不变。
```
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
self.CLheight = ceil(textView.CLheight) + 10 + 10;
self.CLbottom = CLscreenHeight - _keyboardHeight;
[textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
}
```
#接口
简单封装了一下，给出了一些接口，具体如下。
```
/**设置输入框最大行数*/
@property (nonatomic, assign) NSInteger textViewMaxLine;
/**输入框文字大小*/
@property (nonatomic, assign) CGFloat fontSize;
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;

/**收回键盘*/
-(void)bounceToolbar;
/**弹出键盘*/
- (void)popToolbar;
/**点击发送后的文字*/
- (void)inputToolbarSendText:(inputTextBlock)sendText;
```
#效果图
![](http://upload-images.jianshu.io/upload_images/1979970-a3953705a36dd81e.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![1.gif](http://upload-images.jianshu.io/upload_images/1979970-a2b5817e5e576874.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#其他
####1.修改光标宽高
自定义一个继承自UITextView的控件，内部重写下面方法即可。
```
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
CGRect originalRect = [super caretRectForPosition:position];

originalRect.size.width = 2;
originalRect.size.height = self.font.lineHeight;

return originalRect;
}
```
####2.修改光标颜色
```
[self.textView setTintColor:[UIColor redColor]];
```
####3.修改行间距
```
NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
paragraphStyle.lineSpacing = 20;// 字体的行间距
NSDictionary *attributes = @{
NSFontAttributeName:[UIFont systemFontOfSize:17],
NSParagraphStyleAttributeName:paragraphStyle
};
self.textView.typingAttributes = attributes;
```
#总结
代码比较简单，完整项目地址------>[CLInputToolbar](https://github.com/JmoVxia/CLInputToolbar)





