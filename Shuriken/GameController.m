//
//  GameController.m
//  Shuriken
//
//  Created by Orange on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameController.h"
#import "AnimationManager.h"
#import "SKCommonAudioManager.h"
#import "RecordManager.h"
#import "MessageManager.h"
#import "SettingsManager.h"
#import "CustomLabelUtil.h"



#define MASK_TAG        20120316
#define GAME_ANIMATION @"game_animation"

#define RESTART_REQUEST 0
#define RESTART_RESPONSE 1

#define REFLESH_TIME_INTERVAL 0.01

#define FULL_SHURIKEN_COUNT     12
#define FULL_BLOOD_COUNT        10
#define FULL_SHIELD_DURABILITY  10

#define BROKEN_SHIELD @"shield4.png"
#define BADLY_DAMAGE_SHIELD @"shield3.png"
#define DAMAGE_SHIELD @"shield2.png"
#define GOOD_SHIELD @"shield1.png"


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
    game_pause,
    end
}GameStatus;

@implementation GameController
@synthesize myThrowHand = _myThrowHand;
@synthesize redBlood = _redBlood;
@synthesize blueBlood = _blueBlood;
@synthesize myHand = _myHand;
@synthesize shieldDurability = _shieldDurability;
@synthesize weaponCount = _weaponCount;
@synthesize weapon = _weapon;
@synthesize shield = _shield;
@synthesize multiPlayerService = _multiPlayerService;
@synthesize rivalNameLabel = _rivalNameLabel;
@synthesize rivalPosture = _rivalPosture;
@synthesize readyView = _readyView;
@synthesize mySelf = _mySelf;
@synthesize rival = _rival;
@synthesize myShield = _myShield;
@synthesize myWeapon = _myWeapon;


- (void)dealloc
{
    [_shieldDurability release];
    [_weaponCount release];
    [_weapon release];
    [_shield release];
    [_multiPlayerService release];
    [_rivalNameLabel release];
    [_rivalPosture release];
    [_readyView release];
    [_myHand release];
    [_blueBlood release];
    [_redBlood release];
    [_myThrowHand release];
    [_mySelf release];
    [_rival release];
    [super dealloc];
}

- (void)clickContinue
{
    [self continueGame];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeControl:CONTINUE]];
}

