@interface SBLockScreenScrollView : UIScrollView
@end

@protocol SBUIPasscodeLockView
@end

@interface SBPasscodeNumberPadButton : UIView
- (unsigned)character;
- (id)initForCharacter:(unsigned)arg1;
@end

@interface SBEmptyButtonView : UIView
- (unsigned)character;
- (id)initForCharacter:(unsigned)arg1;
@end

@interface SBUIPasscodeLockViewWithKeypad : UIView
- (NSString *)passcode;
- (void)passcodeLockNumberPadCancelButtonHit:(id)arg1;
- (void)passcodeLockNumberPadBackspaceButtonHit:(id)arg1;
- (void)passcodeLockNumberPadEmergencyCallButtonHit:(id)arg1;
- (void)passcodeLockNumberPad:(id)arg1 keyDown:(SBPasscodeNumberPadButton  *)arg2;
- (void)setCustomBackgroundColor:(UIColor *)arg1;
@end

@interface SBUIPasscodeLockViewSimple4DigitKeypad : UIView
- (id)_newEntryField;
- (double)_entryFieldBottomYDistanceFromNumberPadTopButton;
@end

@interface TPRevealingRingView : UIView
- (void)setDefaultRingStrokeWidth:(float)arg1;
@end

@interface TPNumberPadButton : UIView
+ (id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3;
+ (UIImage *)modifyImage:(UIImage *)originalImage forNumber:(unsigned)number;
@end

@interface TPNumberPad : UIView
- (id)initWithButtons:(NSArray *)buttons;
@end

@interface SBLockScreenView
- (void)_layoutSlideToUnlockView;
@end

@interface SBUIButton : UIView
@end

@interface SBUIPasscodeLockNumberPad : UIView
- (void)setShowsEmergencyCallButton:(BOOL)arg1;
@end

@interface SBLockScreenDateViewController : UIViewController
- (void)setDateHidden:(BOOL)hidden;
@end

@interface SBSlideUpAppGrabberView : UIView
@end

@interface SBLockScreenViewController : UIViewController
- (UIScrollView *)lockScreenScrollView;
- (BOOL)lockScreenIsShowingBulletins;
- (BOOL)isShowingMediaControls;
- (BOOL)isBounceEnabledForPresentingController:(id)presentingController locationInWindow:(CGPoint)window;
- (BOOL)_shouldShowDate;
- (BOOL)_shouldShowChargingText;
- (void)notificationListBecomingVisible:(BOOL)visible;
- (void)_handleDisplayTurnedOn:(id)on;
- (void)_dismissNotificationCenterToRevealPasscode;
- (void)attemptToUnlockUIFromNotification;
- (void)setPasscodeLockVisible:(BOOL)visible animated:(BOOL)animated completion:(id)completion;
- (void)setPasscodeLockVisible:(BOOL)visible animated:(BOOL)animated withUnlockSource:(int)unlockSource andOptions:(id)options;
- (void)passcodeLockViewCancelButtonPressed:(id)pressed;
- (void)lockScreenView:(id)view didEndScrollingOnPage:(int)page;
- (void)movePasscodeViewToLeft;
- (void)movePasscodeViewToRight;
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (BOOL)isPlaying;
@end

@interface SBDeviceLockController : NSObject
+ (id)sharedController;
- (BOOL)deviceHasPasscodeSet;
@end

static BOOL notificationsOrMedia = NO;

static BOOL enabled;
static BOOL hideCancelButton;
static BOOL hideDeleteButton;
static BOOL hideEmergencyButton;
static BOOL addPasscodeButtons;
static BOOL conditionallyHideDate;
static BOOL hideDate;
static BOOL hideChargingText;
static BOOL hideCameraGrabber;
static BOOL hideZeroButton;
static BOOL hideButtonText;
static BOOL hideButtonRing;
static BOOL hideSlideToUnlockText;
static BOOL pushPasscodeViewDown;
static float passcodeViewPushDownDistance;
static BOOL hideEntryField;
static float entryFieldDistance;
static BOOL hidePasscodeViewDarkening;
static float dimViewAlpha;

static void loadPrefs() {
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.TweaksByLogan.InstaCode.plist"];

	enabled = [prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES;
	hideCancelButton = [prefs objectForKey:@"hideCancelButton"] ? [[prefs objectForKey:@"hideCancelButton"] boolValue] : YES;
	hideDeleteButton = [prefs objectForKey:@"hideDeleteButton"] ? [[prefs objectForKey:@"hideDeleteButton"] boolValue] : YES;
	hideEmergencyButton = [prefs objectForKey:@"hideEmergencyButton"] ? [[prefs objectForKey:@"hideEmergencyButton"] boolValue] : YES;
	addPasscodeButtons = [prefs objectForKey:@"addPasscodeButtons"] ? [[prefs objectForKey:@"addPasscodeButtons"] boolValue] : YES;
	conditionallyHideDate = [prefs objectForKey:@"conditionallyHideDate"] ? [[prefs objectForKey:@"conditionallyHideDate"] boolValue] : NO;
	hideDate = [prefs objectForKey:@"hideDate"] ? [[prefs objectForKey:@"hideDate"] boolValue] : NO;
	hideChargingText = [prefs objectForKey:@"hideChargingText"] ? [[prefs objectForKey:@"hideChargingText"] boolValue] : NO;
	hideCameraGrabber = [prefs objectForKey:@"hideCameraGrabber"] ? [[prefs objectForKey:@"hideCameraGrabber"] boolValue] : NO;
	hideZeroButton = [prefs objectForKey:@"hideZeroButton"] ? [[prefs objectForKey:@"hideZeroButton"] boolValue] : NO;
	hideButtonText = [prefs objectForKey:@"hideButtonText"] ? [[prefs objectForKey:@"hideButtonText"] boolValue] : NO;
	hideButtonRing = [prefs objectForKey:@"hideButtonRing"] ? [[prefs objectForKey:@"hideButtonRing"] boolValue] : NO;
	hideSlideToUnlockText = [prefs objectForKey:@"hideSlideToUnlockText"] ? [[prefs objectForKey:@"hideSlideToUnlockText"] boolValue] : NO;
	pushPasscodeViewDown = [prefs objectForKey:@"pushPasscodeViewDown"] ? [[prefs objectForKey:@"pushPasscodeViewDown"] boolValue] : YES;
	passcodeViewPushDownDistance = [prefs objectForKey:@"passcodeViewPushDownDistance"] ? [[prefs objectForKey:@"passcodeViewPushDownDistance"] floatValue] : 39.5;
	hideEntryField = [prefs objectForKey:@"hideEntryField"] ? [[prefs objectForKey:@"hideEntryField"] boolValue] : NO;
	entryFieldDistance = [prefs objectForKey:@"entryFieldDistance"] ? [[prefs objectForKey:@"entryFieldDistance"] floatValue] : 14.0;
	hidePasscodeViewDarkening = [prefs objectForKey:@"hidePasscodeViewDarkening"] ? [[prefs objectForKey:@"hidePasscodeViewDarkening"] boolValue] : NO;
	dimViewAlpha = [prefs objectForKey:@"dimViewAlpha"] ? [[prefs objectForKey:@"dimViewAlpha"] floatValue] : 0.5;
}