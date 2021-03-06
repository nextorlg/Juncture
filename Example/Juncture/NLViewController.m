//
//  NLViewController.m
//  Juncture
//
//  Created by Nestor Lafon-Gracia on 11/19/2014.
//  Copyright (c) 2014 Nestor Lafon-Gracia. All rights reserved.
//

#import "NLViewController.h"
#import "UIViewController+Juncture.h"
#import "NLJunctureController.h"
#import "NLDataViewController.h"

@interface NLViewController () <UIActionSheetDelegate>

@end

@implementation NLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionButton.translatesAutoresizingMaskIntoConstraints = NO;
    actionButton.frame = CGRectMake(0, 0, 100, 100);
    [actionButton setTitle:@"Action" forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[actionButton]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:@{@"superview":self.view, @"actionButton":actionButton}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[actionButton]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:@{@"superview":self.view, @"actionButton":actionButton}]];
    
    if (self.navigationController && [self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated)];
    }
    
}

- (IBAction)actionButtonAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
    @"Push navVC",
    @"Present navVC",
    @"Push standaloneVC",
    @"Present standaloneVC",
    @"Push modalVC",
    @"Present modalVC",
    @"Use segue for root 2-steps",
    @"Use segue for root 1-steps",
    @"Push vc in xib",
    @"Present vc in xib",
    @"Dismiss current",
    nil];
    [actionSheet showInView:self.view];
}

- (void)dismissModalViewControllerAnimated {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self pushViewControllerWithIdentifier:@"navVC" inStoryBoard:@"NLShowModalCustom" onCompletion:nil];
            break;
        case 1:
            [self presentViewControllerWithIdentifier:nil inStoryBoard:@"NLShowModalCustom" onCompletion:nil];
            break;
        case 2:
            [self pushViewControllerWithIdentifier:@"standaloneVC" inStoryBoard:@"NLStandaloneViewController" onCompletion:nil];
            break;
        case 3:
            [self presentViewControllerWithIdentifier:@"standaloneVC" inStoryBoard:@"NLStandaloneViewController" onCompletion:nil];
            break;
        case 4:
            [self pushViewControllerWithIdentifier:@"modalVC" inStoryBoard:@"NLShowModalCustom" onCompletion:nil];
            break;
        case 5:
            [self presentViewControllerWithIdentifier:@"modalVC" inStoryBoard:nil onCompletion:nil];
            break;
        case 6:
            [self.junctureController addPreparationForIdentifier:@"seg_custom"
                                                           block:^(NLDataViewController *viewController, NSError *error) {
                                                               [viewController view]; //To load the nib
                                                               viewController.dataLabel.text = @"Data set in block";
                                                           }];
            @try {
                [self performSegueWithIdentifier:@"seg_custom" sender:self];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception description]);
            }
            break;
        case 7:
            @try {
                [self.junctureController addPreparationAndPerformSegueWithIdentifier:@"seg_custom"
                                                                sourceViewController:self
                                                                              sender:self
                                                                               block:^(NLDataViewController *viewController, NSError *error) {
                                                                                   [viewController view]; //To load the nib
                                                                                   viewController.dataLabel.text = @"Data set in block and perform at once";
                                                                               }];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", [exception description]);
            }
            break;
        case 8:
        {
            [self pushViewControllerWithIdentifier:@"NLXibViewController" inStoryBoard:nil onCompletion:^(NLViewController *viewController, NSError *error) {
                viewController.view.backgroundColor = [UIColor purpleColor];
            }];
            break;
        }
        case 9:
        {
            [self presentViewControllerWithIdentifier:@"NLXibViewController" inStoryBoard:nil onCompletion:^(NLViewController *viewController, NSError *error) {
                viewController.view.backgroundColor = [UIColor purpleColor];
            }];
            break;
        }
        default:
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

@end
