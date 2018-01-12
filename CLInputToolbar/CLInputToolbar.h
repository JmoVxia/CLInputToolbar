//
//  CLInputToolbar.h
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputTextBlock)(NSString *text);

@interface CLInputToolbar : UIView

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
@end
