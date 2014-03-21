//
//  CustomEventFullscreen.m
//  MobFoxSDKSource
//
//  Created by Michał Kapuściński on 10.03.2014.
//
//

#import "CustomEventFullscreen.h"

@implementation CustomEventFullscreen

@synthesize delegate;
@synthesize trackingPixel;

- (void)loadFullscreenWithOptionalParameters:(NSString *)optionalParameters trackingPixel:(NSString *)trackingPixel
{
    //to be overriden by subclasses
}

- (void)showFullscreenFromRootViewController:(UIViewController *)rootViewController
{
    //must be overriden by subclasses
}

- (void)didDisplayAd;
{
    @try {
        if(trackingPixel) {
            NSURL *url = [NSURL URLWithString:[trackingPixel stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod: @"GET"];
            [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error when tracking custom event interstitial");
    }
    
}


@end
