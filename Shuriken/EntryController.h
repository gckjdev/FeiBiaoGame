//
//  EntryController.h
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpView.h"
#import "SettingView.h"
#import "SKCommonGameCenterService.h"
@class GADBannerView;

@interface EntryController : UIViewController <SettingViewDelegate, HelpViewDelegate, SKCommonGameCenterServiceDelegate>
@property (retain, nonatomic) IBOutlet UIButton *bluetoothGameButton;
@property (retain, nonatomic) IBOutlet UIButton *gameCenterGameButton;
@property (retain, nonatomic) IBOutlet UIButton *recordButton;
@property (retain, nonatomic) IBOutlet UIButton *settingsButton;
@property (retain, nonatomic) IBOutlet UIButton *helpButton;
@property (retain, nonatomic) IBOutlet UIImageView *theBoy;
@property (retain, nonatomic) GADBannerView* bannerView;

@end
