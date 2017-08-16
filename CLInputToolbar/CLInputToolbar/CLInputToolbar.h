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
- (void)inputToolbar:(CLInputToolbar *)inputToolbar sendContent:(NSString *)sendContent;
@end

@interface CLInputToolbar : UIView
/**
 *  初始化chat bar
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  文本输入框
 */
@property (nonatomic,strong)UITextView *textInput;
/**
 *  设置输入框最大行数
 */
@property (nonatomic,assign)NSInteger textViewMaxLine;
/**
 *  textView占位符
 */
@property (nonatomic,strong)UILabel *placeholderLabel;

@property (nonatomic,weak) id<CLInputToolbarDelegate>delegate;

@property (nonatomic, copy) void (^keyIsVisiableBlock)(BOOL keyboardIsVisiable);

// 发送成功
-(void)sendSuccessEndEditing;

@end