- (void)creatMask
{
    UIView* mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [mask setBackgroundColor:[UIColor clearColor]];
    UIView* maskBackground = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
    [maskBackground setBackgroundColor:[UIColor blackColor]];
    [maskBackground setAlpha:0.5];
    [mask addSubview:maskBackground];
    [mask setTag:MASK_TAG];
    UIButton* btn = [[[UIButton alloc] initWithFrame:CGRectMake(80, 120, 160, 240)] autorelease];
    [btn setBackgroundImage:[UIImage imageNamed:@"pauseimg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickContinue) forControlEvents:UIControlEventTouchUpInside];
    [mask addSubview:btn];
    [self.view addSubview:mask];
}

- (void)removeMask
{
    UIView* view = [self.view viewWithTag:MASK_TAG];
    if (view) {
        [view removeFromSuperview];
    }
}

- (void)addOptionButton
{
    
    HGQuadCurveMenuItem *help = [[HGQuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"help.png"] 
                                                                  highlightedImage:[UIImage imageNamed:nil]
                                                                      contentImage:nil 
                                                           highlightedContentImage:nil 
                                                                             title:nil];
    HGQuadCurveMenuItem *setting = [[HGQuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"setting.png"]  
                                                             highlightedImage:[UIImage imageNamed:nil]  
                                                                    contentImage:nil 
                                                         highlightedContentImage:nil 
                                                                           title:nil];
    HGQuadCurveMenuItem *escape = [[HGQuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"escape.png"]  
                                                            highlightedImage:[UIImage imageNamed:nil]  
                                                                     contentImage:nil 
                                                          highlightedContentImage:nil 
                                                                            title:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:help, setting, escape, nil];
    [help release];
    [setting release];
    [escape release];    
    _menu = [[HGQuadCurveMenu alloc] 
             initWithFrame:self.view.bounds
             menus:menus 
             nearRadius:150 - 30 
             endRadius:160 - 30
             farRadius:170 - 30
             startPoint:CGPointMake(30, 450) 
             timeOffset:0.036 
             rotateAngle:0
             menuWholeAngle:(M_PI/2)
             buttonImage:[UIImage imageNamed:@"pause.png"] 
             buttonHighLightImage:[UIImage imageNamed:@"pause.png"] 
             contentImage:nil
             contentHighLightImage:nil];
    _menu.delegate = self;
    [self.view addSubview:_menu];
    [_menu release];
}

- (void)readyToFight
{
    //[self.readyView setImage:[UIImage imageNamed:@"ready.png"]];
    if (!_readyView) {
        _readyView = [[FontLabel alloc] initWithFrame:CGRectMake(0, 120, 320, 240) fontName:@"fzkatjw" pointSize:80];
        [_readyView setBackgroundColor:[UIColor clearColor]];
        [_readyView setTextAlignment:UITextAlignmentCenter];
        [_readyView setTextColor:[UIColor blackColor]];
        [self.view addSubview:_readyView];
    }
    
    [self.readyView setHidden:NO];
    [self.readyView setText:@"ready"];
    CAAnimation* anim = [AnimationManager scaleAnimationWithFromScale:0.1 
                                                              toScale:1
                                                             duration:1
                                                             delegate:self 
                                                     removeCompeleted:NO];
    [anim setValue:@"showReady" forKey:GAME_ANIMATION];
    [self.readyView.layer addAnimation:anim forKey:@"showReady"];
    
}

- (void)popUpMessage:(NSString*)text color:(UIColor*)textColor center:(CGPoint)point
{
    FontLabel* label = [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 40, 20) pointSize:15 alignment:UITextAlignmentCenter textColor:textColor addTo:self.view text:text bold:NO];    
    CAAnimation *popUp = [AnimationManager 
                          translationAnimationFrom:CGPointMake(160, 255) 
                          to:CGPointMake(160, 120) 
                          duration:2];
    CAAnimation *popOpacity = [AnimationManager missingAnimationWithDuration:2];
    
    [label.layer addAnimation:popUp forKey:@"popUp"];
    [label.layer addAnimation:popOpacity forKey:@"popOpacity"];
}

#pragma mark - animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    NSString* value = [anim valueForKey:GAME_ANIMATION];
    if ([value isEqualToString:@"throwingWeapon"]) {
        [self.myHand setHidden:YES];
        [self.myThrowHand setHidden:NO];
        if ([[SettingsManager shareInstance] isSoundOn]) {
            [[SKCommonAudioManager defaultManager] playSoundById:ATTACK_SOUND_INDEX];
            
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString* value = [anim valueForKey:GAME_ANIMATION];
    if ([value isEqualToString:@"showReady"]) {
        //[self.readyView setHidden:YES];
        [self.readyView setText:@"fight"];
        CAAnimation* anim = [AnimationManager scaleAnimationWithFromScale:0.1 
                                                                  toScale:1
                                                                 duration:1
                                                                 delegate:self 
                                                         removeCompeleted:YES];
        [anim setValue:@"showFight" forKey:GAME_ANIMATION];
        [self.readyView.layer addAnimation:anim forKey:@"fightReady"];
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeMyName]];
    }
    if ([value isEqualToString:@"showFight"]) {
        //
        [self.readyView setHidden:YES];
        _gameStatus = onGo;
        self.mySelf.posture = EXPOSEING;
        self.mySelf.health = FULL_BLOOD_COUNT;
        self.rival.posture = EXPOSEING;
        self.rival.health = FULL_BLOOD_COUNT;
        
        self.myShield.durability = FULL_SHIELD_DURABILITY;
        self.myShield.status = GOOD;
        
        self.myWeapon.weaponCount = FULL_SHURIKEN_COUNT;
        
        _counter = 0;
    }
    if ([value isEqualToString:@"throwingWeapon"]) {
        if (self.mySelf.posture == ATTACKING && self.myWeapon.weaponCount >= 1) {        
            NSData* attack = [MessageManager makeAttack:self.mySelf.currentWeapon];
            [self.multiPlayerService sendDataToAllPlayers:attack];
            self.myWeapon.weaponCount -- ;
            NSLog(@"attack you !!!!");
            if (self.myWeapon.weaponCount > 1) {
                [self.myHand setHidden:NO];
                [self.myThrowHand setHidden:YES];
            }            
        }

    }
}

