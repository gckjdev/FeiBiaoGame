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
#import "MessageManager.h"

#define RESTART_REQUEST 0
#define RESTART_RESPONSE 1

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
@synthesize bloodsCount = _bloodsCount;
@synthesize multiPlayerService = _multiPlayerService;
@synthesize rivalNameLabel = _rivalNameLabel;
@synthesize rivalPosture = _rivalPosture;
@synthesize readyView = _readyView;
@synthesize brokenShield = _brokenShield;


- (void)dealloc
{

    [_weaponsCount release];
    [_shieldsCount release];
    [_weapon release];
    [_shield release];
    [_bloodsCount release];
    [_multiPlayerService release];
    [_rivalNameLabel release];
    [_rivalPosture release];
    [_readyView release];
    [_brokenShield release];
    [super dealloc];
}

- (void)readyToFight
{
    //[self.readyView setImage:[UIImage imageNamed:@"ready.png"]];
    [self.readyView setImage:[UIImage imageNamed:@"ready.png"]];
    [self.readyView setHidden:NO];
    CAAnimation* anim = [AnimationManager scaleAnimationWithFromScale:0.1 
                                                              toScale:1
                                                             duration:2
                                                             delegate:self 
                                                     removeCompeleted:NO];
    [anim setValue:@"showReady" forKey:@"readyToFightAnim"];
    [self.readyView.layer addAnimation:anim forKey:@"showReady"];
    
}

#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    NSString* value = [anim valueForKey:@"readyToFightAnim"];
    if ([value isEqualToString:@"showFight"]) {
        //[self.readyView setHidden:NO];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString* value = [anim valueForKey:@"readyToFightAnim"];
    if ([value isEqualToString:@"showReady"]) {
        //[self.readyView setHidden:YES];
        [self.readyView setImage:[UIImage imageNamed:@"fight.png"]];
        CAAnimation* anim = [AnimationManager scaleAnimationWithFromScale:0.1 
                                                                  toScale:1
                                                                 duration:2
                                                                 delegate:self 
                                                         removeCompeleted:YES];
        [anim setValue:@"showFight" forKey:@"readyToFightAnim"];
        [self.readyView.layer addAnimation:anim forKey:@"fightReady"];
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeMyName]];
    }
    if ([value isEqualToString:@"showFight"]) {
        //
        [self.readyView setHidden:YES];
        _gameStatus = onGo;
    }
}

- (void)gameEnd:(BOOL)didWin
{
    UIAlertView* view = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重来", nil];
    if (didWin) {
        [view setTitle:@"you win"];
        [[RecordManager shareInstance] addResult:1 rivalName:self.rivalNameLabel.text date:[NSDate dateWithTimeIntervalSinceNow:0]];
    } else {
        [view setTitle:@"you lose"];
        [[RecordManager shareInstance] addResult:0 rivalName:self.rivalNameLabel.text date:[NSDate dateWithTimeIntervalSinceNow:0]];
    }
    [view show];
    _isRivalReady = NO;
    _gameStatus = end;
}

- (void)quitGame
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [self.multiPlayerService quitMultiPlayersGame];
}

- (void)updateRivalName:(NSString*)aName
{
    [self.rivalNameLabel setText:aName];
}
#define BLOOD_TAG_OFFSET 20120301
- (void)initRivalBlood
{
    for (int i = 0; i < 10; i++) {
        UIImageView* heart = (UIImageView*)[self.view viewWithTag:(BLOOD_TAG_OFFSET + i)];
        if (heart) {
            [heart setHidden:NO];
        } else {
            heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
            [heart setFrame:CGRectMake(60+i*20, 21, 20, 20)];
            heart.tag = BLOOD_TAG_OFFSET + i;
            [self.view addSubview:heart];
            [heart release];
        } 
    }
}

- (void)initMyBlood
{
    for (int i = 0; i < 10; i++) {
        UIImageView* heart = (UIImageView*)[self.view viewWithTag:(BLOOD_TAG_OFFSET + i + 10)];
        if (heart) {
            [heart setHidden:NO];
        } else {
            heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart.png"]];
            [heart setFrame:CGRectMake(60+i*20, 362, 20, 20)];
            heart.tag = BLOOD_TAG_OFFSET + i +10;
            [self.view addSubview:heart];
            [heart release];
        }
    }
}

