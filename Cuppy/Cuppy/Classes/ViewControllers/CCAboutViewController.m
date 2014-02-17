//
//  CCAboutViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCAboutViewController.h"
#import "Constants.h"

@interface CCAboutViewController ()

@end

@implementation CCAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(KEY_ABOUT_TITLE, nil);
	self.txtAbout.text = NSLocalizedString(KEY_ABOUT_TEXT, nil);
}

@end
