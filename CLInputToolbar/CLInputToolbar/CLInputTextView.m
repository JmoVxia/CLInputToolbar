//
//  CLInputTextView.m
//  CLInputToolbar
//
//  Created by JmoVxia on 2018/1/10.
//  Copyright © 2018年 JmoVxia. All rights reserved.
//

#import "CLInputTextView.h"

@implementation CLInputTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.size.width = 2;
    originalRect.size.height = self.font.lineHeight;

    return originalRect;
}

@end
