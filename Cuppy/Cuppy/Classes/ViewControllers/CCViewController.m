//
//  CCViewController.m
//  Cuppy
//
//  Created by Gary Foubister on 2/15/14.
//  Copyright (c) 2014 Silver Shine, LLC. All rights reserved.
//

#import "CCViewController.h"
#import "CCStandingsViewController.h"

@interface CCViewController ()
{
    CGPoint _previousTouchPoint;
    BOOL    _draggingView;
    BOOL    _viewDocked;
}

@end

@implementation CCViewController

#pragma mark - View Controller Methods -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addMotionEffects];
    
    [self addDynamicAnimatorAndGravityBehaviorsToView];
    
    [self addStandingsResultsAndAboutViews];
}

#pragma mark - Motions Effects -

- (void) addMotionEffects
{
    [self addMotionEffectToView: self.imgBackgroundTop magnitude: 20.0f];
}

- (void)addMotionEffectToView: (UIView *)view magnitude: (CGFloat)magnitude
{
    UIInterpolatingMotionEffect *xMotion =
    [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.x"
                                                    type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xMotion.minimumRelativeValue = @(-magnitude);
    xMotion.maximumRelativeValue = @(magnitude);
    
    UIInterpolatingMotionEffect *yMotion =
    [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.y"
                                                    type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yMotion.minimumRelativeValue = @(-magnitude);
    yMotion.maximumRelativeValue = @(magnitude);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotion, yMotion];
    
    [view addMotionEffect: group];
}

#pragma mark - Dynamic Animator And Gravity  -

- (void) addDynamicAnimatorAndGravityBehaviorsToView
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView: self.view];
    self.gravity = [[UIGravityBehavior alloc] init];
    
    [self.animator addBehavior: self.gravity];
    
    self.gravity.magnitude = 4.0f;
}

#pragma mark - Views

- (void)addStandingsResultsAndAboutViews
{
    self.views = [NSMutableArray new];
    
    [self addStandings];
    [self addResults];
    [self addAbout];
}

- (void)addStandings
{
    UIViewController *standings = [self instantiateViewControllerWithIdentifier: @"Standings"];
    [self.views addObject: [self addViewController: standings atOffset: 210.0f]];
}

- (void)addResults
{
    UIViewController *standings = [self instantiateViewControllerWithIdentifier: @"Results"];
    [self.views addObject: [self addViewController: standings atOffset: 140.0f]];
}

- (void)addAbout
{
    UIViewController *standings = [self instantiateViewControllerWithIdentifier: @"About"];
    [self.views addObject: [self addViewController: standings atOffset: 70.0f]];
}

- (UIViewController *)instantiateViewControllerWithIdentifier: (NSString *)identifier
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier: identifier];
    return viewController;
}

- (UIView *)addViewController: (UIViewController *)viewController
                     atOffset: (CGFloat)offset
{
    CGRect frameForView = CGRectOffset(self.view.bounds, 0.0, self.view.bounds.size.height - offset);
    
    UIView *view = viewController.view;
    view.frame = frameForView;
    
    [self addChildViewController: viewController];
    [self.view addSubview: viewController.view];
    [viewController didMoveToParentViewController: self];
    
    // Add a gesture recognizer
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(handlePan:)];
    [viewController.view addGestureRecognizer: pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleTap:)];
    [viewController.view addGestureRecognizer: tap];
    
    // Create a collision
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems: @[view]];
    [self.animator addBehavior: collision];
    
    // Lower boundary where the tab rests
    CGFloat boundary = view.frame.origin.y + view.frame.size.height + 1;
    CGPoint boundaryStart = CGPointMake(0.0, boundary);
    CGPoint boundaryEnd = CGPointMake(self.view.bounds.size.width, boundary);
    [collision addBoundaryWithIdentifier: @1 fromPoint: boundaryStart toPoint: boundaryEnd];
    
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(self.view.bounds.size.width, 0.0);
    [collision addBoundaryWithIdentifier: @2 fromPoint: boundaryStart toPoint: boundaryEnd];
    
    collision.collisionDelegate = self;
    
    // Apply gravity
    [self.gravity addItem: view];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems: @[view]];
    [self.animator addBehavior: itemBehavior];
    
    return view;
}

#pragma mark - Gesture Events -

- (void)handlePan: (UIPanGestureRecognizer *)gesture
{
    CGPoint touchPoint = [gesture locationInView: self.view];
    
    UIView *draggedView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint dragStartLocation = [gesture locationInView: draggedView];
        
        if (dragStartLocation.y < 200.0f)
        {
            _draggingView = YES;
            
            _previousTouchPoint = touchPoint;
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView)
    {
        CGFloat yOffset = _previousTouchPoint.y - touchPoint.y;
        
        gesture.view.center = CGPointMake(draggedView.center.x, draggedView.center.y - yOffset);
        
        _previousTouchPoint	= touchPoint;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView)
    {
        [self tryToDockView: draggedView];
        
        [self addVelocityToView: draggedView fromGesture: gesture];
        
        [self.animator updateItemUsingCurrentState: draggedView];
        
        _draggingView = NO;
    }
}

- (void)handleTap: (UITapGestureRecognizer *)gesture
{
    UIView *tappedView = gesture.view;
    
    if (_viewDocked)
    {
        [self.animator removeBehavior: self.snap];
        
        [self setAlphaWhenIsViewDocked: tappedView alpha: 1.0];
        
        _viewDocked = NO;
    }
}

#pragma mark - Gesture Events -

- (void)tryToDockView: (UIView *)view
{
    BOOL viewHasReachedDockLocation = view.frame.origin.y < 100.0;
    
    if (viewHasReachedDockLocation)
    {
        if (!_viewDocked)
        {
            CGPoint dockPoint = CGPointMake(self.view.center.x, self.view.center.y + 20);
            
            self.snap = [[UISnapBehavior alloc] initWithItem: view snapToPoint: dockPoint];
            
            [self.animator addBehavior: self.snap];
            
            [self setAlphaWhenIsViewDocked: view alpha: 0.0];
            
            _viewDocked = YES;
        }
    }
    else
    {
        if (_viewDocked)
        {
            [self.animator removeBehavior: self.snap];
            
            [self setAlphaWhenIsViewDocked: view alpha: 1.0];
            
            _viewDocked = NO;
        }
    }
}

- (void)setAlphaWhenIsViewDocked: (UIView *)view alpha: (CGFloat)alpha
{
    for (UIView * aView in _views)
    {
        if (aView != view)
        {
            aView.alpha	= alpha;
        }
    }
}

- (void)addVelocityToView: (UIView *)view fromGesture: (UIPanGestureRecognizer *)gesture
{
    CGPoint vel = [gesture velocityInView: self.view];
    vel.x = 0;
    
    UIDynamicItemBehavior *behavior = [self itemBehaviorForView: view];
    
    [behavior addLinearVelocity: vel forItem: view];
}


- (UIDynamicItemBehavior *)itemBehaviorForView: (UIView *)view
{
    for (UIDynamicItemBehavior *behavior in self.animator.behaviors)
    {
        if (behavior.class == [UIDynamicItemBehavior class] && [behavior.items firstObject] == view)
        {
            return behavior;
        }
    }
    
    return nil;
}

- (void)collisionBehavior: (UICollisionBehavior *)behavior
      beganContactForItem: (id<UIDynamicItem>)item
   withBoundaryIdentifier: (id<NSCopying>)identifier
                  atPoint: (CGPoint)p
{
    if ([@2 isEqual: identifier])
    {
        UIView *view = (UIView *)item;
        
        [self tryToDockView: view];
    }
}

@end
