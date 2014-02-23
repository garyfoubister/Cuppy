//
//  CCResultsViewController.h
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCResults.h"

@interface CCResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CCResultsDelegate>

@property (nonatomic,strong) NSMutableArray	*results;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