- (void)updateRivalBlood:(int)bloodCount
{
    //[self.rivalBloodBar setFrame:CGRectMake(60, 21, 20*bloodCount, 19)];
    UIImageView* view = (UIImageView*)[self.view viewWithTag:(BLOOD_TAG_OFFSET + bloodCount)];
    [view setHidden:YES];
    if (bloodCount <= 0) {
        [self gameEnd:YES];
    }
    
}

- (void)updateMyBlood:(int)bloodCount
{
    UIImageView* view = (UIImageView*)[self.view viewWithTag:(BLOOD_TAG_OFFSET +10 + bloodCount)];
    [view setHidden:YES];
    if (bloodCount == 0) {
        [self gameEnd:NO];
    }
}

- (void)updateRivalPosture:(NSInteger)aPosture
{
    switch (aPosture) {
        case DEFENDING: {
            [self.rivalPosture setImage:[UIImage imageNamed:@"defending.png"]];
            break;
        }
        case UNAVAILABLE_DEFENDING:    
        case EXPOSEING: {
            [self.rivalPosture setImage:[UIImage imageNamed:@"exposing.png"]];
            break;
        }     
        case ATTACKING: {
            [self.rivalPosture setImage:[UIImage imageNamed:@"attacking.png"]];
            break;
        }
        default:
            break;
    }
}

- (void)holdUpShield
{
    [self.shield setCenter:self.weapon.center];
    [self.brokenShield setCenter:self.weapon.center];
}

- (void)shieldBroke
{
    [self.brokenShield setHidden:NO];
    [self.shield setHidden:YES];
}

- (void)shieldShake
{
    [self.shield.layer addAnimation:[AnimationManager shakeFor:10 originX:self.shield.center.x times:10 duration:0.2] forKey:@"SHAKING"];
}

- (void)toUnavailableDefend
{
    [self holdUpShield];
    [self.shield setHidden:YES];
    [self.weapon setHidden:YES];
    [self.brokenShield setHidden:NO];
    _posture = UNAVAILABLE_DEFENDING;
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:UNAVAILABLE_DEFENDING]];
}

- (void)toDefend
{
    if (_shields <= 0) {
        [self toUnavailableDefend];
    }
    [self holdUpShield];
    [self.shield setHidden:NO];
    [self.weapon setHidden:YES];
    [self.brokenShield setHidden:YES];
    _posture = DEFENDING;
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:DEFENDING]];
}

- (void)toExpose
{
    [self.shield setHidden:YES];
    [self.weapon setHidden:YES];
    [self.brokenShield setHidden:YES];
    _posture = EXPOSEING;
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:EXPOSEING]];
}

- (void)toAttack
{
    [self.shield setHidden:YES];
    [self.weapon setHidden:NO];
    [self.brokenShield setHidden:YES];
    _posture = ATTACKING;
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:ATTACKING]];
}

- (void)defendAnAttack
{
    [self shieldShake];
    NSLog(@"i defend!");
    _shields = _shields -1;
    _darts ++;
    if (_shields < 0) {
        [self shieldBroke];
        [self toUnavailableDefend];
    }
}

- (void)getHurt
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    NSLog(@"Ouch!");
    _blood--;
    [self updateMyBlood:_blood];
    if (_blood >= 0) {
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeHurtWithBlood:_blood]];
    } else {
        //[self.multiPlayerService sendDataToAllPlayers:[MessageManager makeLoseMessage]];
        [self gameEnd:NO];
    }
    
}



- (void)throwWeapon
{
    
    [self.weapon.layer addAnimation:[AnimationManager translationAnimationFrom:self.weapon.center to:CGPointMake(160, -240) duration:0.3] forKey:@"throwing"];
    [self.weapon.layer addAnimation:[AnimationManager rotationAnimationWithRoundCount:10 duration:0.3] forKey:@"rotation"];
    if (_posture == ATTACKING && _darts >= 1) {        
        NSData* attack = [MessageManager makeAttack];
        [self.multiPlayerService sendDataToAllPlayers:attack];
        _darts -- ;
        NSLog(@"attack you !!!!");
    }
}

