//
//  UIView+Border.h
//  netCafe
//
//  Created by Valo on 15/4/23.
//  Copyright (c) 2015年 sicent. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - UI相关
#define kWXDefaultCornerRadius  3
#define kWXDefaultBorderColoer  [UIColor colorWithWhite:0.784 alpha:1.000]
#define kWXDefaultBorderWidth   (1.f / [UIScreen mainScreen].scale)

@interface UIView (Border)

/**
 *  UIView添加默认圆角和边框
 *
 *  @param withBorder 是否添加边框
 */
- (void)defaultRoundCornerWithBorder:(BOOL)withBorder;

/**
 *  UIView添加圆角和边框
 *
 *  @param cornerRaius 圆角半径
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
- (void)roundCornerRadius:(CGFloat)cornerRaius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  UIView添加圆角
 *
 *  @param cornerRaius 圆角半径
 */
- (void)roundCornerRadius:(CGFloat)cornerRaius;

/**
 *  为一组View添加默认圆角和边框
 *
 *  @param views      要添加圆角的Views
 *  @param withBorder 是否添加边框
 */
+ (void)defaultRoundCornerForViews: (NSArray *)views WithBorder:(BOOL)withBorder;

/**
 *  为一组View添加圆角和边框
 *
 *  @param views       要添加圆角的Views
 *  @param cornerRaius 圆角半径
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (void)roundViews:(NSArray *)views cornerRadius:(CGFloat)cornerRaius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  为一组View添加圆角
 *
 *  @param views       要添加圆角的Views
 *  @param cornerRaius 圆角半径
 */
+ (void)roundViews:(NSArray *)views cornerRadius:(CGFloat)cornerRaius ;


@end
