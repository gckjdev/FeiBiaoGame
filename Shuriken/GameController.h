//
//  GameController.h
//  Shuriken
//
//  Created by Orange on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCommonMultiPlayerService.h"

enum POSTURE {
    DEFENDING = -1,
    EXPOSEING = 0,
    ATTACKING = 1,
    UNAVAILABLE_DEFENDING,
    
    };

@interface GameController : UIViewController <UIGestureRecognizerDelegate, UIAccelerometerDelegate, UIAlertViewDelegate, SKCommonMultiPlayerServiceDelegate> {
    SKCommonMultiPlayerService* _multiPlayerService;
    NSTimer* _statusChecker;
    float _retainDarts;
    float _retainShields;
    float _retainBlood;
    int _darts;
    float _shields;
    int _blood;
    int _gameStatus;
    int _counter;
    int _posture;
    BOOL _isRivalReady;
}
@property (retain, nonatomic) IBOutlet UILabel *weaponsCount;
@property (retain, nonatomic) IBOutlet UILabel *shieldsCount;
@property (retain, nonatomic) IBOutlet UIImageView *weapon;
@property (retain, nonatomic) IBOutlet UIImageView *shield;
@property (retain, nonatomic) IBOutlet UILabel *bloodsCount;
@property (retain, nonatomic) SKCommonMultiPlayerService* multiPlayerService;
@property (retain, nonatomic) IBOutlet UILabel *rivalNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *rivalPosture;
@property (retain, nonatomic) IBOutlet UIImageView *readyView;
@property (retain, nonatomic) IBOutlet UIImageView *brokenShield;

- (id)initWithMultiPlayerService:(SKCommonMultiPlayerService*)aMultiPlayerService;
@end
