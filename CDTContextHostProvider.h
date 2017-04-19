/*
 CDTContextHostProvider originally written by Ethan Arbuckle
 https://github.com/EthanArbuckle/Mirmir/blob/lamo_no_ms/Lamo/CDTContextHostProvider.mm
 Licensed under Apache License 2.0
 http://www.apache.org/licenses/
 */

#import "Interfaces.h"

@interface CDTContextHostProvider : NSObject {
	NSMutableDictionary* _hostedApplications;
}

@property (nonatomic, assign) BOOL currentAppHasFinishedLaunching;

+ (instancetype)sharedInstance;

- (UIView *)hostViewForApplication:(id)sbapplication;
- (UIView *)hostViewForApplicationWithBundleID:(NSString *)bundleID;
- (NSString *)bundleIDFromHostView:(UIView *)hostView;

- (void)launchSuspendedApplicationWithBundleID:(NSString *)bundleID;

- (void)disableBackgroundingForApplication:(id)sbapplication;
- (void)enableBackgroundingForApplication:(id)sbapplication;

- (FBScene *)FBSceneForApplication:(id)sbapplication;
- (FBWindowContextHostManager *)contextManagerForApplication:(id)sbapplication;
- (FBSMutableSceneSettings *)sceneSettingsForApplication:(id)sbapplication;

- (BOOL)isHostViewHosting:(UIView *)hostView;
- (void)forceRehostingOnBundleID:(NSString *)bundleID;

- (void)stopHostingForBundleID:(NSString *)bundleID;

- (void)sendLandscapeRotationNotificationToBundleID:(NSString *)bundleID;
- (void)sendPortraitRotationNotificationToBundleID:(NSString *)bundleID;
- (void)setStatusBarHidden:(NSNumber *)hidden onApplicationWithBundleID:(NSString *)bundleID;

@end
