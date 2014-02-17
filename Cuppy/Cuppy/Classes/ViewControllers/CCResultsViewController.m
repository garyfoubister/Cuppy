//
//  CCResultsViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCResultsViewController.h"

@interface CCResultsViewController ()

@end

@implementation CCResultsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(@"RESULTS_TITLE", nil);
	
	[self loadResults];
}

#pragma mark - Data Methods -

- (void)loadResults
{
	self.results = [[NSMutableArray alloc] init];
	
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Results"
                                                     ofType: @"json"];
	
    NSString *data = [NSString stringWithContentsOfFile: path
                                               encoding: NSUTF8StringEncoding
                                                  error: nil];
    
    NSData *resultData = [data dataUsingEncoding: NSUTF8StringEncoding];
	
    self.results = [NSJSONSerialization JSONObjectWithData: resultData
												   options: kNilOptions
													 error: nil];
}

#pragma mark - Table Methods -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
	}
	
	UIImageView *imgHomeTeamLogo	= (UIImageView *)[cell viewWithTag:101];
	UILabel *lblHomeGoals			= (UILabel *)[cell viewWithTag: 102];
	UILabel *lblAwayGoals			= (UILabel *)[cell viewWithTag: 103];
	UIImageView *imgAwayTeamLogo	= (UIImageView *)[cell viewWithTag:104];
	UILabel *lblDateAndVenue		= (UILabel *)[cell viewWithTag: 105];
	

	NSDictionary *resultsDictionary = [self.results objectAtIndex: indexPath.row];
	
	NSString *homeTeam = [NSString stringWithFormat: @"%@-Logo", [resultsDictionary objectForKey: @"Home"]];
	
	NSString *awayTeam = [NSString stringWithFormat: @"%@-Logo", [resultsDictionary objectForKey: @"Away"]];
	
	NSString *dateAndVenue = [NSString stringWithFormat: @"%@ - %@",
							  [resultsDictionary objectForKey: @"Date"],
							  [resultsDictionary objectForKey: @"Venue"]];
		

	imgHomeTeamLogo.image		= [UIImage imageNamed: homeTeam];
	imgAwayTeamLogo.image		= [UIImage imageNamed: awayTeam];
	lblHomeGoals.text			= [resultsDictionary objectForKey: @"HomeGoals"];
	lblAwayGoals.text			= [resultsDictionary objectForKey: @"AwayGoals"];
	lblDateAndVenue.text		= dateAndVenue;
	
	return cell;
}


@end