- (void)gameEnd:(BOOL)didWin
{
    if (_gameStatus == onGo) {
        FinishView* view = [FinishView createSettingViewWithDelegate:self didWin:didWin];
        [self.view addSubview:view];
        _isRivalReady = NO;
        _gameStatus = end;
    }   
}

- (void)quitGame
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    [self.multiPlayerService quitMultiPlayersGame];
}

- (void)pauseGame
{
    [self creatMask];
    _gameStatus = game_pause;
}

- (void)continueGame
{
    [_menu setHidden:NO];
    if (_menu.isExpanding) {
        [_menu closeItems];
    }
    [self removeMask];
    _gameStatus = onGo;
}

- (void)updateRivalName:(NSString*)aName
{
    [self.rivalNameLabel setText:aName];
}

#define BLOOD_TAG_OFFSET 20120301
//- (void)initRivalBlood
//{
//    [self.redBlood setImage:[UIImage imageNamed:@"redblood10.png"]];
//}
//
//- (void)initMyBlood
//{
//    [self.blueBlood setImage:[UIImage imageNamed:@"blueblood10.png"]];
//}
//
//- (void)updateRivalBlood:(int)bloodCount
//{
//    if (bloodCount == 0) {
//        [self gameEnd:YES];
//        return;
//    }
//    if (bloodCount > 0) {
//        NSString* bloodString = [NSString stringWithFormat:@"redblood%d.png", bloodCount];
//        [self.redBlood setImage:[UIImage imageNamed:bloodString]];
//    }
//}
//
//- (void)updateMyBlood:(int)bloodCount
//{
//    if (bloodCount > 0) {
//        NSString* bloodString = [NSString stringWithFormat:@"blueblood%d.png", bloodCount];
//        [self.blueBlood setImage:[UIImage imageNamed:bloodString]];
//    }
//    if (bloodCount == 0) {
//        [self gameEnd:NO];
//    }
//}

//- (void)updateRivalPosture:(NSInteger)aPosture rivalShields:(float)shieldsCount
//{
//    float shieldPercentage = shieldsCount/FULL_SHURIKEN_COUNT;
//    switch (aPosture) {
//        case DEFENDING: {
//            if (shieldPercentage > 0.66) {
//                [self.rivalPosture setImage:[UIImage imageNamed:@"shieldSmall.png"]];
//            }
//             else if (shieldPercentage > 0.33) {
//                [self.rivalPosture setImage:[UIImage imageNamed:DAMAGE_SHIELD]];
//             } 
//             else if (shieldPercentage > 0) {
//                 [self.rivalPosture setImage:[UIImage imageNamed:BADLY_DAMAGE_SHIELD]];
//             } 
//             else {
//                 [self.rivalPosture setImage:[UIImage imageNamed:BROKEN_SHIELD]];
//             }
//            break;
//        }
//        case UNAVAILABLE_DEFENDING:    
//        case EXPOSEING: {
//            [self.rivalPosture setImage:[UIImage imageNamed:@"exposing.png"]];
//            break;
//        }     
//        case ATTACKING: {
//            [self.rivalPosture setImage:[UIImage imageNamed:@"shurikenSmall.png"]];
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)holdUpShield
{
    [self.shield setCenter:self.weapon.center];
}

- (void)shieldShake
{
    [self.shield.layer addAnimation:[AnimationManager shakeFor:10 originX:self.shield.center.x times:10 duration:0.2] forKey:@"SHAKING"];
}

- (void)toUnavailableDefend
{
    [self holdUpShield];
    [self.shield setHidden:NO];
    [self.weapon setHidden:YES];
    [self.myThrowHand setHidden:YES];
    [self.myHand setHidden:YES];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:UNAVAILABLE_DEFENDING shieldStat:self.myShield.status]];
}

- (void)toDefend
{
    [self holdUpShield];
    [self.shield setHidden:NO];
    [self.weapon setHidden:YES];
    [self.myHand setHidden:YES];
    [self.myThrowHand setHidden:YES];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:DEFENDING shieldStat:self.myShield.status]];
}

- (void)toExpose
{
    [self.shield setHidden:YES];
    [self.weapon setHidden:YES];
    [self.myHand setHidden:YES];
    [self.myThrowHand setHidden:NO];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:EXPOSEING shieldStat:self.myShield.status]];
}

