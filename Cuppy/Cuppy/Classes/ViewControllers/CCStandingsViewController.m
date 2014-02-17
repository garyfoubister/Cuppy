//
//  CCStandingsViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCStandingsViewController.h"
#import "Constants.h"

@interface CCStandingsViewController ()
@end

@implementation CCStandingsViewController

#pragma mark - View Controller Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(@"STANDINGS_TITLE", nil);
	
	[CCStandings instance].delegate = self;
	
	[[CCStandings instance] downloadStandings];
}

#pragma mark - Standings Data Methods -

- (void)didFetchStandings: (NSMutableArray *)standings
{
	self.standings = standings;
	[self.tableView reloadData];
}

- (void)didFailToFetchStandings: (NSString *)error
{
	// TODO: Notify the user there was a problem downloading the Standings
}

#pragma mark - Table Methods -

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

		lblPlayed.text			= NSLocalizedString(@"STANDINGS_HEADER_PLAYED", nil);
		lblWon.text				= NSLocalizedString(@"STANDINGS_HEADER_WON", nil);
		lblLost.text			= NSLocalizedString(@"STANDINGS_HEADER_LOST", nil);
		lblDrawn.text			= NSLocalizedString(@"STANDINGS_HEADER_DRAWN", nil);
		lblGoalDifference.text	= NSLocalizedString(@"STANDINGS_HEADER_GOAL_DIFFERENCE", nil);
		lblPoints.text			= NSLocalizedString(@"STANDINGS_HEADER_POINTS", nil);
		
	}
	else
	{
		NSDictionary *standingDictionary = [self.standings objectAtIndex: indexPath.row - 1];
		NSString *team = [NSString stringWithFormat: @"%@-Logo", [standingDictionary objectForKey: @"Team"]];
		
		imgTeamLogo.image		= [UIImage imageNamed: team];
		lblPlayed.text			= [standingDictionary objectForKey: @"Played"];
		lblWon.text				= [standingDictionary objectForKey: @"Won"];
		lblLost.text			= [standingDictionary objectForKey: @"Lost"];
		lblDrawn.text			= [standingDictionary objectForKey: @"Drawn"];
		lblGoalDifference.text	= [standingDictionary objectForKey: @"GoalDifference"];
		lblPoints.text			= [standingDictionary objectForKey: @"Points"];

	}
	
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.standings count] + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
