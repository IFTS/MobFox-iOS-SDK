//
//  ChartboostCustomEventFullscreen.m
//  MobFoxSDKSource
//
//  Created by Michał Kapuściński on 28.07.2014.
//
//

#import "ChartboostCustomEventFullscreen.h"

@interface ChartboostCustomEventFullscreen()
@property (nonatomic) BOOL didReportAvailability;
@end

@implementation ChartboostCustomEventFullscreen


- (void)loadFullscreenWithOptionalParameters:(NSString *)optionalParameters trackingPixel:(NSString *)trackingPixel
{
    self.trackingPixel = trackingPixel;
    NSArray *tmp=[optionalParameters componentsSeparatedByString:@";"];
    Class SDKClass = NSClassFromString(@"Chartboost");
    if(!SDKClass || [tmp count] != 2) {
        [self notifyAdFailed];
        return;
    }
    
    NSString* appID = [tmp objectAtIndex:0];
    NSString* appSignature = [tmp objectAtIndex:1];
    [SDKClass startWithAppId:appID appSignature:appSignature delegate:self];
    sdk = [SDKClass sharedChartboost];
    self.didReportAvailability = NO;
    [sdk cacheInterstitial];
}


- (void)showFullscreenFromRootViewController:(UIViewController *)rootViewController
{
    if(sdk) {
        [sdk showInterstitial];
    }
}

-(void)didDisplayInterstitial:(CBLocation)location {
    [self notifyAdWillAppear];
}

-(void)didCacheInterstitial:(CBLocation)location {
    if(!self.didReportAvailability) {
        self.didReportAvailability = YES;
        [self notifyAdLoaded];
    }
    
}

-(void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error {
    if(!self.didReportAvailability) {
        self.didReportAvailability = YES;
        [self notifyAdFailed];
    }

}

-(void)didDismissInterstitial:(CBLocation)location {
    [self notifyAdWillClose];
}

-(void)didClickInterstitial:(CBLocation)location {
    [self notifyAdWillLeaveApplication];
}

-(void)finish {
    if(sdk) {
        sdk.delegate = nil;
        sdk = nil;
    }
    [super finish];
}

-(void)dealloc {
    [self finish];
}




@end
