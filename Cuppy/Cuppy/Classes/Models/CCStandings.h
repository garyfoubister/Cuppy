//
//  CCStandings.h
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Delegate

@protocol CCStandingsDelegate <NSObject>

@required

- (void)didFetchStandings: (NSMutableArray *)standings;

- (void)didFailToFetchStandings: (NSString *)error;

@optional

@end

#pragma mark - Interface - 

@interface CCStandings : NSObject

@property (weak) id <CCStandingsDelegate> delegate;

+ (CCStandings *) instance;

- (void)downloadStandings;

@end
