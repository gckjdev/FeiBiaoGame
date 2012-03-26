//
//  SettingController.m
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingController.h"
#import "SettingsManager.h"

@implementation SettingController
@synthesize nameLabel;
@synthesize vibrationSwitch;
@synthesize soundSwitch;
@synthesize name;
@synthesize vibrationButton;
@synthesize soundButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    SettingsManager* manager = [SettingsManager shareInstance];
    [self.name setPlaceholder:manager.playerName];
    self.name.delegate = self;
    [self.vibrationButton setSelected:manager.isVibration];
    [self.soundButton setSelected:manager.isSoundOn];
    [self.vibrationSwitch setText:NSLocalizedString(@"vibration", @"振动")];
    [self.soundSwitch setText:NSLocalizedString(@"sound", @"音效")];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setVibrationSwitch:nil];
    [self setSoundSwitch:nil];
    [self setName:nil];
    [self setVibrationButton:nil];
    [self setSoundButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backToEntry:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [nameLabel release];
    [vibrationSwitch release];
    [soundSwitch release];
    [name release];
    [vibrationButton release];
    [soundButton release];
    [super dealloc];
}

- (IBAction)clickButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    [button setSelected:(!button.isSelected)];
}

- (IBAction)settingDone:(id)sender
{
    SettingsManager* manager = [SettingsManager shareInstance];
    [manager setIsVibration:self.vibrationButton.isSelected];
    [manager setIsSoundOn:self.soundButton.isSelected];
    NSString* aName = self.name.text;
    if (aName && aName.length > 0) {
        [manager setPlayerName:aName];
    }
    [manager saveSettings];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
