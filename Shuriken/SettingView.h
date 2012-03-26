//
//  SettingView.h
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
@class FontLabel;

@protocol SettingViewDelegate <NSObject>
@optional
- (void)settingFinish;

@end

@interface SettingView : UIView <UITextFieldDelegate> {
    id<SettingViewDelegate> _delegate;
}
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UIButton *vibrationSwitcher;
@property (retain, nonatomic) IBOutlet UIButton *soundSwitcher;
@property (retain, nonatomic) IBOutlet UIButton *clickDoneButton;
@property (retain, nonatomic) IBOutlet UIButton *clickBackButton;
@property (assign, nonatomic) id<SettingViewDelegate> delegate;
+ (SettingView *)createSettingViewWithDelegate:(id<SettingViewDelegate>)aDelegate;
+ (SettingView *)createSettingView;
@end
