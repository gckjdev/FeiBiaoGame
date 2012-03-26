//
//  CustomLabelUtil.m
//  Shuriken
//
//  Created by Orange on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomLabelUtil.h"

@implementation CustomLabelUtil

+ (FontLabel*)creatWithFrame:(CGRect)frame pointSize:(CGFloat)pointSize alignment:(UITextAlignment)alignment textColor:(UIColor*)aColor addTo:(UIView*)aView text:(NSString*)aText shadow:(BOOL)hasShadow bold:(BOOL)isBold;
{
    FontLabel* label = [[[FontLabel alloc] initWithFrame:frame fontName:@"fzkatjw" pointSize:pointSize] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:aColor];
    [label setTextAlignment:alignment];
    [label setText:aText];
    if (isBold) {
        FontLabel* label2 = [[[FontLabel alloc] initWithFrame:CGRectMake(frame.origin.x+1, frame.origin.y+1, frame.size.width, frame.size.height) fontName:@"fzkatjw" pointSize:pointSize] autorelease];
        [label2 setTextColor:aColor];
        [label2 setAlpha:1];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextAlignment:alignment];
        [label2 setText:aText];
        [aView addSubview:label2];
    }
    if (hasShadow) {
        FontLabel* label2 = [[[FontLabel alloc] initWithFrame:CGRectMake(frame.origin.x+3, frame.origin.y+3, frame.size.width, frame.size.height) fontName:@"fzkatjw" pointSize:pointSize] autorelease];
        [label2 setTextColor:aColor];
        [label2 setAlpha:0.3];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextAlignment:alignment];
        [label2 setText:aText];
        [aView addSubview:label2];
    }    
    [aView addSubview:label];
    return label;
}

+ (FontLabel*)creatWithFrame:(CGRect)frame pointSize:(CGFloat)pointSize alignment:(UITextAlignment)alignment textColor:(UIColor*)aColor addTo:(UIView*)aView text:(NSString*)aText bold:(BOOL)isBold
{
    FontLabel* label = [[[FontLabel alloc] initWithFrame:frame fontName:@"fzkatjw" pointSize:pointSize] autorelease];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:aColor];
    [label setTextAlignment:alignment];
    [label setText:aText];
    if (isBold) {
        FontLabel* label2 = [[[FontLabel alloc] initWithFrame:CGRectMake(frame.origin.x+1, frame.origin.y+1, frame.size.width, frame.size.height) fontName:@"fzkatjw" pointSize:pointSize] autorelease];
        [label2 setTextColor:aColor];
        [label2 setAlpha:1];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label2 setTextAlignment:alignment];
        [label2 setText:aText];
        [aView addSubview:label2];
    }
    [aView addSubview:label];
    return label;
}

@end
