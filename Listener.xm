#include <objc/runtime.h>
#import <libactivator/libactivator.h>
#import "UIDraggableWindow.h"
#import "Interfaces.h"
#import <objcipc/objcipc.h>
#import <SpringBoard/SpringBoard.h>
#import "CDTContextHostProvider.h"

@interface IOMApListener : NSObject <LAListener> {
	BOOL _isVisible;
	NSString *_bundleID;
}

+ (id)sharedInstance;

- (BOOL)present;
- (BOOL)dismiss;

@end


@implementation IOMApListener

+ (id)sharedInstance {
	static id sharedInstance = nil;
	static dispatch_once_t token = 0;
	dispatch_once(&token, ^{
		sharedInstance = [self new];
	});
	return sharedInstance;
}

+ (void)load {
	@autoreleasepool
	{
		[[%c(LAActivator) sharedInstance] registerListener:[self new] forName:@"com.maximehip.iomap.listener"];
	}
}

#pragma mark - Listener custom methods

- (BOOL)presentOrDismiss {
	if (_isVisible) {
		return [self dismiss];
	} else {
		return [self present];
	}
}

- (BOOL)present {
	// Do UI stuff before this comment
	_isVisible = YES;
	return NO;
}

- (BOOL)dismiss {
	// Do UI stuff before this comment
	_isVisible = NO;
	return NO;
}

#pragma mark - LAListener protocol methods

- (void)activator:(LAActivator *)activator didChangeToEventMode:(NSString *)eventMode {
	[self dismiss];
}

#pragma mark - Incoming events

// Normal assigned events
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
	// FONCTION DU TWEAK

	 NSString *currentAppDisplayID = @"com.maximehip.iomap";
    
  
    [OBJCIPC sendMessageToAppWithIdentifier:currentAppDisplayID messageName:@"IOMap Window!" dictionary:@{ @"size": @"400,400" } replyHandler:^(NSDictionary *response) {}];
    

    [[UIApplication sharedApplication].keyWindow addSubview:[[UIDraggableWindow alloc]initWithFrameAndApp:CGRectMake(0,0,400,444) withApplication:currentAppDisplayID]];

	
}
// Sent when a chorded event gets escalated (short hold becoems a long hold, for example)
- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
	// Called when event is escalated to a higher event
	// (short-hold sleep button becomes long-hold shutdown menu, etc)
	[self dismiss];
}
// Sent at the lock screen when listener is not compatible with event, but potentially is able to unlock the screen to handle it
- (BOOL)activator:(LAActivator *)activator receiveUnlockingDeviceEvent:(LAEvent *)event forListenerName:(NSString *)listenerName {
	// If this listener handles unlocking the device, unlock it and return YES
	return NO;
}
// Sent when the menu button is pressed. Only handle if you want to suppress the standard menu button behaviour!
- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event {
	// Called when the home button is pressed.
	// If (and only if) we are showing UI, we should dismiss it and call setHandled:
	if ([self dismiss]) {
		[event setHandled:YES];
	}
}
// Sent when another listener has handled the event
- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event {
	// Called when some other listener received an event; we should cleanup
	[self dismiss];
}
// Sent from the settings pane when a listener is assigned
- (void)activator:(LAActivator *)activator receivePreviewEventForListenerName:(NSString *)listenerName {
	return;
}

#pragma mark - Metadata (may be cached)

// Listener name
- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
	return @"IOMap Listener";
}
// Listener description
- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
	return @"Know where are your favorite places";
}
// Prevent unassignment when trying to unassign the last event
- (NSNumber *)activator:(LAActivator *)activator requiresRequiresAssignmentForListenerName:(NSString *)listenerName {
	// Return YES if you need at least one assignment
	return [NSNumber numberWithBool:NO];
}
// Compatible event modes
- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
	return [NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil];
}
// Compatibility with events
- (NSNumber *)activator:(LAActivator *)activator requiresIsCompatibleWithEventName:(NSString *)eventName listenerName:(NSString *)listenerName {
	return [NSNumber numberWithBool:YES];
}
// Group assignment filtering
- (NSArray *)activator:(LAActivator *)activator requiresExclusiveAssignmentGroupsForListenerName:(NSString *)listenerName {
	return [NSArray array];
}
// Key querying
- (id)activator:(LAActivator *)activator requiresInfoDictionaryValueOfKey:(NSString *)key forListenerWithName:(NSString *)listenerName {
	NSLog(@"requiresInfoDictionaryValueOfKey: %@", key);
	return nil;
}
// Powered display
- (BOOL)activator:(LAActivator *)activator requiresNeedsPoweredDisplayForListenerName:(NSString *)listenerName {
	// Called when the listener is incompatible with the lockscreen event mode
	// Return YES if you need the display to be powered
	return YES;
}

#pragma mark - Icons

//  Fast path that supports scale
// The `scale' argument in the following two methods in an in-out variable. Read to provide the required image and set if you return a different scale.
- (NSData *)activator:(LAActivator *)activator requiresIconDataForListenerName:(NSString *)listenerName scale:(CGFloat *)scale {
	return nil;
}
- (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName scale:(CGFloat *)scale {
	return nil;
}
//  Legacy
- (NSData *)activator:(LAActivator *)activator requiresIconDataForListenerName:(NSString *)listenerName {
	return nil;
}
- (NSData *)activator:(LAActivator *)activator requiresSmallIconDataForListenerName:(NSString *)listenerName {
	return nil;
}
//  For cases where PNG data isn't available quickly
- (UIImage *)activator:(LAActivator *)activator requiresIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return nil;
}
- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
	return nil;
}
// Glyph
- (id)activator:(LAActivator *)activator requiresGlyphImageDescriptorForListenerName:(NSString *)listenerName {
	// Return an NString with the path to a glyph image as described by Flipswitch's documentation
	return nil;
}

#pragma mark - Removal (useful for dynamic listeners)

// Activator can request a listener to collapse on itself and disappear
- (BOOL)activator:(LAActivator *)activator requiresSupportsRemovalForListenerWithName:(NSString *)listenerName {
	// if YES, activator:requestsRemovalForListenerWithName: will be called
	return NO;
}
- (void)activator:(LAActivator *)activator requestsRemovalForListenerWithName:(NSString *)listenerName {
	// Get rid of the listener object
	return;
}

#pragma mark - Configuration view controller

// These methods require a subclass of LAListenerConfigurationViewController to exist
- (NSString *)activator:(LAActivator *)activator requiresConfigurationViewControllerClassNameForListenerWithName:(NSString *)listenerName bundle:(NSBundle **)outBundle {
	// `outBundle' should be the bundle containing the configuration view controller subclass
	*outBundle = [NSBundle bundleWithPath:@"/this/should/not/exist.bundle"];
	return nil;
}
- (id)activator:(LAActivator *)activator requestsConfigurationForListenerWithName:(NSString *)listenerName {
	// Return an NSPropertyList-serializable object that is passed into the configuration view controller
	return nil;
}
- (void)activator:(LAActivator *)activator didSaveNewConfiguration:(id)configuration forListenerWithName:(NSString *)listenerName {
	// Use the NSPropertyList-serializable `configuration' object from the previous method
	return;
}

@end
