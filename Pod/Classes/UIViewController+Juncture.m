//
//  UIViewController+Juncture.m
//  Juncture
//
//  Created by Nestor Lafon-Gracia on 20/11/14.
//
//

#import "UIViewController+Juncture.h"
#import "NLJunctureError.h"

//TODO: Need to expose the animation option for push and the animation and the completion for present
@implementation UIViewController (Juncture)

- (BOOL)pushViewControllerWithIdentifier:(NSString *)identifier inStoryBoard:(NSString *)storyboardId onCompletion:(NLJunctureBlock)completionBlock {
    return [self showViewControllerWithIdentifier:identifier inStoryBoard:storyboardId pushing:YES onCompletion:completionBlock];
}

- (BOOL)presentViewControllerWithIdentifier:(NSString *)identifier inStoryBoard:(NSString *)storyboardId onCompletion:(NLJunctureBlock)completionBlock {
    return [self showViewControllerWithIdentifier:identifier inStoryBoard:storyboardId pushing:NO onCompletion:completionBlock];
}

- (UIViewController *)viewControllerWithIdentifier:(NSString *)identifier inStoryBoard:(NSString *)storyboardId {
    UIViewController *otherViewController = nil;
    UIStoryboard *otherStoryboard = nil;
    
    if (storyboardId) {
        @try {
            otherStoryboard = [UIStoryboard storyboardWithName:storyboardId bundle:nil];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }
    }
    else {
        otherStoryboard = [self storyboard];
    }
    
    if (identifier) {
        @try {
            otherViewController = [otherStoryboard instantiateViewControllerWithIdentifier:identifier];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", [exception description]);
        }
    }
    else {
        otherViewController = [otherStoryboard instantiateInitialViewController];
    }
    
    if (!otherViewController) {
        //xib 'discovery'
        Class viewControllerClass = NSClassFromString(identifier);
        if (viewControllerClass &&
            [viewControllerClass instancesRespondToSelector:@selector(initWithNibName:bundle:)]) {
            otherViewController = [[viewControllerClass alloc] initWithNibName:nil bundle:nil];;
        }
    }
    
    return otherViewController;
}

- (BOOL)showViewControllerWithIdentifier:(NSString *)identifier
                            inStoryBoard:(NSString *)storyboardId
                                 pushing:(BOOL)push
                            onCompletion:(NLJunctureBlock)completionBlock {
    
    UIViewController *otherViewController = [self viewControllerWithIdentifier:identifier inStoryBoard:storyboardId];
    
    if (otherViewController && push) {
        if (self.navigationController) {
            if ([otherViewController isKindOfClass:[UINavigationController class]]) {
                //Trying to push a navigation controller
                NSLog(@"Warning: trying to push a navigation controller into a navigation stack, using next vc for that");
                UINavigationController *navigationViewController = (UINavigationController *)otherViewController;
                if ([[navigationViewController viewControllers] count] > 0) {
                    otherViewController = [[navigationViewController viewControllers] firstObject];
                }
                else {
                    NSLog(@"Warning: viewcontroller inside navigation viewcontroller not found!");
                }
            }
            
            if (otherViewController) {
                if (completionBlock) {
                    completionBlock(otherViewController, nil);
                }
                [self.navigationController pushViewController:otherViewController animated:YES];
            }
            else {
                if (completionBlock) {
                    completionBlock(nil, [NLJunctureError validViewControllerNotFoundError]);
                }
                return NO;
            }
        }
        else {
            //Trying to push not in a navigation
            NSLog(@"Warning: we tried to push voucher viewcontroller from redemption not in a navigation stack");
            if (completionBlock) {
                completionBlock(nil, [NLJunctureError validNavigationControllerNotFoundError]);
            }
            return NO;
        }
    }
    else if (otherViewController && !push) {
        if (completionBlock) {
            completionBlock(otherViewController, nil);
        }
        [self presentViewController:otherViewController animated:YES completion:nil];
    }
    else {
        if (completionBlock) {
            completionBlock(nil, [NLJunctureError validViewControllerNotFoundError]);
        }
        return NO;
    }
    return YES;
}

@end
