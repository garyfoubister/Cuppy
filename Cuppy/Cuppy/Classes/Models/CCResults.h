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

- (void)didFetchResults: (NSMutableArray *)results;

- (void)didFailToFetchResults: (NSString *)error;

@optional

@end

@interface CCResults : NSObject

@property (weak) id <CCResultsDelegate> delegate;

+ (CCResults *) instance;

- (void)downloadResults;

@end
