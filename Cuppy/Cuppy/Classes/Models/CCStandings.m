//
//  CCStandings.m
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCStandings.h"
#import "CCAppData.h"
#import "Constants.h"

@interface CCStandings()
@end

@implementation CCStandings

#pragma mark - Lifecycle

static CCStandings *instance = nil;
+ (CCStandings *) instance
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		instance = [[CCStandings alloc] init];
	});
	
	return instance;
}

#pragma mark - Public Methods - 

- (void)downloadStandings
{
	[self loadCachedStandings];
	
	// TODO: Download the Standings when the endpoint is available
			
//	dispatch_async(BACKGROUND_QUEUE, ^{
//		
//        NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString: URL_STANDINGS]];
//        
//		[self performSelectorOnMainThread: @selector(didFetchStandingsData:)
//							   withObject: data
//							waitUntilDone: YES];
//    });
}

#pragma mark - Private Methods -

- (void)loadCachedStandings
{
	NSMutableArray *standings;
	NSString *standingsLastUpdated = [[CCAppData instance] getStandingsLastUpdated];
	
	if (standingsLastUpdated)
	{
		standings = [[CCAppData instance] getCachedStandings];
	}
	else
	{
		standings = [self loadStandingsFromFile];
	}
		
	[self notifyDelegateStandingsWereFetched: standings];
}

- (NSMutableArray *)loadStandingsFromFile
{
	NSMutableArray *standings = [[NSMutableArray alloc] init];
	
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Standings"
                                                     ofType: @"json"];
	
    NSString *data = [NSString stringWithContentsOfFile: path
                                               encoding: NSUTF8StringEncoding
                                                  error: nil];
    
    NSData *resultData = [data dataUsingEncoding:NSUTF8StringEncoding];
	
    standings = [NSJSONSerialization JSONObjectWithData: resultData
												options: kNilOptions
												  error: nil];
	
	return standings;
}

- (void)didFetchStandingsData: (NSData *)standingsData
{
	BOOL errorDownloading = YES;
	
	if (standingsData != nil)
	{
		NSError *error;
		NSMutableArray *standings = [[NSMutableArray alloc] init];
		
		standings = [NSJSONSerialization JSONObjectWithData: standingsData
													options: kNilOptions
													  error: &error];
		if (error == nil)
		{
			errorDownloading = NO;
			
			[[CCAppData instance] saveCachedStandings: standings];

			[self notifyDelegateStandingsWereFetched: standings];
		}
	}
	
	if (errorDownloading)
	{
		[self notifyDelegateOfErrorFetchingStandings: NSLocalizedString(KEY_ERROR_DOWNLOADING_STANDINGS, nil)];
	}
}

- (void)notifyDelegateStandingsWereFetched: (NSMutableArray *)standings
{
	if ([self.delegate respondsToSelector: @selector(didFetchStandings:)])
	{
		[self.delegate didFetchStandings: standings];
	}
}

- (void)notifyDelegateOfErrorFetchingStandings: (NSString *)error
{
	if ([self.delegate respondsToSelector: @selector(didFailToFetchStandings:)])
	{
		[self.delegate didFailToFetchStandings: error];
	}
}

@end
