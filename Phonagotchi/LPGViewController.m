//
//  LPGViewController.m
//  Phonagotchi
//
//  Created by Steven Masuch on 2014-07-26.
//  Copyright (c) 2014 Lighthouse Labs. All rights reserved.
//

#import "LPGViewController.h"
#import "PetModel.h"

@interface LPGViewController ()

@property (nonatomic) UIImageView *petImageView;
@property (nonatomic) PetModel *pet;
@property (nonatomic,strong) NSDate *timeChange;
@property (nonatomic,strong) UIImageView *appleView;
@property (nonatomic,strong) UIImageView *movingAppleView;
@property (nonatomic,strong) UIImageView *bucketView;



@end

@implementation LPGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.timeChange = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];
    
    self.petImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.petImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.petImageView.image = [UIImage imageNamed:@"default"];
    
    [self.view addSubview:self.petImageView];
    
    [NSLayoutConstraint constraintWithItem:self.petImageView
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.petImageView
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0].active = YES;
    //create pan gesture recognizer to pet the phonagotchi
    
    // enable property that if velocity is too great, that phonagtochi becomes grumpy
    
    // have method on the model that takes a velocity
    
    //read only property that says if pet is grumpy or not
    
    
    UIPanGestureRecognizer *panGestRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesturePet:)];
    self.petImageView.userInteractionEnabled = YES;
    [self.petImageView addGestureRecognizer:panGestRecognizer];

    // Add view of bucket
    self.bucketView = [[UIImageView alloc] init];
    self.bucketView.image = [UIImage imageNamed:@"bucket"];
    self.bucketView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bucketView];
    
    // Set dimensions of bucket and constrain to bottom left corner
    [self.bucketView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [self.bucketView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0.0].active = YES;
    [self.bucketView.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.bucketView.heightAnchor constraintEqualToConstant:100].active = YES;
    
    self.appleView = [[UIImageView alloc] init];
    self.appleView.image = [UIImage imageNamed:@"apple"];
    self.appleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.appleView];
    
    [self.appleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.0].active = YES;
    [self.appleView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-36.0].active = YES;
    [self.appleView.widthAnchor constraintEqualToConstant:80].active = YES;
    [self.appleView.heightAnchor constraintEqualToConstant:80].active = YES;
    
    
    UILongPressGestureRecognizer *LPGestRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAppleDrag:)];
    self.appleView.userInteractionEnabled = YES;
    [self.appleView addGestureRecognizer:LPGestRecognizer];

    
    
}

- (void)handleLongPressAppleDrag:(UILongPressGestureRecognizer*)LPGestRecognizer
{
    switch (LPGestRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            
            self.movingAppleView = [[UIImageView alloc] init];
            self.movingAppleView.image = [UIImage imageNamed:@"apple"];
            self.movingAppleView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:self.movingAppleView];
//
            [self.movingAppleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10.0].active = YES;
            [self.movingAppleView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-34.0].active = YES;
            [self.movingAppleView.widthAnchor constraintEqualToConstant:80].active = YES;
            [self.movingAppleView.heightAnchor constraintEqualToConstant:80].active = YES;
            self.movingAppleView.center = [LPGestRecognizer locationInView:self.view];
            
            
        case UIGestureRecognizerStateChanged: {
            CGPoint touchCenter = [LPGestRecognizer locationInView:self.view];
            self.movingAppleView.center = touchCenter;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            BOOL (hitTarget) = CGRectIntersectsRect(self.movingAppleView.frame, self.petImageView.frame);
            if (hitTarget) {
                [self.movingAppleView removeFromSuperview];
                self.movingAppleView = nil;
            }
            else {
                [UIView animateWithDuration:.9 animations:^{
                    NSLog(@"%f",CGRectGetMaxY(self.view.frame));
                    CGFloat newOriginY = CGRectGetMaxY(self.view.frame) + 100;
                    self.movingAppleView.center = CGPointMake(self.movingAppleView.center.x, newOriginY);
                } completion:^(BOOL finished) {
                    [self.movingAppleView removeFromSuperview];
                    self.movingAppleView = nil;
                }];
            }
            break;
        default:
            NSLog(@"Something else happened");
            break;
            
        }
    }
}

- (void)handlePanGesturePet:(UIPanGestureRecognizer*)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {   CGPoint velocityComponent = [panGestureRecognizer velocityInView:self.petImageView];
        [panGestureRecognizer setTranslation:CGPointZero inView:self.petImageView];
        double speed = fabs(hypot(velocityComponent.x, velocityComponent.y));
        NSDate *now = [NSDate date];
        
        if ([now timeIntervalSinceDate:self.timeChange] > 1.3)
        {
            if (speed >= 700)
            {   self.pet.isGrumpy = YES;
                self.petImageView.image = [UIImage imageNamed:@"grumpy"];
            }
            else
            {
                self.pet.isGrumpy = NO;
                self.petImageView.image = [UIImage imageNamed:@"default"];
            }
            self.timeChange = now;
        }
    }
}
// do long press gesture instead of pinch gesture
// tedious to do the pinch gesture but the code is the same

// create 2 views
// one for apple, one for basket, fixed in bottom left corner
//add a pinch gesture recognizer that will create a new moving apple view
// if moving view dragged onto phonagotchi, view disappears immediately (eaten)
// if apple view dragged elsewhere, animate falling off bottom of screen


@end
