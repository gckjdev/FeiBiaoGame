//
//  RecordCell.m
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordCell.h"
#import "Record.h"
#import "TimeUtils.h"

@implementation RecordCell

- (void)setCellWithRecord:(Record*)aRecord
{
    switch (aRecord.gameResult) {
        case 1:
            [self.textLabel setText:[NSString stringWithFormat:@"defeated %@ at %@", aRecord.rivalName, dateToString(aRecord.date)]];
            break;
        case 0:
            [self.textLabel setText:[NSString stringWithFormat:@"%@ defeated you at %@", aRecord.rivalName, dateToString(aRecord.date)]];
            break;
        case -1:
            [self.textLabel setText:[NSString stringWithFormat:@"you ran away at %@!", dateToString(aRecord.date)]];
            break;
            
        default:
            break;
    }
}

+ (RecordCell *)createRecordCell
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RecordCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <RecordCell> but cannot find cell object from Nib");
        return nil;
    }
    RecordCell* cell =  (RecordCell*)[topLevelObjects objectAtIndex:0];

    return cell;
    
}

+ (NSString*)getCellIdentifier
{
    return @"RecordCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
