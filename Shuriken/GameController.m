//
//  GameController.m
//  Shuriken
//
//  Created by Orange on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "AnimationManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RecordManager.h"

typedef enum{
    IllegalGestureRecognizer = -1,
    LongPressGestureRecognizer = 0,
    PanGestureRecognizer,
    PinchGestureRecognizer,
    RotationGestureRecognizer,
    SwipeGestureRecognizer,
    TapGestureRecognizer,
    GestureRecognizerTypeCount
}GestureRecognizerType;

#define ATTACK  20120206
#define I_LOSE  120120206
#define AUCH    220120206

typedef enum{
    ready = 0,
    onGo,
    end
}GameStatus;

@implementation GameController
@synthesize weaponsCount = _weaponsCount;
@synthesize shieldsCount = _shieldsCount;
@synthesize weapon = _weapon;
@synthesize shield = _shield;
@synthesize bloodBar = _bloodBar;
@synthesize bloodsCount = _bloodsCount;
@synthesize multiPlayerService = _multiPlayerService;


- (void)dealloc
{

    [_weaponsCount release];
    [_shieldsCount release];
    [_weapon release];
    [_shield release];
    [_bloodBar release];
    [_bloodsCount release];
    [_multiPlayerService release];
    [super dealloc];
}

- (void)holdUpShield
{
    [self.shield setCenter:self.weapon.center];
}

- (void)shieldBroke
{
    [self.shield setImage:[UIImage imageNamed:@"brokehShield.png"]];
}

- (void)shieldShake
{
    [self.shield.layer addAnimation:[AnimationManager shakeFor:10 originX:self.shield.center.x times:10 duration:0.2] forKey:@"SHAKING"];
}

- (void)toDefend
{
    if (_isAttacking) {
        _isAttacking = NO;
    }
    [self holdUpShield];
    [self.shield setHidden:NO];
    [self.weapon setHidden:YES];
}

- (void)toAttack
{
    if (!_isAttacking) {
        _isAttacking = YES;
    }
    [self.shield setHidden:YES];
    [self.weapon setHidden:NO];
}

- (void)defendAnAttack
{
    [self shieldShake];
    NSLog(@"i defend!");
    _shields = _shields -1;
    _darts ++;
    if (_shields < 0) {
        [self shieldBroke];
    }
}

- (void)getHurt
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    NSLog(@"Ouch!");
    _blood--;
    [self.bloodBar setFrame:CGRectMake(60, 362, 24*_blood, 19)];
}

- (void)throwWeapon
{
    
    [self.weapon.layer addAnimation:[AnimationManager translationAnimationFrom:self.weapon.center to:CGPointMake(160, -240) duration:0.3] forKey:@"throwing"];
    [self.weapon.layer addAnimation:[AnimationManager rotationAnimationWithRoundCount:10 duration:0.3] forKey:@"rotation"];
    if (_isAttacking && _darts >= 1) {
        NSNumber* number = [NSNumber numberWithInt:ATTACK];
        NSData* attack = [NSKeyedArchiver archivedDataWithRootObject:number];
        [self.multiPlayerService sendDataToAllPlayers:attack];
        _darts -- ;
        NSLog(@"attack you !!!!");
    }
}

- (void)refleshStatus
{
    if (!_isAttacking && _shields >0) {
        _shields = _shields-0.1;
    }
    if (_darts < 1) {
        [self.weapon setHidden:YES];
    }
    
    if (_shields <= 0) {
        [self.shield setImage:[UIImage imageNamed:@"brokenShield.png"]];
    } 
    [self.weaponsCount setText:[NSString stringWithFormat:@"%d", _darts]];
    [self.shieldsCount setText:[NSString stringWithFormat:@"%f", _shields]];
    [self.bloodsCount setText:[NSString stringWithFormat:@"%d", _blood]];
    
    _counter++;
    if (_counter%30 == 0 && _darts < 30) {
        _darts ++;
    }
    if ((_counter%50 == 0 && _shields < 30)) {
        _shields = _shields +1;
    }
}

- (void)restartGame
{
    _isAttacking = YES;
    _counter = 0;
    _darts = 30;
    _shields = 30;
    _blood = 10;
    _gameStatus = onGo;
    
    [_statusChecker invalidate];
    _statusChecker = nil;
    _statusChecker = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refleshStatus) userInfo:nil repeats:YES];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 0.05;
}

- (void)gameEnd:(BOOL)didWin
{
    UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重来", nil];
    if (didWin) {
        [view setTitle:@"you win"];
    } else {
        [view setTitle:@"you lose"];
    }
    [view show];
    _gameStatus = end;
}

- (void)quitGame
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [self.multiPlayerService quitMultiPlayersGame];
}

- (void)findMultiPlayers
{
    if (_multiPlayerService == nil) {
        _multiPlayerService = [[SKCommonMultiPlayerService alloc] init];
    }
    [self.multiPlayerService findPlayers];
}

