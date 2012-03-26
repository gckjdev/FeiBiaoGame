//
//  RecordController.h
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FontLabel;

@interface RecordController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
    
}
@property (retain, nonatomic) IBOutlet UITableView *records;
@property (retain, nonatomic) IBOutlet UIButton *clearRecordsButton;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
@property (retain, nonatomic) FontLabel *winsTitle;
@property (retain, nonatomic) FontLabel *loseTitle;
@property (retain, nonatomic) FontLabel *fleeTitle;
@property (retain, nonatomic) FontLabel *winCount;
@property (retain, nonatomic) FontLabel *loseCount;
@property (retain, nonatomic) FontLabel *fleeCount;

@end
