//
//  RecordManager.m
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecordManager.h"
#import "Record.h"

#define RECORD @"record"

static RecordManager* globalRecordManager;

static RecordManager* globalGetRecordManager()
{
    if (!globalRecordManager) {
        globalRecordManager = [[RecordManager alloc] init];
        [globalRecordManager loadRecord];
    }
    return globalRecordManager;
}

@implementation RecordManager
@synthesize recordArray = _recordArray;

+ (RecordManager*)shareInstance
{
    return globalGetRecordManager();
}

- (void)loadRecord
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* highScoreData = [userDefault objectForKey:RECORD];
    
    if (highScoreData) {
        NSMutableArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:highScoreData];
        self.recordArray = array;
    }
}


- (void)saveRecord
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* highScoreData = [NSKeyedArchiver archivedDataWithRootObject:self.recordArray];
    [userDefault setObject:highScoreData forKey:RECORD];
    [userDefault synchronize];
}

- (void)addResult:(NSInteger)aResult rivalName:(NSString*)aName date:(NSDate*)aDate
{
    if (!_recordArray) {
        _recordArray = [[NSMutableArray alloc] init];
    }
    Record* aGameResult = [[Record alloc] initWithDate:aDate rivalName:aName result:aResult];
    [self.recordArray addObject:aGameResult];
    [self saveRecord];
    
}

- (NSInteger)getWinCount
{
    int count = 0;
    for (Record* aRecord in self.recordArray) {
        if (aRecord.gameResult == WIN) {
            count ++;
        }
    }
    return count;
}
- (NSInteger)getLoseCount
{
    int count = 0;
    for (Record* aRecord in self.recordArray) {
        if (aRecord.gameResult == LOSE) {
            count ++;
        }
    }
    return count;
}
- (NSInteger)getFleeCount
{
    int count = 0;
    for (Record* aRecord in self.recordArray) {
        if (aRecord.gameResult == RUN_AWAY) {
            count ++;
        }
    }
    return count;
}

- (void)clearAllRecords
{
    [self.recordArray removeAllObjects];
    [self saveRecord];
}

@end
