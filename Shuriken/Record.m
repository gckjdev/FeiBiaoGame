//
//  Record.m
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize date = _date;
@synthesize rivalName = _rivalName;
@synthesize gameResult = _gameResult;

- (void)dealloc 
{
    [_date release];
    [_rivalName release];
    [super dealloc];
}

- (id)initWithDate:(NSDate *)aDate rivalName:(NSString *)aName result:(NSInteger)aResult
{
    self = [super init];
    if (self) {
        self.date = aDate;
        self.rivalName = aName;
        self.gameResult = aResult;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.rivalName = [aDecoder decodeObjectForKey:@"name"];
        self.date = [aDecoder decodeObjectForKey:@"gameDate"];
        self.gameResult = [aDecoder decodeIntForKey:@"gameResult"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.rivalName forKey:@"name"];
    [aCoder encodeObject:self.date forKey:@"gameDate"];
    [aCoder encodeInt:self.gameResult forKey:@"gameResult"];
}

@end