- (void)toAttack
{
    [self.shield setHidden:YES];
    [self.weapon setHidden:NO];
    [self.myHand setHidden:NO];
    [self.myThrowHand setHidden:YES];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makePosture:ATTACKING shieldStat:self.myShield.status]];
}

- (void)defendAnAttack
{
    [self shieldShake];
    NSLog(@"i defend!");
    if ([[SettingsManager shareInstance] isSoundOn]) {
        [[SKCommonAudioManager defaultManager] playSoundById:DEFFEND_SOUND_INDEX];
    }
}

- (void)getHurt
{
    if ([[SettingsManager shareInstance] isVibration]) {
        [[SKCommonAudioManager defaultManager] vibrate];
    }
    if ([[SettingsManager shareInstance] isSoundOn]) {
        [[SKCommonAudioManager defaultManager] playSoundById:OUCH_SOUND_INDEX];
    } 
    [self.view.layer addAnimation:[AnimationManager shakeFor:10 originX:self.view.center.x times:10 duration:0.2] forKey:@"SHAKING"];
    NSLog(@"Ouch!");
    
}



- (void)throwWeapon
{
    if (self.mySelf.posture == ATTACKING && self.myWeapon.weaponCount >0) {
        CAAnimation* anim = [AnimationManager translationAnimationFrom:self.weapon.center to:CGPointMake(160, -240) duration:0.3];
        CAAnimation* scrollingAnim = [AnimationManager rotationAnimationWithRoundCount:10 duration:0.3];
        [anim setValue:@"throwingWeapon" forKey:GAME_ANIMATION];
        [scrollingAnim setValue:@"throwingWeapon" forKey:GAME_ANIMATION];
        anim.delegate = self;
        [self.weapon.layer addAnimation:anim forKey:@"throwing"];
        [self.weapon.layer addAnimation:scrollingAnim forKey:@"rotation"];
    }
}

- (void)refleshStatus
{
    self.myShield.durability += 1.0/self.myShield.recoverTime * REFLESH_TIME_INTERVAL;
    if (_counter == 1/REFLESH_TIME_INTERVAL) {
        _counter = 0;
        self.myWeapon.weaponCount ++;
    }
    _counter ++;
    float shieldPercentage = self.myShield.durability/self.myShield.maxDurability;
    if (shieldPercentage > 0.66) {
        self.myShield.status = GOOD;
    } else if (shieldPercentage > 0.33) {
        self.myShield.status = DAMAGE;
        
    } else if (shieldPercentage > 0) {
        self.myShield.status = BADLY_DAMAGE;
    } else {
        self.myShield.status = BROKEN;
    }
    
    
//    switch (_shieldStatus) {
//        case GOOD: {
//            if (shieldPercentage < 0.66) {
//                [self updateShieldStatus:DAMAGE];
//            }
//        }
//            break;
//        case DAMAGE: {
//            if (shieldPercentage < 0.33) {
//                [self updateShieldStatus:BADLY_DAMAGE];
//            }
//            if (shieldPercentage > 0.66) {
//                [self updateShieldStatus:GOOD];
//            }
//            break;
//        }
//        case BADLY_DAMAGE: {
//            if (shieldPercentage < 0) {
//                [self updateShieldStatus:BROKEN];
//            }
//            if (shieldPercentage > 0.33) {
//                [self updateShieldStatus:DAMAGE];
//            }
//            break;
//        }
//        case BROKEN: {
//            if (shieldPercentage > 0) {
//                [self updateShieldStatus:BADLY_DAMAGE];
//            }
//            break;
//        }            
//        default:
//            break;
//    }
//    if (_posture == DEFENDING || _posture == UNAVAILABLE_DEFENDING) {
//        //_shields = _shields-0.1;
//        [self.shieldsCount setText:[NSString stringWithFormat:@"%.0f", _shields]];
//    } else if (_posture == ATTACKING) {
//        [self.shieldsCount setText:[NSString stringWithFormat:@"%d", _darts]];
//    } else {
//        [self.shieldsCount setText:@""];
//    }
//    if (_posture == ATTACKING) {
//        if (_darts < 1) {
//            [self.myHand setHidden:YES];
//            [self.myThrowHand setHidden:NO];
//            [self.weapon setHidden:YES];
//        } else {
//            [self.myHand setHidden:NO];
//            [self.myThrowHand setHidden:YES];
//            [self.weapon setHidden:NO];
//        }
//        
//    }
//    
//    if (_shields <= 0 && _posture == DEFENDING) {
//        [self toUnavailableDefend];
//    }
//   _counter++;
//    if (_counter%10 == 0 && _darts < FULL_SHURIKEN_COUNT) {
//        _darts ++;
//    }
//    if ((_shields < FULL_SHIELD_DURABILITY)) {
//        _shields = _shields +0.1;
//        [self.shieldDurabilty setFrame:CGRectMake(58, 419, 188*_shields/FULL_SHIELD_DURABILITY, 12)];
//        if (_posture == UNAVAILABLE_DEFENDING && _shields > 0) {
//            [self toDefend];
//        }
//    }
}

