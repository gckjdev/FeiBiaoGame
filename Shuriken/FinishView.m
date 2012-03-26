//
//  FinishView.m
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FinishView.h"
#import "AnimationManager.h"
#import "CustomLabelUtil.h"

@implementation FinishView
@synthesize backButton;
@synthesize restartButton;
@synthesize resultImage;
@synthesize delegate = _delegate;


+ (FinishView *)createFinishView:(BOOL)didWin
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FinishView" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <FinishView> but cannot find cell object from Nib");
        return nil;
    }
    FinishView* view =  (FinishView*)[topLevelObjects objectAtIndex:0];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:view.backButton text:NSLocalizedString(@"Back", @"退出") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:view.restartButton text:NSLocalizedString(@"restart", @"重玩") shadow:NO bold:YES];
    if (didWin) {
        [view.resultImage setImage:[UIImage imageNamed:@"win.png"]];
        [CustomLabelUtil creatWithFrame:CGRectMake(78, 185, 145, 40) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:view text:NSLocalizedString(@"Contratulations!", @"") shadow:NO bold:YES];
        [CustomLabelUtil creatWithFrame:CGRectMake(50, 229, 287, 21) pointSize:15 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:view text:NSLocalizedString(@"you win!", @"") shadow:NO bold:YES];
    } else {
        [view.resultImage setImage:[UIImage imageNamed:@"lose.png"]];
        [CustomLabelUtil creatWithFrame:CGRectMake(88, 185, 135, 40) pointSize:15 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:view text:NSLocalizedString(@"What a pity!", @"") shadow:NO bold:YES];
        [CustomLabelUtil creatWithFrame:CGRectMake(50, 229, 287, 21) pointSize:15 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:view text:NSLocalizedString(@"you lose!", @"") shadow:NO bold:YES];
    }
    CAAnimation *putUp = [AnimationManager translationAnimationFrom:CGPointMake(160, 720) to:CGPointMake(160, 240) duration:0.3 delegate:self removeCompeleted:NO];
    [view.layer addAnimation:putUp forKey:@"putUp"];
    return view;
    
}

+ (FinishView *)createSettingViewWithDelegate:(id<FinishViewDelegate>)aDelegate didWin:(BOOL)didWin
{
    FinishView* view = [FinishView createFinishView:didWin];
    view.delegate = aDelegate;
    return view;
    
}

- (IBAction)clickRestart:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(restart)]) {
        [_delegate restart];
    }
    CAAnimation *putDown = [AnimationManager translationAnimationFrom:CGPointMake(160, 240) to:CGPointMake(160, 720) duration:0.1 delegate:self removeCompeleted:NO];
    [putDown setValue:@"minify" forKey:@"AnimationKey"];
    [putDown setDelegate:self];
    [self.layer addAnimation:putDown forKey:@"minify"];
}

- (IBAction)clickBack:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(exit)]) {
        [_delegate exit];
    }
    CAAnimation *putDown = [AnimationManager translationAnimationFrom:CGPointMake(160, 240) to:CGPointMake(160, 720) duration:0.1 delegate:self removeCompeleted:NO];
    [putDown setValue:@"minify" forKey:@"AnimationKey"];
    [putDown setDelegate:self];
    [self.layer addAnimation:putDown forKey:@"minify"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag 
{
    NSString* value = [anim valueForKey:@"AnimationKey"];
    if ([value isEqualToString:@"minify"]) {
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [backButton release];
    [restartButton release];
    [resultImage release];
    [super dealloc];
}
@end
