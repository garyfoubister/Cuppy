//
//  CCViewController.h
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCViewController : UIViewController <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator		*animator;
@property (nonatomic, strong) UIGravityBehavior		*gravity;
@property (nonatomic, strong) UISnapBehavior		*snap;

@property (nonatomic, strong) NSMutableArray		*views;

@property (weak, nonatomic) IBOutlet UIImageView	*imgBackgroundBottom;
@property (weak, nonatomic) IBOutlet UIImageView	*imgBackgroundTop;

@end
