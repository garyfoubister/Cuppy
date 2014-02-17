//
//  CCResults.h
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCResultsDelegate <NSObject>

@required

- (void)didFetchResults: (NSMutableArray *)standings;

@optional

@end

@interface CCResults : NSObject

+ (CCResults *) instance;

- (void)loadCachedResults;

- (void)downloadResults;

@end
