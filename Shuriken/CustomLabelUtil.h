//
//  CustomLabelUtil.h
//  Shuriken
//
//  Created by Orange on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FontLabel.h"

@class FontLabel;

@interface CustomLabelUtil : NSObject

+ (FontLabel*)creatWithFrame:(CGRect)frame pointSize:(CGFloat)pointSize alignment:(UITextAlignment)alignment textColor:(UIColor*)aColor addTo:(UIView*)aView text:(NSString*)aText shadow:(BOOL)hasShadow bold:(BOOL)isBold;
+ (FontLabel*)creatWithFrame:(CGRect)frame pointSize:(CGFloat)pointSize alignment:(UITextAlignment)alignment textColor:(UIColor*)aColor addTo:(UIView*)aView text:(NSString*)aText bold:(BOOL)isBold;
@end
