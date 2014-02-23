//
//  CCStandingsViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCStandingsViewController.h"
#import "Constants.h"
#import "UIImage+ImageEffects.h"

@interface CCStandingsViewController ()
@end

@implementation CCStandingsViewController

#pragma mark - View Controller Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(KEY_STANDINGS_TITLE, nil);
	[self applyLightEffectToBackground];
	
	[CCStandings instance].delegate = self;
	
	[[CCStandings instance] downloadStandings];
}

- (void)applyLightEffectToBackground
{
	UIImage *background = self.imgBackground.image;
	self.imgBackground.image = [background applyLightEffect];
}

#pragma mark - Standings Data Methods -

- (void)didFetchStandings: (NSMutableArray *)standings
{
	self.standings = standings;
	[self.tableView reloadData];
}

- (void)didFailToFetchStandings: (NSString *)error
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

	UIImageView *imgTeamLogo	= (UIImageView *)[cell viewWithTag:100];
	UILabel *lblPlayed			= (UILabel *)[cell viewWithTag: 101];
	UILabel *lblWon				= (UILabel *)[cell viewWithTag: 102];
	UILabel *lblLost			= (UILabel *)[cell viewWithTag: 103];
	UILabel *lblDrawn			= (UILabel *)[cell viewWithTag: 104];
	UILabel *lblGoalDifference	= (UILabel *)[cell viewWithTag: 105];
	UILabel *lblPoints			= (UILabel *)[cell viewWithTag: 106];
	
	if (indexPath.row == 0)
	{
		imgTeamLogo.image		= nil;

		lblPlayed.text			= NSLocalizedString(KEY_STANDINGS_HEADER_PLAYED, nil);
		lblWon.text				= NSLocalizedString(KEY_STANDINGS_HEADER_WON, nil);
		lblLost.text			= NSLocalizedString(KEY_STANDINGS_HEADER_LOST, nil);
		lblDrawn.text			= NSLocalizedString(KEY_STANDINGS_HEADER_DRAWN, nil);
		lblGoalDifference.text	= NSLocalizedString(KEY_STANDINGS_HEADER_GOAL_DIFFERENCE, nil);
		lblPoints.text			= NSLocalizedString(KEY_STANDINGS_HEADER_POINTS, nil);
		
	}
	else
	{
		NSDictionary *standingDictionary = [self.standings objectAtIndex: indexPath.row - 1];
		NSString *team = [NSString stringWithFormat: @"%@-Logo", [standingDictionary objectForKey: JSON_KEY_TEAM]];
		
		imgTeamLogo.image		= [UIImage imageNamed: team];
		lblPlayed.text			= [standingDictionary objectForKey: JSON_KEY_PLAYED];
		lblWon.text				= [standingDictionary objectForKey: JSON_KEY_WON];
		lblLost.text			= [standingDictionary objectForKey: JSON_KEY_LOST];
		lblDrawn.text			= [standingDictionary objectForKey: JSON_KEY_DRAWN];
		lblGoalDifference.text	= [standingDictionary objectForKey: JSON_KEY_GOAL_DIFFERENCE];
		lblPoints.text			= [standingDictionary objectForKey: JSON_KEY_POINTS];

	}
	
	return cell;
}


- (NSInteger)tableView: (UITableView *)tableView
 numberOfRowsInSection: (NSInteger)section
{
	return [self.standings count] + 1;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView *)tableView
{
    return 1;
}

@end
