//
//  CCResults.m
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCResults.h"

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

- (void)loadCachedResults
{
	
}

- (void)downloadResults
{
	
}

@end
