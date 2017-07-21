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
    NSLog(@"Loading results...");
    
    [self loadCachedResults];
    
    NSLog(@"Downloading results...");
    
    NSData *resultsData = [NSData dataWithContentsOfURL: [NSURL URLWithString: RESULTS_DATA_URL]];
    
    [self didFetchResultsData: resultsData];
}

#pragma mark - Private Methods -

- (void)loadCachedResults
{
    NSLog(@"Loading cached results...");
    
    NSMutableArray *results = [[CCAppData instance] getCachedResults];
    
    if (!results)
    {
        NSLog(@"No results were cached. Loading default results file...");
        
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
    
    NSData *resultData = [data dataUsingEncoding: NSUTF8StringEncoding];
    
    results = [NSJSONSerialization JSONObjectWithData: resultData
                                              options: kNilOptions
                                                error: nil];
    
    return results;
}

- (void)didFetchResultsData: (NSData *)resultsData
{
    BOOL errorDownloading = YES;
    
    if (resultsData != nil)
    {
        NSError *error;
        NSMutableArray *results = [[NSMutableArray alloc] init];
        
        results = [NSJSONSerialization JSONObjectWithData: resultsData
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
    NSLog(@"Results loaded / fetched");
    
    if ([self.delegate respondsToSelector: @selector(didFetchResults:)])
    {
        [self.delegate didFetchResults: results];
    }
}

- (void)notifyDelegateOfErrorFetchingResults: (NSString *)error
{
    NSLog(@"Error fetching results: %@", error);
    
    if ([self.delegate respondsToSelector: @selector(didFailToFetchResults:)])
    {
        [self.delegate didFailToFetchResults: error];
    }
}

@end