- (void)refleshStatus
{
    if (_posture == DEFENDING || _posture == UNAVAILABLE_DEFENDING) {
        _shields = _shields-0.1;
    }
    if (_darts < 1) {
        [self.weapon setHidden:YES];
    }
    
    if (_shields <= 0 && _shields + 0.1 > 0 && _posture == DEFENDING) {
        [self toUnavailableDefend];
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
        if (_shields-1 < 0 && _shields > 0) {
            [self.shield setImage:[UIImage imageNamed:@"shield.png"]];
        }
    }
}

- (void)startGame
{
    _posture = EXPOSEING;
    _counter = 0;
    _darts = 30;
    _shields = 30;
    _blood = 10;
    [self initMyBlood];
    [self initRivalBlood];
    [_statusChecker invalidate];
    _statusChecker = nil;
    _statusChecker = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refleshStatus) userInfo:nil repeats:YES];
    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 0.05;
    [self.shield setImage:[UIImage imageNamed:@"shield.png"]];
    if (_gameStatus == end || _gameStatus == ready) {
        [self.rivalNameLabel setText:NSLocalizedString(@"waiting", @"")];
    }  
    [self readyToFight];
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
    if (_isRivalReady) {
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeRestart:RESTART_RESPONSE]];
        [self startGame];
    } else {
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeRestart:RESTART_REQUEST]];
        [self.readyView setImage:[UIImage imageNamed:@"waiting.png"]];
        [self.readyView setHidden:NO];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - multiplayer delegate
- (void)multiPlayerGamePrepared
{
    [self startGame];
}
- (void)multiPlayerGameEnd
{
    [self.navigationController popViewControllerAnimated:YES];
}
#define MESSAGE_ID 0
#define MESSAGE_DELIVER 1
#define MESSAGE    2
- (void)gameRecieveData:(NSData*)data from:(NSString*)playerId
{
    NSArray* array = [MessageManager unpackMessage:data];
    NSNumber* messageId = [array objectAtIndex:MESSAGE_ID];
    NSString* message_deliver = [array objectAtIndex:MESSAGE_DELIVER];
    switch (messageId.intValue) {
        case MY_NAME: {
            [self updateRivalName:message_deliver];
            //_gameStatus = onGo;
            break;
        }
        case I_LOSE: {
            if (_gameStatus == onGo) {
                //[self updateRivalBlood:0];
                //[self gameEnd:YES];
            }
            break;
        }
        case I_GET_HURT: {
            if (_gameStatus == onGo) {
                NSNumber* blood = [array objectAtIndex:MESSAGE];
                [self updateRivalBlood:blood.intValue];
            }
            break;
        }
        case ATTACK: {
            if (_gameStatus == onGo) {
                if (_posture != DEFENDING) {
                    [self getHurt];
                } else {
                    [self defendAnAttack];
                }
            }
            break; 
        }
        case POSTURE: {
            if (_gameStatus == onGo) {
                NSNumber* posture = [array objectAtIndex:MESSAGE];
                [self updateRivalPosture:posture.intValue];
            }
            break;
        }
        case RESTART: {
            NSNumber* type = [array objectAtIndex:MESSAGE];
            if (type.intValue == RESTART_REQUEST) {
                _isRivalReady = YES;
            }
            if (type.intValue == RESTART_RESPONSE) {
                [self startGame];
            }
            break;
        }
        default:
            break;
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
    UIAlertView* view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"You won!", @"") 
                                                  message:[NSString stringWithFormat: NSLocalizedString(@"%@ ran away!", @""), self.rivalNameLabel.text]
                                                 delegate:self 
                                        cancelButtonTitle:NSLocalizedString(@"OK", @"") 
                                        otherButtonTitles: nil];
    [view show];
    [view release];
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
    if (_gameStatus != onGo) {
        return;
    }
    switch (_posture) {
        case ATTACKING: {
            if (abs(acceleration.z*10) < 6) {
                [self toExpose];
            }
        }
            break;
        case EXPOSEING: {
            if (abs(acceleration.z*10) < 4) {
                [self toDefend];
            } else if (abs(acceleration.z*10) >7) {
                [self toAttack];
            }
        }
            break;
        case UNAVAILABLE_DEFENDING:
        case DEFENDING: {
            if (abs(acceleration.z*10) >5 ) {
                [self toExpose];
            }
        }
            break;
        default:
            break;
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
    [self setBloodsCount:nil];
    [self setRivalNameLabel:nil];
    [self setRivalPosture:nil];
    [self setReadyView:nil];
    [self setBrokenShield:nil];
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
