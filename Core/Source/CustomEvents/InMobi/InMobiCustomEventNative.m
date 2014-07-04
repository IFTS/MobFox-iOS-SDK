//
//  InMobiCustomEventNative.m
//  MobFoxSDKSource
//
//  Created by Michał Kapuściński on 03.07.2014.
//
//

#import "InMobiCustomEventNative.h"

static NSString *const kInMobiTitle = @"title";
static NSString *const kInMobiDescription = @"description";
static NSString *const kInMobiCallToAction = @"cta";
static NSString *const kInMobiRating = @"rating";
static NSString *const kInMobiScreenshot = @"screenshots";
static NSString *const kInMobiIcon = @"icon";

static NSString *const kInMobiImageURL = @"url";
static NSString *const kInMobiActionURL = @"landing_url";


@implementation InMobiCustomEventNative

-(void)loadNativeAdWithOptionalParameters:(NSString *)optionalParameters trackingPixel:(NSString *)trackingPixel {
    [self addImpressionTrackerWithUrl:trackingPixel];
    
    Class imNativeClass = NSClassFromString(@"IMNative");
    if (!imNativeClass) {
        [self.delegate customEventNativeFailed];
        return;
    }
    
    inMobiNative = [[imNativeClass alloc] initWithAppId:optionalParameters];
    inMobiNative.delegate = self;
    [inMobiNative loadAd];
    
}

-(void)dealloc {
    inMobiNative.delegate = nil;
    inMobiNative = nil;
}

-(void)nativeAd:(IMNative *)native didFailWithError:(IMError *)error {
    [self.delegate customEventNativeFailed];
}

-(void)nativeAdDidFinishLoading:(IMNative *)native {

    inMobiNative = native;
    NSDictionary *inMobiAssets = [self inMobiAssets];
    
    if([inMobiAssets objectForKey:kInMobiTitle]) {
        [self addTextAsset:[inMobiAssets objectForKey:kInMobiTitle] withType:kHeadlineTextAsset];
    }
    if([inMobiAssets objectForKey:kInMobiDescription]) {
        [self addTextAsset:[inMobiAssets objectForKey:kInMobiDescription] withType:kDescriptionTextAsset];
    }
    if([inMobiAssets objectForKey:kInMobiCallToAction]) {
        [self addTextAsset:[inMobiAssets objectForKey:kInMobiCallToAction] withType:kCallToActionTextAsset];
    }
    if([inMobiAssets objectForKey:kInMobiRating]) {
        [self addTextAsset:[inMobiAssets objectForKey:kInMobiRating] withType:kRatingTextAsset];
    }
    
    NSDictionary *iconDictionary = [inMobiAssets objectForKey:kInMobiIcon];
    
    if ([[iconDictionary objectForKey:kInMobiImageURL] length]) {
        [self addImageAssetWithImageUrl:[iconDictionary objectForKey:kInMobiImageURL] andType:kIconImageAsset];
    }
    
    NSDictionary *mainImageDictionary = [inMobiAssets objectForKey:kInMobiScreenshot];
    
    if ([[mainImageDictionary objectForKey:kInMobiImageURL] length]) {
        [self addImageAssetWithImageUrl:[iconDictionary objectForKey:kInMobiImageURL] andType:kMainImageAsset];
    }
    
    
    if([self isNativeAdValid]) {
        [self.delegate customEventNativeLoaded:self];
    } else {
        [self.delegate customEventNativeFailed];
    }
}

- (NSDictionary *)inMobiAssets
{
    NSData *data = [inMobiNative.content dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary *propertyDictionary = nil;
    if (data) {
        propertyDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    if (propertyDictionary && !error) {
        return propertyDictionary;
    }
    else {
        return nil;
    }
}


-(void)handleImpression {
}

-(void)prepareImpressionWithView:(UIView *)view {
    [inMobiNative attachToView:view];
}

-(void)handleClick {
    [inMobiNative handleClick:nil];
}



@end
