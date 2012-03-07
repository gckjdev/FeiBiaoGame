//
//  EntryController.m
//  Shuriken
//
//  Created by Orange on 12-2-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntryController.h"
#import "SKCommonMultiPlayerService.h"
#import "GameController.h"
#import "HelpController.h"
#import "SettingController.h"
#import "RecordController.h"

@implementation EntryController
@synthesize bluetoothGameButton;
@synthesize gameCenterGameButton;
@synthesize recordButton;
@synthesize settingsButton;
@synthesize helpButton;

- (void)dealloc
{
    [bluetoothGameButton release];
    [gameCenterGameButton release];
    [recordButton release];
    [settingsButton release];
    [helpButton release];
    [super dealloc];
}

- (void)initTitles
{
    [self.bluetoothGameButton setTitle:NSLocalizedString(@"Bluetooth Game", @"蓝牙游戏") forState:UIControlStateNormal];
    [self.gameCenterGameButton setTitle:NSLocalizedString(@"Game Center", @"GAMECENTER") forState:UIControlStateNormal];
    [self.recordButton setTitle:NSLocalizedString(@"Records", @"个人战绩") forState:UIControlStateNormal];
    [self.settingsButton setTitle:NSLocalizedString(@"Settings", @"设置") forState:UIControlStateNormal];
    [self.helpButton setTitle:NSLocalizedString(@"Help", @"帮助") forState:UIControlStateNormal];
}

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
    [self initTitles];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBluetoothGameButton:nil];
    [self setGameCenterGameButton:nil];
    [self setRecordButton:nil];
    [self setSettingsButton:nil];
    [self setHelpButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)findDevice:(id)sender
{
    SKCommonMultiPlayerService* servcie = [[SKCommonMultiPlayerService alloc] initWithMultiPlayerGameType:BLUETOOTH_GAME];
    GameController* vc = [[GameController alloc] initWithMultiPlayerService:servcie];
    [self.navigationController pushViewController:vc animated:YES];
    [servcie release];
    [vc release];
}

- (IBAction)gameCenterGame:(id)sender
{
    SKCommonMultiPlayerService* servcie = [[SKCommonMultiPlayerService alloc] initWithMultiPlayerGameType:GAME_CENTER_GAME];
    GameController* vc = [[GameController alloc] initWithMultiPlayerService:servcie];
    [self.navigationController pushViewController:vc animated:YES];
    [servcie release];
    [vc release];

}

- (IBAction)testGame:(id)sender
{
    GameController* sc =  [[GameController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
    [sc release];
}

- (IBAction)records:(id)sender 
{
    RecordController* sc =  [[RecordController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
    [sc release];
}

- (IBAction)help:(id)sender 
{
    HelpController* sc =  [[HelpController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
    [sc release];
}

- (IBAction)settings:(id)sender 
{
    SettingController* sc =  [[SettingController alloc] init];
    [self.navigationController pushViewController:sc animated:YES];
    [sc release];
}

@end
