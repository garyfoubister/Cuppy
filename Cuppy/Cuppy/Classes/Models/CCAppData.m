//
//  CCAppData.m
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCAppData.h"
#import "Constants.h"

@implementation CCAppData

#pragma mark - Lifecycle

static CCAppData *instance = nil;
+ (CCAppData *) instance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[CCAppData alloc] init];
    });
    
    return instance;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

#pragma mark - Standings -

- (NSMutableArray *)getCachedStandings
{
    NSData *cachedStandingsData = [self.userDefaults objectForKey: KEY_CACHED_STANDINGS];
    return (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: cachedStandingsData];
}

- (void)saveCachedStandings: (NSMutableArray *)standings
{
    [self saveStandingslastUpdate];
    
    NSData *standingsData = [NSKeyedArchiver archivedDataWithRootObject: standings];
    [self.userDefaults setValue: standingsData forKey: KEY_CACHED_STANDINGS];
    [self.userDefaults synchronize];
}

- (NSString *)getStandingsLastUpdated
{
    NSString *lastUpdated = [self.userDefaults stringForKey: KEY_STANDINGS_LAST_UPDATED];
    return lastUpdated;
}

- (void) saveStandingslastUpdate
{
    [self.userDefaults setValue: [self getCurrentDateAndTimeAsString] forKey: KEY_STANDINGS_LAST_UPDATED];
    [self.userDefaults synchronize];
}

#pragma mark - Results -

- (NSMutableArray *)getCachedResults
{
    NSData *cachedResultsData = [self.userDefaults objectForKey: KEY_CACHED_RESULTS];
    return (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData: cachedResultsData];
}

- (void)saveCachedResults: (NSMutableArray *)results
{
    [self saveResultslastUpdate];
    
    NSData *resultsData = [NSKeyedArchiver archivedDataWithRootObject: results];
    [self.userDefaults setValue: resultsData forKey: KEY_CACHED_RESULTS];
    [self.userDefaults synchronize];
}

- (NSString *)getResultsLastUpdated
{
    NSString *lastUpdated = [self.userDefaults stringForKey: KEY_RESULTS_LAST_UPDATED];
    return lastUpdated;
}

- (void) saveResultslastUpdate
{
    [self.userDefaults setValue: [self getCurrentDateAndTimeAsString] forKey: KEY_RESULTS_LAST_UPDATED];
    [self.userDefaults synchronize];
}

#pragma mark - Date -

- (NSString *)getCurrentDateAndTimeAsString
{
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat: @"YYYY-MM-dd hh:mm:ss a"];
    
    NSString *formattedDateString = [dateformater stringFromDate: [NSDate date]];
    
    return formattedDateString;
}

@end
