//
//  FinishView.h
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>
@protocol FinishViewDelegate <NSObject>

- (void)restart;
- (void)exit;

@end

@interface FinishView : UIView {
    
}
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) IBOutlet UIButton *restartButton;
@property (retain, nonatomic) IBOutlet UIImageView *resultImage;
@property (retain, nonatomic) id<FinishViewDelegate> delegate;

+ (FinishView *)createFinishView:(BOOL)didWin;
+ (FinishView *)createSettingViewWithDelegate:(id<FinishViewDelegate>)aDelegate didWin:(BOOL)didWin;

@end
