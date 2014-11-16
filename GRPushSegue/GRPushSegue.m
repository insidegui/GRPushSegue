//
//  Created by Guilherme Rambo on 16/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRPushSegue.h"

@import QuartzCore;

@interface GRPushAnimator : NSObject <NSViewControllerPresentationAnimator>
@end

@implementation GRPushAnimator

#define kPushAnimationDuration 0.3f

- (void)animatePresentationOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    viewController.view.frame = NSMakeRect(NSWidth(fromViewController.view.frame), // x
                                           0, // y
                                           NSWidth(fromViewController.view.frame), // width
                                           NSHeight(fromViewController.view.frame)); // height
    viewController.view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable;
    
    [fromViewController.view addSubview:viewController.view];
    
    NSRect destinationRect = fromViewController.view.frame;
    
    [fromViewController.view addSubview:viewController.view];
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = kPushAnimationDuration;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

        [viewController.view.animator setFrame:destinationRect];
    } completionHandler:nil];
}

- (void)animateDismissalOfViewController:(NSViewController *)viewController fromViewController:(NSViewController *)fromViewController
{
    NSRect destinationRect = NSMakeRect(NSWidth(fromViewController.view.frame), // x
                                        0, // y
                                        NSWidth(fromViewController.view.frame), // width
                                        NSHeight(fromViewController.view.frame)); // height
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = kPushAnimationDuration;
        context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        
        [viewController.view.animator setFrame:destinationRect];
    } completionHandler:^{
        [viewController.view removeFromSuperview];
    }];
}

@end

@implementation GRPushSegue

- (void)perform
{
    [self.sourceController presentViewController:self.destinationController animator:[[GRPushAnimator alloc] init]];
}

@end