#pragma mark - alert view delegate;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self restartGame];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - multiplayer delegate
- (void)multiPlayerGamePrepared
{
    [self restartGame];
}
- (void)multiPlayerGameEnd
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)gameRecieveData:(NSData*)data from:(NSString*)playerId
{
    NSNumber* number = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([number intValue] == ATTACK) {
        if (_isAttacking || _shields < 0) {
            [self getHurt];
        } else {
            [self defendAnAttack];
        }
    }
    
    if ([number intValue] == I_LOSE) {
        [self gameEnd:YES];
    }
    
    if (_blood <= 0) {
        NSNumber* number = [NSNumber numberWithInt:I_LOSE];
        NSData* lose = [NSKeyedArchiver archivedDataWithRootObject:number];
        [self.multiPlayerService sendDataToAllPlayers:lose];
        [self gameEnd:NO];
    }
}
- (void)gameCanceled
{
    //[self quitGame];
    [[RecordManager shareInstance] addResult:-1 rivalName:nil date:[NSDate dateWithTimeIntervalSinceNow:0]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)playerLeaveGame:(NSString*)playerId
{
    
}

#pragma mark - game gesture process

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self.view) {
        return YES;
    }
    return NO;
}

- (void)performSwipeGesture:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
    }
}
- (void)performRotationGesture:(UIRotationGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
    }
}

- (void)performLongPressGesture:(UILongPressGestureRecognizer *)recognizer
{    
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
    }
}
- (void)performPinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded){
        
    }
}

- (void)performTapGesture:(UITapGestureRecognizer *)recognizer
{

}


- (void)performPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        
    }else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        //FoodType foodType = Illegal;
        CGPoint point = [recognizer translationInView:self.view];
        //左边
        // GameGestureType gameGestureType = IllegalGameGesture;
        if (point.x < 0) {
            //左扫
            if (ABS(point.x) >= ABS(point.y)) {
                //gameGestureType = LeftPanGameGesture;
                NSLog(@"left swap");
            }else if(point.y > 0){            //下扫
                //gameGestureType = DownPanGameGesture;  
                NSLog(@"down swap");
            }else{            //上扫
                //gameGestureType = UpPanGameGesture;
                NSLog(@"up swap");
                [self throwWeapon];
            }
        }else{
            //右扫
            if (ABS(point.x) >= ABS(point.y)) {
                //gameGestureType = RightPanGameGesture;
                NSLog(@"right swap");
            }else if(point.y > 0){            //下扫
                //gameGestureType = DownPanGameGesture; 
                NSLog(@"down swap");
            }else{                              //上扫
                //gameGestureType = UpPanGameGesture;
                NSLog(@"up swap");
                [self throwWeapon];
            }
        }

    }
}

- (void)view:(UIView *)view addGestureRecognizer:(NSInteger)type 
    delegate:(id<UIGestureRecognizerDelegate>)delegate
{
    UIGestureRecognizer *recognizer = nil;
    SEL action = nil;
    switch (type) {
        case LongPressGestureRecognizer:
            action = @selector(performLongPressGesture:);
            recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:action];
            break;
        case PanGestureRecognizer:
            action = @selector(performPanGesture:);
            recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:action];
            break;
        case PinchGestureRecognizer:
            action = @selector(performPinchGesture:);
            recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:action];
            break;
        case RotationGestureRecognizer:
            action = @selector(performRotationGesture:);
            recognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:action];
            break;
        case SwipeGestureRecognizer:
            action = @selector(performSwipeGesture:);
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:action];
            break;
        case TapGestureRecognizer:
            action = @selector(performTapGesture:);
            recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
            ((UITapGestureRecognizer *)recognizer).numberOfTapsRequired = 1;
            break;
        default:
            return;
    }
    recognizer.delegate = delegate;
    [view addGestureRecognizer:recognizer];
    
}

#pragma mark - accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
    if (abs(acceleration.x/acceleration.z) >3 || abs(acceleration.y/acceleration.z) >3) {
        [self toDefend];
    } else {
        [self toAttack];
    }

}

- (IBAction)clickBackButton:(id)sender
{
    [self quitGame];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithMultiPlayerService:(SKCommonMultiPlayerService*)aMultiPlayerService
{
    self = [super init];
    if (self) {
        self.multiPlayerService = aMultiPlayerService;
        self.multiPlayerService.delegate = self;
    }
    return self;
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
    for (int type = LongPressGestureRecognizer; type < GestureRecognizerTypeCount; ++ type) {
        [self view:self.view addGestureRecognizer:type delegate:self];
    }
    [self.multiPlayerService findPlayers];
    _gameStatus = ready;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWeaponsCount:nil];
    [self setShieldsCount:nil];
    [self setWeapon:nil];
    [self setShield:nil];
    [self setBloodBar:nil];
    [self setBloodsCount:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
