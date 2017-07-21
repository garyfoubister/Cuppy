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
    NSLog(@"Loading standings...");
    
    [self loadCachedStandings];

    NSLog(@"Downloading standings...");
    
    NSData *standingsData = [NSData dataWithContentsOfURL: [NSURL URLWithString: STANDINGS_DATA_URL]];
    
    [self didFetchStandingsData: standingsData];
    
}

#pragma mark - Private Methods -

- (void)loadCachedStandings
{
    NSLog(@"Loading cached standings...");
    
    NSMutableArray *standings = [[CCAppData instance] getCachedStandings];
    
    if (!standings)
    {
        NSLog(@"No standings were cached. Loading default standings file...");
        
        standings = [self loadDefaultStandingsFromFile];
    }
    
    [self notifyDelegateStandingsWereFetched: standings];
}


- (NSMutableArray *)loadDefaultStandingsFromFile
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
    NSLog(@"Standings loaded / fetched");
    
    if ([self.delegate respondsToSelector: @selector(didFetchStandings:)])
    {
        [self.delegate didFetchStandings: standings];
    }
}

- (void)notifyDelegateOfErrorFetchingStandings: (NSString *)error
{
    NSLog(@"Error fetching standings: %@", error);
    
    if ([self.delegate respondsToSelector: @selector(didFailToFetchStandings:)])
    {
        [self.delegate didFailToFetchStandings: error];
    }
}

@end
