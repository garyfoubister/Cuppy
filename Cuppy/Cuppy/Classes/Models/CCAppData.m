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
	NSData *standingsData = [NSKeyedArchiver archivedDataWithRootObject: standings];
	[self.userDefaults setValue: standingsData forKey: KEY_CACHED_STANDINGS];
	[self.userDefaults synchronize];
}

- (NSString *)getStandingsLastUpdated
{
	NSString *lastUpdated = [self.userDefaults stringForKey: KEY_STANDINGS_LAST_UPDATED];
	return lastUpdated;
}

- (void) saveStandingslastUpdate: (NSString *)lastUpdated
{
	[self.userDefaults setValue: lastUpdated forKey: KEY_STANDINGS_LAST_UPDATED];
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
	NSData *resultsData = [NSKeyedArchiver archivedDataWithRootObject: results];
	[self.userDefaults setValue: resultsData forKey: KEY_CACHED_RESULTS];
	[self.userDefaults synchronize];
}

@end
