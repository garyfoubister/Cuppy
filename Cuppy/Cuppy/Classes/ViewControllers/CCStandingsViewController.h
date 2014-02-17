//
//  CCStandingsViewController.h
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCStandings.h"

@interface CCStandingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CCStandingsDelegate>

@property (nonatomic,strong) NSMutableArray	*standings;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