- (void)startGame
{
    

    UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.delegate = self;
    accelerometer.updateInterval = 0.05;
    [_statusChecker invalidate];
    _statusChecker = [NSTimer scheduledTimerWithTimeInterval:REFLESH_TIME_INTERVAL target:self selector:@selector(refleshStatus) userInfo:nil repeats:YES];
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
    [self.multiPlayerService findPlayers:self];
}

#pragma mark - alert view delegate;
#define RESTART_INDEX 1



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
#define SHIELD_STATS 3
- (void)gameRecieveData:(NSData*)data from:(NSString*)playerId
{
    NSArray* array = [MessageManager unpackMessage:data];
    NSNumber* messageId = [array objectAtIndex:MESSAGE_ID];
    NSString* message_deliver = [array objectAtIndex:MESSAGE_DELIVER];
    switch (messageId.intValue) {
        case MSG_MY_NAME: {
            [self updateRivalName:message_deliver];
            //_gameStatus = onGo;
            NSLog(@"get rival name!");
            break;
        }
        case MSG_ATTACK: {
            NSLog(@"you are under attack!");
            Weapon* weapon = [array objectAtIndex:MESSAGE];
            if (_gameStatus == onGo) {
                ATTACK_RESPONSE result = [self.mySelf attackedByWeapon:weapon];
                [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeAttackResponse:result]];
                switch (result) {
                    case HIT: {
                        [self getHurt];
                    }
                        break;
                    case BLOCK: {
                        [self defendAnAttack];
                    }
                        break;
                    default:
                        break;
                }
            }
            break; 
        }
        case MSG_POSTURE: {
            NSLog(@"update rival posture!");
            if (_gameStatus == onGo) {
                NSNumber* posture = [array objectAtIndex:MESSAGE];
                NSNumber* shieldStats = [array objectAtIndex:SHIELD_STATS];
                [self.rival setPosture:posture.intValue];
                self.rival.currentShield.status = shieldStats.intValue;
            }
            break;
        }
        case MSG_RESTART: {
            NSLog(@"restart request!");
            NSNumber* type = [array objectAtIndex:MESSAGE];
            if (type.intValue == RESTART_REQUEST) {
                _isRivalReady = YES;
                if (_gameStatus == ready) {
                    [self startGame];
                }
            }
            if (type.intValue == RESTART_RESPONSE) {
                [self startGame];
            }
            break;
        }
        case MSG_GAME_CONTROL: {
            NSLog(@"game control!");
            NSNumber* control = [array objectAtIndex:MESSAGE];
            if (_gameStatus == onGo && control.intValue == PAUSE) {
                [self pauseGame];
            }
            if (_gameStatus == game_pause && control.intValue == CONTINUE) {
                [self continueGame];
            }
        }
            break;
        case MSG_ATTACK_RESULT: {
            NSLog(@"attak result!");
            NSNumber* reslut = [array objectAtIndex:MESSAGE];
            switch (reslut.intValue) {
                case HIT: {
                    self.rival.health --;
                }
                    break;
                case MISS: {
                    [self popUpMessage:@"MISS" color:[UIColor greenColor] center:self.view.center];
                }
                    break;
                case BLOCK: {
                    
                }
                default:
                    break;
            }
        }
            break;
        case MSG_SHIELD_STAT: {
            NSLog(@"attak result!");
            NSNumber* stat = [array objectAtIndex:MESSAGE];
            switch (stat.intValue) {
                case GOOD: {
                    [self.rivalPosture setImage:[UIImage imageNamed:GOOD_SHIELD]];
                }            
                    break;
                case DAMAGE: {
                    [self.rivalPosture setImage:[UIImage imageNamed:DAMAGE_SHIELD]];
                    break;
                }
                case BADLY_DAMAGE: {
                    [self.rivalPosture setImage:[UIImage imageNamed:BADLY_DAMAGE_SHIELD]];
                    break;
                }
                case BROKEN: {
                    [self.rivalPosture setImage:[UIImage imageNamed:BROKEN_SHIELD]];
                    break;
                }   
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }

}
- (void)gameCanceled
{
    //[self quitGame];
    //[[RecordManager shareInstance] addResult:RUN_AWAY rivalName:nil date:[NSDate dateWithTimeIntervalSinceNow:0]];
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
    [recognizer release];
    
}

#pragma mark - accelerometer delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
    if (_gameStatus != onGo) {
        return;
    }
    switch (self.mySelf.posture) {
        case ATTACKING: {
            if (abs(acceleration.z*10) < 6) {
                [self.mySelf setPosture:EXPOSEING];
            }
        }
            break;
        case EXPOSEING: {
            if (abs(acceleration.z*10) < 4) {
                if (self.myShield.durability > 0) {
                    [self.mySelf setPosture:DEFENDING];
                } else {
                    [self.mySelf setPosture:UNAVAILABLE_DEFENDING];
                }
                
            } else if (abs(acceleration.z*10) >7) {
                [self.mySelf setPosture:ATTACKING];
            }
        }
            break;
        case UNAVAILABLE_DEFENDING:
        case DEFENDING: {
            if (abs(acceleration.z*10) >5 ) {
                [self.mySelf setPosture:EXPOSEING];
            }
        }
            break;
        default:
            break;
    }

}

