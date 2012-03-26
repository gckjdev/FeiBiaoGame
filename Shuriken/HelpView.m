//
//  HelpView.m
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpView.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationManager.h"
#import "CustomLabelUtil.h"


@implementation HelpView
@synthesize briefsContent = _briefsContent;
@synthesize operationContent = _operationContent;
@synthesize okButton = _okButton;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_okButton release];
    [_briefsContent release];
    [_operationContent release];
    [super dealloc];
}

- (void)initTitles
{
    [CustomLabelUtil creatWithFrame:CGRectMake(130, 20, 60, 40) pointSize:23 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"HELP", @"帮助") shadow:YES bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(51, 49, 69, 21) pointSize:18 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"Briefs", @"简介") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(51, 158, 96, 21) pointSize:18 alignment:UITextAlignmentLeft textColor:[UIColor blackColor] addTo:self text:NSLocalizedString(@"Operate", @"操作") shadow:NO bold:YES];
    [CustomLabelUtil creatWithFrame:CGRectMake(0, 0, 91, 50) pointSize:18 alignment:UITextAlignmentCenter textColor:[UIColor blackColor] addTo:self.okButton text:NSLocalizedString(@"Back", @"退出") shadow:NO bold:NO];
}

+ (HelpView *)createHelpView
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HelpView" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <HelpView> but cannot find cell object from Nib");
        return nil;
    }
    HelpView* view =  (HelpView*)[topLevelObjects objectAtIndex:0];
    [view initTitles];
    CAAnimation *runIn = [AnimationManager translationAnimationFrom:CGPointMake(160, 720) to:CGPointMake(160, 240) duration:0.3 delegate:self removeCompeleted:NO];
    //CAAnimation *rollAnimation = [AnimationManager rotationAnimationWithRoundCount:-3 duration:0.5];
    [view.layer addAnimation:runIn forKey:@"runIn"];
    return view;
    
}

+ (HelpView *)createHelpViewWithDelegate:(id<HelpViewDelegate>)aDelegate
{
    HelpView* view = [HelpView createHelpView];
    view.delegate = aDelegate;
    return view;
    
}

- (IBAction)clickOk:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(clickOkButton)]) {
        [_delegate clickOkButton];
    }
    CAAnimation *runOut = [AnimationManager translationAnimationFrom:CGPointMake(160, 240) to:CGPointMake(160, 720) duration:0.1 delegate:self removeCompeleted:NO];
    // CAAnimation *rollAnimation = [AnimationManager rotationAnimationWithRoundCount:3 duration:0.5];
    [runOut setValue:@"runOut" forKey:@"AnimationKey"];
    [runOut setDelegate:self];
    [self.layer addAnimation:runOut forKey:@"runOut"];
    //[_contentView.layer addAnimation:rollAnimation forKey:@"rolling"];
    //[self removeFromSuperview];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSString* value = [anim valueForKey:@"AnimationKey"];
    if ([value isEqualToString:@"runOut"]) {
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

@end
