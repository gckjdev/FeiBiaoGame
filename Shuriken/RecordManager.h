//
//  RecordManager.h
//  Shuriken
//
//  Created by Orange on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
enum GAME_RESULT {
    WIN = 1,
    LOSE = 0,
    RUN_AWAY = -1
};

@interface RecordManager : NSObject {
    NSMutableArray* _recordArray;
}

@property (retain, nonatomic) NSMutableArray* recordArray;

+ (RecordManager*)shareInstance;
- (void)addResult:(NSInteger)aResult rivalName:(NSString*)aName date:(NSDate*)aDate;
- (void)loadRecord;
- (NSInteger)getWinCount;
- (NSInteger)getLoseCount;
- (NSInteger)getFleeCount;
- (void)clearAllRecords;

@end