#pragma mark - helpView delegate
- (void)clickOkButton
{
    _gameStatus = onGo;
    [self continueGame];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeControl:CONTINUE]];
}

#pragma mark - settingView delegate
- (void)settingFinish
{
    _gameStatus = onGo;
    [self continueGame];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeControl:CONTINUE]];
}

#pragma mark - finishView delegate
- (void)restart
{
    if (_isRivalReady) {
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeRestart:RESTART_RESPONSE]];
        [self startGame];
    } else {
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeRestart:RESTART_REQUEST]];
        _gameStatus = ready;
        [self.readyView setText:@"waiting"];
        [self.readyView setHidden:NO];
        [self toExpose];
        [self.myThrowHand setHidden:YES];
    }
}

- (void)exit
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QUADCURVE MENU DELEGATE
#define HELP 0
#define SETTING 1
#define ESCAPE 2
- (void)quadCurveMenu:(HGQuadCurveMenu *)menu didSelectIndex:(NSInteger)anIndex
{
    [_menu setHidden:YES];
    switch (anIndex) {
        case HELP: {
            HelpView* view = [HelpView createHelpViewWithDelegate:self];
            UIView* mask = [self.view viewWithTag:MASK_TAG];
            [mask addSubview:view];
        }
            break;
        case SETTING: {
            SettingView* view = [SettingView createSettingViewWithDelegate:self];
            UIView* mask = [self.view viewWithTag:MASK_TAG];
            [mask addSubview:view];
        }
            break;
        case ESCAPE: {
            [self quitGame];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)quadCurveMenuDidExpand
{
    [self pauseGame];
    [self.view bringSubviewToFront:_menu];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeControl:PAUSE]];
}

- (void)quadCurveMenuDidClose
{
    [self removeMask];
    [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeControl:CONTINUE]];
}

#pragma mark - player,weapon,shield delegate
- (void)player:(Player *)thePlayer updatePlayerHealth:(int)health
{
    if (thePlayer.isRival) {
        if (health > 0) {
            NSString* bloodString = [NSString stringWithFormat:@"redblood%d.png", health];
            [self.redBlood setImage:[UIImage imageNamed:bloodString]];
        }
        if (health == 0) {
            [self gameEnd:YES];
        }
    } else {
        if (health > 0) {
            NSString* bloodString = [NSString stringWithFormat:@"blueblood%d.png", health];
            [self.blueBlood setImage:[UIImage imageNamed:bloodString]];
        }
        if (health == 0) {
            [self gameEnd:NO];
        }
    }
}

