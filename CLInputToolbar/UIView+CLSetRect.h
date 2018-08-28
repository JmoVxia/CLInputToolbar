//
//  UIView+SetRect.h
//  UIView
//
//  Created by JmoVxia on 2016/10/27.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 * 随机色
 */
#define cl_RandomColor [UIColor colorWithRed:arc4random_uniform(256.0)/255.0 green:arc4random_uniform(256.0)/255.0 blue:arc4random_uniform(256.0)/255.0 alpha:1.0]
/**
 *  UIScreen width.
 */
#define  cl_screenWidth   [UIScreen mainScreen].bounds.size.width

/**
 *  UIScreen height.
 */
#define  cl_screenHeight  [UIScreen mainScreen].bounds.size.height

/**iPhone5为标准，乘以宽的比例*/
#define cl_scaleX(value) (((value) * 0.5f)/cl_screenWidth * cl_screenWidth)

/**iPhone5为标准，乘以高的比例*/
#define cl_scaleY(value) (((value) * 0.5f)/cl_screenHeight * cl_screenHeight)
/**直接使用像素*/
#define cl_px(value) ((value) * 0.5f)


/**
 *  Status bar height.
 */
#define  cl_statusBarHeight      [[UIApplication sharedApplication] statusBarFrame].size.height

/**
 *  Navigation bar height.
 */
#define  cl_navigationBarHeight  44.f

/**
 *  Status bar & navigation bar height.
 */
#define  cl_statusBarAndNavigationBarHeight   (cl_statusBarHeight + 44.f)

/**
 tabbar高度
 */
#define  cl_tabbarHeight         (cl_iPhoneX ? (49.f + 34.f) : 49.f)
/**
 底部安全间距
 */
#define  cl_safeBottomMargin  (cl_iPhoneX ? 34.f : 0.f)


/**
 *  iPhone4 or iPhone4s
 */
#define  cl_iPhone4_4s     (cl_screenWidth == 320.f && cl_screenHeight == 480.f ? YES : NO)

/**
 *  iPhone5 or iPhone5s
 */
#define  cl_iPhone5_5s     (cl_screenWidth == 320.f && cl_screenHeight == 568.f ? YES : NO)

/**
 *  iPhone6 or iPhone6s
 */
#define  cl_iPhone6_6s     (cl_screenWidth == 375.f && cl_screenHeight == 667.f ? YES : NO)

/**
 *  iPhone6Plus or iPhone6sPlus
 */
#define  cl_iPhone6_6sPlus (cl_screenWidth == 414.f && cl_screenHeight == 736.f ? YES : NO)

/**
 *  iPhoneX
 */
#define  cl_iPhoneX (cl_screenWidth == 375.f && cl_screenHeight == 812.f ? YES : NO)





@interface UIView (cl_SetRect)



/**
 控件起点
 */
@property (nonatomic) CGPoint cl_origin;

/**
 控件起点x
 */
@property (nonatomic) CGFloat cl_x;

/**
 控件起点Y
 */
@property (nonatomic) CGFloat cl_y;

/**
 控件宽
 */
@property (nonatomic) CGFloat cl_width;

/**
 控件高
 */
@property (nonatomic) CGFloat cl_height;

/**
 控件顶部
 */
@property (nonatomic) CGFloat cl_top;

/**
 控件底部
 */
@property (nonatomic) CGFloat cl_bottom;

/**
 控件左边
 */
@property (nonatomic) CGFloat cl_left;

/**
 控件右边
 */
@property (nonatomic) CGFloat cl_right;

/**
 控件中心点X
 */
@property (nonatomic) CGFloat cl_centerX;

/**
 控件中心点Y
 */
@property (nonatomic) CGFloat cl_centerY;

/**
 控件左下
 */
@property(readonly) CGPoint cl_bottomLeft ;

/**
 控件右下
 */
@property(readonly) CGPoint cl_bottomRight ;

/**
 控件左上
 */
@property(readonly) CGPoint cl_topLeft ;
/**
 控件右上
 */
@property(readonly) CGPoint cl_topRight ;


/**
 屏幕中心点X
 */
@property (nonatomic, readonly) CGFloat cl_middleX;

/**
 屏幕中心点Y
 */
@property (nonatomic, readonly) CGFloat cl_middleY;

/**
 屏幕中心点
 */
@property (nonatomic, readonly) CGPoint cl_middlePoint;

/**
 控件size
 */
@property (nonatomic) CGSize cl_size;



/**
 设置上边圆角
 */
- (void)cl_setCornerOnTop:(CGFloat) conner;

/**
 设置下边圆角
 */
- (void)cl_setCornerOnBottom:(CGFloat) conner;
/**
 设置左边圆角
 */
- (void)cl_setCornerOnLeft:(CGFloat) conner;
/**
 设置右边圆角
 */
- (void)cl_setCornerOnRight:(CGFloat) conner;

/**
 设置左上圆角
 */
- (void)cl_setCornerOnTopLeft:(CGFloat) conner;

/**
 设置右上圆角
 */
- (void)cl_setCornerOnTopRight:(CGFloat) conner;
/**
 设置左下圆角
 */
- (void)cl_setCornerOnBottomLeft:(CGFloat) conner;
/**
 设置右下圆角
 */
- (void)cl_setCornerOnBottomRight:(CGFloat) conner;


/**
 设置所有圆角
 */
- (void)cl_setAllCorner:(CGFloat) conner;


@end

