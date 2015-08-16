//
//  CCResults.m
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCResults.h"
#import "CCAppData.h"
#import "Constants.h"

@implementation CCResults

#pragma mark - Lifecycle

static CCResults *instance = nil;
+ (CCResults *) instance
{
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		instance = [[CCResults alloc] init];
	});
	
	return instance;
}

#pragma mark - Public Methods -

- (void)downloadResults
{
	[self loadCachedResults];
	
	// TODO: Download the results from service
}

#pragma mark - Private Methods -

- (void)loadCachedResults
{
	NSMutableArray *results;
	NSString *resultsLastUpdated = [[CCAppData instance] getResultsLastUpdated];
	
	if (resultsLastUpdated)
	{
		results = [[CCAppData instance] getCachedResults];
	}
	else
	{
		results = [self loadResultsFromFile];
	}
	
	[self notifyDelegateResultsWereFetched: results];
}

- (NSMutableArray *)loadResultsFromFile
{
	NSMutableArray *results = [[NSMutableArray alloc] init];
	
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Results"
                                                     ofType: @"json"];
	
    NSString *data = [NSString stringWithContentsOfFile: path
                                               encoding: NSUTF8StringEncoding
                                                  error: nil];
    
    NSData *resultData = [data dataUsingEncoding:NSUTF8StringEncoding];
	
    results = [NSJSONSerialization JSONObjectWithData: resultData
											  options: kNilOptions
												error: nil];
	
	return results;
}

- (void)didFetchResultsData: (NSData *)reultsData
{
	BOOL errorDownloading = YES;
	
	if (reultsData != nil)
	{
		NSError *error;
		NSMutableArray *results = [[NSMutableArray alloc] init];
		
		results = [NSJSONSerialization JSONObjectWithData: reultsData
												  options: kNilOptions
													error: &error];
		if (error == nil)
		{
			errorDownloading = NO;
			
			[[CCAppData instance] saveCachedResults: results];
			
			[self notifyDelegateResultsWereFetched: results];
		}
	}
	
	if (errorDownloading)
	{
		[self notifyDelegateOfErrorFetchingResults: NSLocalizedString(KEY_ERROR_DOWNLOADING_RESULTS, nil)];
	}
}

- (void)notifyDelegateResultsWereFetched: (NSMutableArray *)results
{
	if ([self.delegate respondsToSelector: @selector(didFetchResults:)])
	{
		[self.delegate didFetchResults: results];
	}
}

- (void)notifyDelegateOfErrorFetchingResults: (NSString *)error
{
	if ([self.delegate respondsToSelector: @selector(didFailToFetchResults:)])
	{
		[self.delegate didFailToFetchResults: error];
	}
}

@end
