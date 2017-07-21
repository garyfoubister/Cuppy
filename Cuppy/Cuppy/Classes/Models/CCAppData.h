//
//  CCAppData.h
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCAppData : NSObject

@property (strong, nonatomic) NSUserDefaults *userDefaults;

+ (CCAppData *)instance;

- (NSMutableArray *)getCachedStandings;
- (void)saveCachedStandings: (NSMutableArray *)standings;

- (NSMutableArray *)getCachedResults;
- (void)saveCachedResults: (NSMutableArray *)results;



@end