- (void)player:(Player *)thePlayer updatePlayerPosture:(int)posture
{
    if (thePlayer.isRival) {
        switch (posture) {
            case ATTACKING: {
                [self.rivalPosture setImage:[UIImage imageNamed:@"shurikenSmall.png"]];
            }
                break;
            case DEFENDING: {
                [self.rivalPosture setImage:[UIImage imageNamed:@"shieldSmall.png"]];
            }
                break;
            case UNAVAILABLE_DEFENDING:
            case EXPOSEING: {
                [self.rivalPosture setImage:[UIImage imageNamed:@"throw.png"]];
            }
                break;
            default:
                break;
        }
    } else {
        switch (posture) {
            case ATTACKING: {
                [self toAttack];
            }
                break;
            case DEFENDING: {
                [self toDefend];
            }
                break;
            case EXPOSEING: {
                [self toExpose];
            }
                break;
            default:
                break;
        }
    }
}

- (void)shield:(Shield*)theShield updateShieldDurability:(float)durability
{
    [self.shieldDurability setText:[NSString stringWithFormat:@"%.0f%%", self.mySelf.currentShield.durability/self.mySelf.currentShield.maxDurability*100.0]];
}

- (void)shield:(Shield*)theShield updateShieldStatus:(int)shieldStatus
{
    if (theShield == self.mySelf.currentShield) {
        switch (shieldStatus) {
            case GOOD: {
                [self.shield setImage:[UIImage imageNamed:GOOD_SHIELD]];
            }            
                break;
            case DAMAGE: {
                [self.shield setImage:[UIImage imageNamed:DAMAGE_SHIELD]];
                break;
            }
            case BADLY_DAMAGE: {
                [self.shield setImage:[UIImage imageNamed:BADLY_DAMAGE_SHIELD]];
                break;
            }
            case BROKEN: {
                [self.shield setImage:[UIImage imageNamed:BROKEN_SHIELD]];
                break;
            }
            default:
                break;
        }
        [self.multiPlayerService sendDataToAllPlayers:[MessageManager makeShieldStatus:shieldStatus]];
    } 
}

- (void)weapon:(Weapon*)theWeapon updateWeaponCount:(int)weaponCount
{
    [self.weaponCount setText:[NSString stringWithFormat:@"%d", self.myWeapon.weaponCount]];
    if (weaponCount == 0) {
        [self.weapon setHidden:YES];
    } else if (self.mySelf.posture == ATTACKING) {
        [self.weapon setHidden:NO];
        [self.myThrowHand setHidden:YES];
        [self.myHand setHidden:NO];
    }
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
    [self addOptionButton];
    for (int type = LongPressGestureRecognizer; type < GestureRecognizerTypeCount; ++ type) {
        [self view:self.view addGestureRecognizer:type delegate:self];
    }
    self.rivalNameLabel = [CustomLabelUtil creatWithFrame:CGRectMake(110, -5, 88, 30) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor whiteColor] addTo:self.view text:@"" shadow:NO bold:NO];
    self.shieldDurability = [CustomLabelUtil creatWithFrame:CGRectMake(190, 400, 60, 31) pointSize:20 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:@"" shadow:NO bold:NO];
    self.weaponCount = [CustomLabelUtil creatWithFrame:CGRectMake(96, 400, 60, 31) pointSize:20 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.view text:@"" shadow:NO bold:NO];
    
    _mySelf = [[Player alloc] initWithPosture:EXPOSEING health:10 observer:self isRival:NO];
    _rival = [[Player alloc] initWithPosture:EXPOSEING health:10 observer:self isRival:YES];
    _myWeapon = [[Weapon alloc] initWithCount:FULL_SHURIKEN_COUNT damage:1.0 recoverTime:0.5 observer:self];
    _myWeapon.accuracy = 0.9;
    _myShield = [[Shield alloc] initWithDurability:FULL_SHIELD_DURABILITY status:GOOD recoverTime:1.5 observer:self];
    _mySelf.currentWeapon = _myWeapon;
    _mySelf.currentShield = _myShield;
    _gameStatus = ready;
    [self findMultiPlayers];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setShieldDurability:nil];
    [self setWeapon:nil];
    [self setShield:nil];
    [self setRivalNameLabel:nil];
    [self setRivalPosture:nil];
    [self setReadyView:nil];
    [self setMyHand:nil];
    [self setBlueBlood:nil];
    [self setRedBlood:nil];
    [self setMyThrowHand:nil];
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
