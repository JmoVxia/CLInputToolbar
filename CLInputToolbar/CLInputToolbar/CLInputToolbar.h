//
//  CLInputToolbar.h
//  CLInputToolbar
//
//  Created by JmoVxia on 2017/8/16.
//  Copyright © 2017年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLInputToolbar;

@protocol CLInputToolbarDelegate <NSObject>
@optional
- (void)inputToolbarSendString:(NSString *)string;
@end

@interface CLInputToolbar : UIButton

/**文本输入框*/
@property (nonatomic, strong) UITextView *textInput;
/**设置输入框最大行数*/
@property (nonatomic, assign) NSInteger textViewMaxLine;
/**代理*/
@property (nonatomic, weak) id<CLInputToolbarDelegate> delegate;
/**键盘是否隐藏回调*/
@property (nonatomic, copy) void (^keyIsVisiableBlock)(BOOL keyboardIsVisiable);
/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;

/**收回键盘*/
-(void)bounceToolbar;
/**弹出键盘*/
- (void)popToolbar;


@end
