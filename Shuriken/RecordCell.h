//
//  RecordCell.h
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Record;

@interface RecordCell : UITableViewCell

+ (RecordCell *)createRecordCell;
+ (NSString*)getCellIdentifier;
- (void)setCellWithRecord:(Record*)aRecord;
@end
