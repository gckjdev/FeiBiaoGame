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
#import "RecordController.h"
#import "AnimationManager.h"
#import "CustomLabelUtil.h"
#import "SKCommonAudioManager.h"
#import "SettingsManager.h"
#import "HelpController.h"
#import "GADBannerView.h"


#define ENTRY_ANIM @"entryAnimations"
#define BOY_COME_OUT @"boy_come_out"

@implementation EntryController
@synthesize bluetoothGameButton;
@synthesize gameCenterGameButton;
@synthesize recordButton;
@synthesize settingsButton;
@synthesize helpButton;
@synthesize theBoy;
@synthesize bannerView = _bannerView;

- (void)dealloc
{
    [bluetoothGameButton release];
    [gameCenterGameButton release];
    [recordButton release];
    [settingsButton release];
    [helpButton release];
    [theBoy release];
    [_bannerView release];
    [super dealloc];
}

- (void)buttonsAppear
{
    if ([SettingsManager shareInstance].isSoundOn) {
        [[SKCommonAudioManager defaultManager] playSoundById:ATTACK_SOUND_INDEX];
    }
    [self.bluetoothGameButton setHidden:NO];
    [self.gameCenterGameButton setHidden:NO];
    [self.recordButton setHidden:NO];
}

- (void)theBoyGetThreeAttack
{
    if ([SettingsManager shareInstance].isSoundOn) {
        [[SKCommonAudioManager defaultManager] playSoundById:DEFFEND_SOUND_INDEX];
    }
    [self.theBoy setImage:[UIImage imageNamed:@"default4"]];
    CAAnimation* shakeTheBoy = [AnimationManager view:self.theBoy shakeFor:5 times:15 duration:0.3];
    [self.theBoy.layer addAnimation:shakeTheBoy forKey:@"shakeTheBoy"];
    [self performSelector:@selector(buttonsAppear) withObject:nil afterDelay:0.8];
}

- (void)theBoyGetTwoAttack
{
    if ([SettingsManager shareInstance].isSoundOn) {
        [[SKCommonAudioManager defaultManager] playSoundById:DEFFEND_SOUND_INDEX];
    }
    [self.theBoy setImage:[UIImage imageNamed:@"default3"]];
    CAAnimation* shakeTheBoy = [AnimationManager view:self.theBoy shakeFor:5 times:15 duration:0.3];
    [self.theBoy.layer addAnimation:shakeTheBoy forKey:@"shakeTheBoy"];
    [self performSelector:@selector(theBoyGetThreeAttack) withObject:nil afterDelay:0.8];
}

- (void)theBoyGetAnAttack
{
    if ([SettingsManager shareInstance].isSoundOn) {
        [[SKCommonAudioManager defaultManager] playSoundById:DEFFEND_SOUND_INDEX];
    }
    [self.theBoy setImage:[UIImage imageNamed:@"default2"]];
    CAAnimation* shakeTheBoy = [AnimationManager view:self.theBoy shakeFor:5 times:15 duration:0.3];
    [self.theBoy.layer addAnimation:shakeTheBoy forKey:@"shakeTheBoy"];
    [self performSelector:@selector(theBoyGetTwoAttack) withObject:nil afterDelay:0.8];
}

- (void)theBoyAppear
{
    CAAnimation* boyComeOut = [AnimationManager translationAnimationFrom:CGPointMake(-98, 253) to:CGPointMake(98, 253) duration:0.3 delegate:self removeCompeleted:NO];
    [boyComeOut setValue:BOY_COME_OUT forKey:ENTRY_ANIM];
    [self.theBoy.layer addAnimation:boyComeOut forKey:@"boy_appear"];
}


- (void)initTitles
{
    UIColor* titleColor = [UIColor colorWithRed:0x83/255.0 green:0x14/255.0 blue:0x00/255.0 alpha:1.0];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, self.bluetoothGameButton.frame.size.width, self.bluetoothGameButton.frame.size.height) pointSize:20 alignment:UITextAlignmentCenter textColor:titleColor addTo:self.bluetoothGameButton text:NSLocalizedString(@"Bluetooth", @"蓝牙游戏") shadow:YES bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, self.gameCenterGameButton.frame.size.width, self.gameCenterGameButton.frame.size.height) pointSize:20 alignment:UITextAlignmentCenter textColor:titleColor addTo:self.gameCenterGameButton text:NSLocalizedString(@"Game Center", @"游戏中心") shadow:YES bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, self.recordButton.frame.size.width, self.recordButton.frame.size.height) pointSize:20 alignment:UITextAlignmentCenter textColor:titleColor addTo:self.recordButton text:NSLocalizedString(@"Record", @"战绩") shadow:YES bold:YES];
