//
//  CCResultsViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCResultsViewController.h"
#import "Constants.h"
#import "UIImage+ImageEffects.h"

@interface CCResultsViewController ()

@end

@implementation CCResultsViewController

#pragma mark - View Controller Methods -

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(KEY_RESULTS_TITLE, nil);
	
	[self applyLightEffectToBackground];
	
	[CCResults instance].delegate = self;
	
	[[CCResults instance] downloadResults];
}

- (void)applyLightEffectToBackground
{
	UIImage *background = self.imgBackground.image;
	self.imgBackground.image = [background applyLightEffect];
}

#pragma mark - Results Data Methods -

- (void)didFetchResults: (NSMutableArray *)results
{
	self.results = results;
	[self.tableView reloadData];
}

- (void)didFailToFetchResults: (NSString *)error
{
	NSString *alertTitle = NSLocalizedString(KEY_ALERT_TITLE_CUPPY, nil);
	NSString *cancelButtonTitle = NSLocalizedString(KEY_ALERT_BUTTON_CANCEL, nil);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
													message: error
												   delegate: nil
										  cancelButtonTitle: cancelButtonTitle
										  otherButtonTitles: nil];
	[alert show];
}

#pragma mark - Table Methods -

- (UITableViewCell *)tableView: (UITableView *)tableView
		 cellForRowAtIndexPath: (NSIndexPath *)indexPath
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
	
	NSString *homeTeam = [NSString stringWithFormat: @"%@-Logo", [resultsDictionary objectForKey: JSON_KEY_HOME]];
	
	NSString *awayTeam = [NSString stringWithFormat: @"%@-Logo", [resultsDictionary objectForKey: JSON_KEY_AWAY]];
	
	NSString *dateAndVenue = [NSString stringWithFormat: @"%@ - %@",
							  [resultsDictionary objectForKey: JSON_KEY_DATE],
							  [resultsDictionary objectForKey: JSON_KEY_VENUE]];
	
	
	imgHomeTeamLogo.image		= [UIImage imageNamed: homeTeam];
	imgAwayTeamLogo.image		= [UIImage imageNamed: awayTeam];
	lblHomeGoals.text			= [resultsDictionary objectForKey: JSON_KEY_HOME_GOAL];
	lblAwayGoals.text			= [resultsDictionary objectForKey: JSON_KEY_AWAY_GOAL];
	lblDateAndVenue.text		= dateAndVenue;
	
	return cell;
}

- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
	return [self.results count];
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
	return 1;
}

@end
