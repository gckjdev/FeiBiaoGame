//
//  RecordController.h
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}
@property (retain, nonatomic) IBOutlet UITableView *records;

@end
