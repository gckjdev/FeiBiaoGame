//
//  Record.h
//  Shuriken
//
//  Created by Orange on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject <NSCoding>{
    
}

@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) NSString* rivalName;
@property (nonatomic, assign) NSInteger gameResult;
- (id)initWithDate:(NSDate *)aDate rivalName:(NSString *)aName result:(NSInteger)aResult;
@end
