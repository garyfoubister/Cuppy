//
//  CCAboutViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCAboutViewController.h"

@interface CCAboutViewController ()

@end

@implementation CCAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.lblTitle.text = NSLocalizedString(@"ABOUT_TITLE", nil);
	self.txtAbout.text = NSLocalizedString(@"ABOUT_TEXT", nil);

}

@end
