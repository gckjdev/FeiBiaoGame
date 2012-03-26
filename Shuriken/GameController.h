//
//  GameController.h
//  Shuriken
//
//  Created by Orange on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCommonMultiPlayerService.h"
#import "HGQuadCurveMenu.h"
#import "HelpView.h"
#import "SettingView.h"
#import "FinishView.h"
#import "Weapon.h"
#import "Shield.h"
#import "Player.h"

#define OUCH_SOUND_INDEX 0
#define DEFFEND_SOUND_INDEX 1
#define ATTACK_SOUND_INDEX  2

@class FontLabel;

enum GAME_CONTROL {
    PAUSE = 0,
    CONTINUE = 1
    };

@interface GameController : UIViewController <UIGestureRecognizerDelegate, UIAccelerometerDelegate, SKCommonMultiPlayerServiceDelegate, HGQuadCurveMenuDelegate, HelpViewDelegate, SettingViewDelegate, FinishViewDelegate, playerDelegate, ShieldDelegate, weaponDelegate> {
    SKCommonMultiPlayerService* _multiPlayerService;
    NSTimer* _statusChecker;
    HGQuadCurveMenu* _menu;
    int _gameStatus;
    int _counter;
    BOOL _isRivalReady;
}

@property (retain, nonatomic) IBOutlet UIImageView *myThrowHand;
@property (retain, nonatomic) IBOutlet UIImageView *redBlood;
@property (retain, nonatomic) IBOutlet UIImageView *blueBlood;
@property (retain, nonatomic) IBOutlet UIImageView *myHand;
@property (retain, nonatomic) FontLabel *shieldDurability;
@property (retain, nonatomic) FontLabel *weaponCount;
@property (retain, nonatomic) IBOutlet UIImageView *weapon;
@property (retain, nonatomic) IBOutlet UIImageView *shield;
@property (retain, nonatomic) SKCommonMultiPlayerService* multiPlayerService;
@property (retain, nonatomic) FontLabel *rivalNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rivalPosture;
@property (retain, nonatomic) FontLabel* readyView;
@property (retain, nonatomic) Player* mySelf;
@property (retain, nonatomic) Player* rival;
@property (retain, nonatomic) Shield* myShield;
@property (retain, nonatomic) Weapon* myWeapon;

- (id)initWithMultiPlayerService:(SKCommonMultiPlayerService*)aMultiPlayerService;
@end
