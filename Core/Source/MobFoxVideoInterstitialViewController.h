

#import <UIKit/UIKit.h>

enum {
    MobFoxInterstitialViewErrorUnknown = 0,
    MobFoxInterstitialViewErrorServerFailure = 1,
    MobFoxInterstitialViewErrorInventoryUnavailable = 2,
};

typedef enum {
    MobFoxAdTypeVideo = 0,
    MobFoxAdTypeNoAdInventory = 1,
    MobFoxAdTypeError = 2,
    MobFoxAdTypeUnknown = 3,
    MobFoxAdTypeText = 4,
    MobFoxAdTypeImage = 5,
    MobFoxAdTypeMraid = 6
    
} MobFoxAdType;

typedef enum {
    MobFoxAdGroupVideo = 0,
    MobFoxAdGroupInterstitial = 1
} MobFoxAdGroupType;

@class MobFoxVideoInterstitialViewController;
@class MobFoxAdBrowserViewController;

@protocol MobFoxVideoInterstitialViewControllerDelegate <NSObject>

- (NSString *)publisherIdForMobFoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)videoInterstitial;

@optional

- (void)mobfoxVideoInterstitialViewDidLoadMobFoxAd:(MobFoxVideoInterstitialViewController *)videoInterstitial advertTypeLoaded:(MobFoxAdType)advertType;

- (void)mobfoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)banner didFailToReceiveAdWithError:(NSError *)error;

- (void)mobfoxVideoInterstitialViewActionWillPresentScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewWillDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewDidDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewActionWillLeaveApplication:(MobFoxVideoInterstitialViewController *)videoInterstitial;

@end

@interface MobFoxVideoInterstitialViewController : UIViewController
{

    BOOL advertLoaded;
	BOOL advertViewActionInProgress;

    __unsafe_unretained id <MobFoxVideoInterstitialViewControllerDelegate> delegate;

    MobFoxAdBrowserViewController *_browser;

    NSString *interstitialRequestURL;
    NSString *videoRequestURL;
    UIImage *_bannerImage;

}

@property (nonatomic, assign) IBOutlet __unsafe_unretained id <MobFoxVideoInterstitialViewControllerDelegate> delegate;

@property (nonatomic, readonly, getter=isAdvertLoaded) BOOL advertLoaded;
@property (nonatomic, readonly, getter=isAdvertViewActionInProgress) BOOL advertViewActionInProgress;

@property (nonatomic, assign) BOOL locationAwareAdverts;
@property (nonatomic, assign) BOOL enableInterstitialAds;
@property (nonatomic, assign) BOOL enableVideoAds;
@property (nonatomic, assign) BOOL prioritizeVideoAds;
@property (nonatomic, assign) NSInteger video_min_duration;
@property (nonatomic, assign) NSInteger video_max_duration;

@property (nonatomic, strong) NSString *interstitialRequestURL;
@property (nonatomic, strong) NSString *videoRequestURL;

- (void)requestAd;

- (void)presentAd:(MobFoxAdType)advertType;

- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


@end

extern NSString * const MobFoxVideoInterstitialErrorDomain;