//
//  Constants.h
//  Cuppy
//
//  Created by Gary Foubister on 2/16/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#ifndef Cuppy_Constants_h
#define Cuppy_Constants_h

#define BACKGROUND_QUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#pragma mark - App Data Keys -

#define KEY_RESULTS_LAST_UPDATED				@"KeyResultsLastUpdated"
#define KEY_CACHED_RESULTS						@"KeyCachedResults"

#define KEY_STANDINGS_LAST_UPDATED				@"KeyStandingsLastUpdated"
#define KEY_CACHED_STANDINGS					@"KeyCachedStandings"



#pragma mark - Localizations Keys -

#define KEY_ALERT_TITLE_CUPPY					@"ALERT_TITLE_CUPPY"
#define KEY_ALERT_BUTTON_CANCEL					@"ALERT_BUTTON_CANCEL"

#define KEY_STANDINGS_TITLE						@"STANDINGS_TITLE"
#define KEY_STANDINGS_HEADER_PLAYED				@"STANDINGS_HEADER_PLAYED"
#define KEY_STANDINGS_HEADER_WON				@"STANDINGS_HEADER_WON"
#define KEY_STANDINGS_HEADER_LOST				@"STANDINGS_HEADER_LOST"
#define KEY_STANDINGS_HEADER_DRAWN				@"STANDINGS_HEADER_DRAWN"
#define KEY_STANDINGS_HEADER_GOAL_DIFFERENCE	@"STANDINGS_HEADER_GOAL_DIFFERENCE"
#define KEY_STANDINGS_HEADER_POINTS				@"STANDINGS_HEADER_POINTS"
#define KEY_ERROR_DOWNLOADING_STANDINGS			@"ERROR_DOWNLOADING_STANDINGS"

#define KEY_RESULTS_TITLE						@"RESULTS_TITLE"
#define KEY_ERROR_DOWNLOADING_RESULTS			@"ERROR_DOWNLOADING_RESULTS"

#define KEY_ABOUT_TITLE							@"ABOUT_TITLE"
#define KEY_ABOUT_TEXT							@"ABOUT_TEXT"

#pragma mark - JSON Keys -

#define JSON_KEY_TEAM							@"Team"
#define JSON_KEY_PLAYED							@"Played"
#define JSON_KEY_WON							@"Won"
#define JSON_KEY_LOST							@"Lost"
#define JSON_KEY_DRAWN							@"Drawn"
#define JSON_KEY_GOAL_DIFFERENCE				@"GoalDifference"
#define JSON_KEY_POINTS							@"Points"

#define JSON_KEY_HOME							@"Home"
#define JSON_KEY_AWAY							@"Away"
#define JSON_KEY_DATE							@"Date"
#define JSON_KEY_VENUE							@"Venue"
#define JSON_KEY_HOME_GOAL						@"HomeGoals"
#define JSON_KEY_AWAY_GOAL						@"AwayGoals"

#endif
