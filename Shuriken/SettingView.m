//
//  SettingView.m
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"
#import "AnimationManager.h"
#import "SettingsManager.h"
#import "CustomLabelUtil.h"


@implementation SettingView
@synthesize nameField = _nameField;
@synthesize vibrationSwitcher= _vibrationSwitcher;
@synthesize soundSwitcher = _soundSwitcher;
@synthesize clickDoneButton = _clickDoneButton;
@synthesize clickBackButton = _clickBackButton;
@synthesize delegate = _delegate;

- (void)dealloc {
    [_nameField release];
    [_vibrationSwitcher release];
    [_soundSwitcher release];
    [_clickBackButton release];
    [_clickDoneButton release];
    [super dealloc];
}

- (void)refleshSwitchs
{
    SettingsManager* manager = [SettingsManager shareInstance];
    [self.vibrationSwitcher setSelected:manager.isVibration];
    [self.soundSwitcher setSelected:manager.isSoundOn];
}

- (void)settingInit
{
    SettingsManager* manager = [SettingsManager shareInstance];
    [manager loadSettings];
    [self.nameField setText:manager.playerName];
    [self refleshSwitchs];
    
}

- (void)labelInit
{    
    [CustomLabelUtil creatWithFrame:CGRectMake(108, 36, 104, 41) pointSize:23 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"SETTING", @"设置") shadow:YES bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(52, 136, 72, 33) pointSize:15 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"Name:", @"昵称") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(52, 198, 72, 33) pointSize:15 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"Sound", @"音效") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(52, 268, 80, 33) pointSize:15 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"Vibration", @"振动") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.clickBackButton text:NSLocalizedString(@"Back", @"返回") shadow:NO bold:NO];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.clickDoneButton text:NSLocalizedString(@"Confirm", @"确认") shadow:NO bold:NO];
    
}

+ (SettingView *)createSettingView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <SettingView> but cannot find cell object from Nib");
        return nil;
    }
    SettingView* view =  (SettingView*)[topLevelObjects objectAtIndex:0];
    [view settingInit];
    [view labelInit];
    CAAnimation *putUp = [AnimationManager translationAnimationFrom:CGPointMake(160, 720) to:CGPointMake(160, 240) duration:0.3 delegate:self removeCompeleted:NO];
    [view.layer addAnimation:putUp forKey:@"putUp"];
    return view;
    
}

+ (SettingView *)createSettingViewWithDelegate:(id<SettingViewDelegate>)aDelegate
{
    SettingView* view = [SettingView createSettingView];
    view.delegate = aDelegate;
    return view;
    
}

- (void)updateSwitch:(id)sender forState:(BOOL)state
{
    UIButton* button = (UIButton*)sender;
    if (state) {
        [button setSelected:YES];
    } else {
        [button setSelected:NO];
    }
}

- (IBAction)switchSoundOn:(id)sender
{
    SettingsManager* manager = [SettingsManager shareInstance];
    manager.isSoundOn = !manager.isSoundOn;
    [self updateSwitch:sender forState:manager.isSoundOn];
    
}

- (IBAction)switchVibration:(id)sender
{
    SettingsManager* manager = [SettingsManager shareInstance];
    manager.isVibration = !manager.isVibration;
    [self updateSwitch:sender forState:manager.isVibration];
}

- (IBAction)clickBack:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(settingFinish)]) {
        [_delegate settingFinish];
    }
    CAAnimation *putDown = [AnimationManager translationAnimationFrom:CGPointMake(160, 240) to:CGPointMake(160, 720) duration:0.1 delegate:self removeCompeleted:NO];
    [putDown setValue:@"minify" forKey:@"AnimationKey"];
    [putDown setDelegate:self];
    [self.layer addAnimation:putDown forKey:@"minify"];
}

- (IBAction)setDone:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(settingFinish)]) {
        [_delegate settingFinish];
    }
    NSString* aName = self.nameField.text;
    if (aName && aName.length > 0) {
        [[SettingsManager shareInstance] setPlayerName:aName];
    }
    [[SettingsManager shareInstance] saveSettings];
    CAAnimation *putDown = [AnimationManager translationAnimationFrom:CGPointMake(160, 240) to:CGPointMake(160, 720) duration:0.1 delegate:self removeCompeleted:NO];
    [putDown setValue:@"minify" forKey:@"AnimationKey"];
    [putDown setDelegate:self];
    [self.layer addAnimation:putDown forKey:@"minify"];
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag 
{
    NSString* value = [anim valueForKey:@"AnimationKey"];
    if ([value isEqualToString:@"minify"]) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
