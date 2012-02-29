//
//  GameController.h
//  Shuriken
//
//  Created by Orange on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCommonMultiPlayerService.h"

@interface GameController : UIViewController <UIGestureRecognizerDelegate, UIAccelerometerDelegate, UIAlertViewDelegate, SKCommonMultiPlayerServiceDelegate> {
    SKCommonMultiPlayerService* _multiPlayerService;
    BOOL _isAttacking;
    NSTimer* _statusChecker;
    float _retainDarts;
    float _retainShields;
    float _retainBlood;
    int _darts;
    float _shields;
    int _blood;
    int _gameStatus;
    int _counter;
}
@property (retain, nonatomic) IBOutlet UILabel *weaponsCount;
@property (retain, nonatomic) IBOutlet UILabel *shieldsCount;
@property (retain, nonatomic) IBOutlet UIImageView *weapon;
@property (retain, nonatomic) IBOutlet UIImageView *shield;
@property (retain, nonatomic) IBOutlet UIButton *bloodBar;
@property (retain, nonatomic) IBOutlet UILabel *bloodsCount;
@property (retain, nonatomic) SKCommonMultiPlayerService* multiPlayerService;
@property (retain, nonatomic) IBOutlet UIButton *rivalBloodBar;
@property (retain, nonatomic) IBOutlet UILabel *rivalNameLabel;

- (id)initWithMultiPlayerService:(SKCommonMultiPlayerService*)aMultiPlayerService;
@end
