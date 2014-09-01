//
//  MoPubCustomEventNative.m
//  MobFoxSDKSource
//
//  Created by Michał Kapuściński on 02.07.2014.
//
//

#import "MoPubCustomEventNative.h"
#import "MPNativeAdConstants.h"

@interface MoPubCustomEventNative()
@property (nonatomic, strong) MPNativeAd* moPubNativeAd;
@end

@implementation MoPubCustomEventNative

-(void)loadNativeAdWithOptionalParameters:(NSString *)optionalParameters trackingPixel:(NSString *)trackingPixel {
    [self addImpressionTrackerWithUrl:trackingPixel];
    MPNativeAdRequest *adRequest = [MPNativeAdRequest requestWithAdUnitIdentifier:optionalParameters];

    [self performSelectorOnMainThread:@selector(loadMoPub:) withObject:adRequest waitUntilDone:YES];
    
}

- (void) loadMoPub:(MPNativeAdRequest *)adRequest {
    [adRequest startWithCompletionHandler:^(MPNativeAdRequest *request, MPNativeAd *response, NSError *error) {
        if (error) {
            [self.delegate customEventNativeFailed];
        } else {
            self.moPubNativeAd = response;
            [self setClickUrl:[response.defaultActionURL absoluteString]];
            
            [self addTextAsset:[response.properties objectForKey:kAdCTATextKey] withType:kCallToActionTextAsset];
            [self addTextAsset:[response.properties objectForKey:kAdTitleKey] withType:kHeadlineTextAsset];
            [self addTextAsset:[response.properties objectForKey:kAdTextKey] withType:kDescriptionTextAsset];
            
            NSNumber *starRatingNum = response.starRating;
            if(starRatingNum) {
                NSString* starRating = [starRatingNum stringValue];
                [self addTextAsset:starRating withType:kRatingTextAsset];
            }

            [self addImageAssetWithImageUrl:[response.properties objectForKey:kAdIconImageKey] andType:kIconImageAsset];
            [self addImageAssetWithImageUrl:[response.properties objectForKey:kAdMainImageKey] andType:kMainImageAsset];

            
            if([self isNativeAdValid]) {
                [self.delegate customEventNativeLoaded:self];
            } else {
                [self.delegate customEventNativeFailed];
            }
        }
    }];

    
}

-(void)handleClick {
    [self.moPubNativeAd trackClick];
}

-(void)handleImpression {
    [self.moPubNativeAd trackImpression];
}



@end