//    [self.settingsButton setTitle:NSLocalizedString(@"Settings", @"设置") forState:UIControlStateNormal];
//    [self.helpButton setTitle:NSLocalizedString(@"Help", @"帮助") forState:UIControlStateNormal];
    
    [CustomLabelUtil creatWithFrame:CGRectMake(44, 0, 115, 44) pointSize:20 alignment:UITextAlignmentLeft textColor:[UIColor whiteColor] addTo:self.helpButton text:NSLocalizedString(@"HELP", @"帮助") bold:NO];

    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 115, 44) pointSize:20 alignment:UITextAlignmentRight textColor:[UIColor whiteColor]addTo:self.settingsButton text:NSLocalizedString(@"SETTING", @"设置") bold:NO];

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
#pragma mark - game center delegate
- (void)inviteReceived
{
    SKCommonMultiPlayerService* servcie = [[SKCommonMultiPlayerService alloc] initWithMultiPlayerGameType:GAME_CENTER_GAME];
    GameController* vc = [[GameController alloc] initWithMultiPlayerService:servcie];
    [self.navigationController pushViewController:vc animated:YES];
    [servcie release];
    [vc release];
}
#define PUBLISHER_ID @"a14fbb61a340a25"
#pragma mark - View lifecycle

- (GADBannerView*)allocAdMobView:(UIViewController*)superViewController
{
    // Create a view of the standard size at the bottom of the screen.
    GADBannerView* view = [[[GADBannerView alloc]
                                  initWithFrame:CGRectMake(0.0,
                                                           0,
                                                           GAD_SIZE_320x50.width,
                                                           GAD_SIZE_320x50.height)] autorelease];
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    view.adUnitID = PUBLISHER_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    view.rootViewController = superViewController;
    [superViewController.view addSubview:view];
    [superViewController.view bringSubviewToFront:view];
    // Initiate a generic request to load it with an ad.
    [view loadRequest:[GADRequest request]];   
    
    return view;
}


- (void)viewDidAppear:(BOOL)animated
{
    if (self.bannerView == nil){
        self.bannerView = [self allocAdMobView:self];  
    }
    
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [SKCommonGameCenterService sharedInstance].delegate = self;
    [[SKCommonAudioManager defaultManager] initSounds:[NSArray arrayWithObjects:@"get_hurt.wav", @"hit_shield.wav", @"shuriken_sound.wav" ,nil ]];
    [self initTitles];
    [self theBoyAppear];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setBluetoothGameButton:nil];
    [self setGameCenterGameButton:nil];
    [self setRecordButton:nil];
    [self setSettingsButton:nil];
    [self setHelpButton:nil];
    [self setTheBoy:nil];
    [self setBannerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - animation delegate
- (void)animationDidStart:(CAAnimation *)anim
{
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString* value = [anim valueForKey:ENTRY_ANIM];
    if ([value isEqualToString:BOY_COME_OUT]) {
        [self performSelector:@selector(theBoyGetAnAttack) withObject:nil afterDelay:0.3];
    }
}

#define MASK_TAG 20120319
#pragma mark - setting view delegate
- (void)settingFinish
{
    UIView* view = [self.view viewWithTag:MASK_TAG];
    [view removeFromSuperview];
}

#pragma mark - help view delegate
- (void)clickOkButton
{
    UIView* view = [self.view viewWithTag:MASK_TAG];
    [view removeFromSuperview];
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

- (IBAction)records:(id)sender 
{
    RecordController* sc =  [[RecordController alloc] init];
    [self presentModalViewController:sc animated:YES];
    [sc release];
}

- (IBAction)help:(id)sender 
{
    UIView* view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = MASK_TAG;
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    HelpView* helpView = [HelpView createHelpViewWithDelegate:self];
    [self.view addSubview:view];
    [self.view addSubview:helpView];
    
}

- (IBAction)settings:(id)sender 
{
    UIView* view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = MASK_TAG;
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    SettingView* settingView = [SettingView createSettingViewWithDelegate:self];
    [self.view addSubview:view];
    [self.view addSubview:settingView];
}

@end
