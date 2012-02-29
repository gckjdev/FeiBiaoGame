//
//  SettingController.h
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController <UITextFieldDelegate> {
    
}
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *vibrationSwitch;
@property (retain, nonatomic) IBOutlet UILabel *soundSwitch;
@property (retain, nonatomic) IBOutlet UITextField *name;
@property (retain, nonatomic) IBOutlet UIButton *vibrationButton;
@property (retain, nonatomic) IBOutlet UIButton *soundButton;

@end
