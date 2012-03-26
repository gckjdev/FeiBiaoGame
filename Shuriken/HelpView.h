//
//  HelpView.h
//  Shuriken
//
//  Created by Orange on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAAnimation.h>


@protocol HelpViewDelegate <NSObject>
@optional
- (void)clickOkButton;

@end

@interface HelpView : UIView {
    UIButton* _okButton; 
    id<HelpViewDelegate> _delegate;
}
@property (retain, nonatomic) IBOutlet UITextView *briefsContent;
@property (retain, nonatomic) IBOutlet UITextView *operationContent;

@property (retain, nonatomic) IBOutlet UIButton* okButton;
@property (assign, nonatomic) id<HelpViewDelegate> delegate;

+ (HelpView *)createHelpView;
+ (HelpView *)createHelpViewWithDelegate:(id<HelpViewDelegate>)aDelegate;

@end
