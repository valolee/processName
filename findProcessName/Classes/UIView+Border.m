//
//  UIView+Border.m
//  netCafe
//
//  Created by Valo on 15/4/23.
//  Copyright (c) 2015年 sicent. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)defaultRoundCornerWithBorder:(BOOL)withBorder{
    if (withBorder) {
        [self roundCornerRadius:kWXDefaultCornerRadius borderWidth:kWXDefaultBorderWidth borderColor:kWXDefaultBorderColoer];
    }
    else{
        [self roundCornerRadius:kWXDefaultCornerRadius];
    }
}

- (void)roundCornerRadius:(CGFloat)cornerRaius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRaius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)roundCornerRadius:(CGFloat)cornerRaius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRaius;
}

+ (void)defaultRoundCornerForViews: (NSArray *)views WithBorder:(BOOL)withBorder{
    if (withBorder) {
        [UIView roundViews:views cornerRadius:kWXDefaultCornerRadius borderWidth:kWXDefaultBorderWidth borderColor:kWXDefaultBorderColoer];
    }
    else{
        [UIView roundViews:views cornerRadius:kWXDefaultCornerRadius];
    }
}

+ (void)roundViews:(NSArray *)views cornerRadius:(CGFloat)cornerRaius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    for (UIView *view in views) {
        [view roundCornerRadius:cornerRaius borderWidth:borderWidth borderColor:borderColor];
    }
}

+ (void)roundViews:(NSArray *)views cornerRadius:(CGFloat)cornerRaius {
    for (UIView *view in views) {
        [view roundCornerRadius:cornerRaius];
    }
}

@end
