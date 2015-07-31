#import "InstaCode.h"

%hook SBLockScreenScrollView
- (void)layoutSubviews {
	%orig;

	if (enabled) {
		SBUIPasscodeLockViewWithKeypad *view = (SBUIPasscodeLockViewWithKeypad *)MSHookIvar<id <SBUIPasscodeLockView> >(self, "_passcodeView");

		if (pushPasscodeViewDown) {
			view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, pushPasscodeViewDown, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
		}

		else {
			view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
		}
	}
}

- (BOOL)gestureRecognizerShouldBegin:(id)gestureRecognizer {
	if (enabled) {
		if (notificationsOrMedia) {
			return YES;
		}

		else {
			return NO;
		}
	}

	else {
		return %orig;
	}
}
%end

%hook SBUIPasscodeLockViewWithKeypad
- (void)layoutSubviews {
	%orig;

	if (enabled) {
		UILabel *statusTitleView = MSHookIvar<UILabel *>(self, "_statusTitleView");

		if (notificationsOrMedia) {
			statusTitleView.hidden = NO;
		}

		else {
			statusTitleView.hidden = YES;
		}
	}
}

- (void)setFrame:(CGRect)frame {
	if (enabled) {
		if (notificationsOrMedia) {
			%orig(CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
		}

		else {
			if (pushPasscodeViewDown) {
				%orig(CGRectMake([UIScreen mainScreen].bounds.size.width, passcodeViewPushDownDistance, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
			}

			else {
				%orig(CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
			}
		}
	}
}

- (void)passcodeLockNumberPad:(id)arg1 keyDown:(SBPasscodeNumberPadButton  *)arg2 {
	if (enabled && addPasscodeButtons) {
		if([arg2 character] == 1111) {
			if (self.passcode.length == 0) {
				[self passcodeLockNumberPadCancelButtonHit:nil];
			}
			else {
				[self passcodeLockNumberPadBackspaceButtonHit:nil];
			}
	 	}

	 	else if ([arg2 character] == 911) {
			[self passcodeLockNumberPadEmergencyCallButtonHit:nil];
	 	}

	 	else {
	 		%orig;
	 	}
	}

 	else {
   		%orig;
 	}
}

- (void)setCustomBackgroundColor:(UIColor *)arg1 {
	if (enabled && hidePasscodeViewDarkening) {
		%orig([UIColor clearColor]);
	}

	else {
		%orig;
	}
}
%end

%hook SBUIPasscodeLockViewSimple4DigitKeypad
- (id)_newEntryField {
	if (enabled && hideEntryField) {
		return nil;
	}

	else {
		return %orig;
	}
}

- (double)_entryFieldBottomYDistanceFromNumberPadTopButton {
	if (enabled) {
		if (notificationsOrMedia) {
			return %orig;
		}

		else {
			return entryFieldDistance;
		}
	}

	else {
		return %orig;
	}
}
%end

%hook TPNumberPadButton
+ (id)imageForCharacter:(unsigned)arg1 highlighted:(BOOL)arg2 whiteVersion:(BOOL)arg3 {
	if (enabled && addPasscodeButtons) {
		return [self modifyImage:%orig forNumber:arg1];
	}

	else {
		return %orig;
	}
}

%new
+ (UIImage *)modifyImage:(UIImage *)originalImage forNumber:(unsigned)number {
	if (number == 1111) {
		NSString *text = @"Delete";
		UIFont *font = [UIFont systemFontOfSize:12.0];  
    	CGSize size = [text sizeWithFont:font];

        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);

        	NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};

        	[text drawInRect:rect withAttributes:attributes];

    		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();    

    	return image;
	}

	else if (number == 911) {
		NSString *text = @"Emergency";
		UIFont *font = [UIFont systemFontOfSize:12.0];  
    	CGSize size = [text sizeWithFont:font];

        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);

        	NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};

        	[text drawInRect:rect withAttributes:attributes];

    		UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    	UIGraphicsEndImageContext();    

    	return image;
	}

	else {
		return originalImage;
	}
}
%end

%hook TPNumberPad
- (id)initWithButtons:(NSArray *)buttons {
	if (enabled && (addPasscodeButtons || hideZeroButton)) {
		NSMutableArray *newButtons = [buttons mutableCopy];

		if (addPasscodeButtons) {
			SBPasscodeNumberPadButton *deleteButton = [[%c(SBPasscodeNumberPadButton) alloc] initForCharacter:1111];
			SBPasscodeNumberPadButton *emergencyButton = [[%c(SBPasscodeNumberPadButton) alloc] initForCharacter:911];

			[newButtons replaceObjectAtIndex:9 withObject:emergencyButton];
			[newButtons replaceObjectAtIndex:11 withObject:deleteButton];
		}

		else {
			SBEmptyButtonView *zeroButton = [[%c(SBEmptyButtonView) alloc] initForCharacter:0000];

			[newButtons replaceObjectAtIndex:10 withObject:zeroButton];
		}
				
		return %orig(newButtons);
	}

	else {
		return %orig;
	}
}
%end

%hook SBUIPasscodeLockNumberPad
- (void)setShowsEmergencyCallButton:(BOOL)arg1 {
	if (enabled) {
		if (hideCancelButton) {
			SBUIButton *cancelButton = MSHookIvar<SBUIButton *>(self, "_cancelButton");
			cancelButton.alpha = 0.0;
		}

		if (hideDeleteButton) {
			SBUIButton *backspaceButton = MSHookIvar<SBUIButton *>(self, "_backspaceButton");
			backspaceButton.alpha = 0.0;
		}

		if (hideEmergencyButton) {
			SBUIButton *emergencyCallButton = MSHookIvar<SBUIButton *>(self, "_emergencyCallButton");
			emergencyCallButton.alpha = 0.0;
			%orig(NO);
		}
	}

	else {
		%orig;
	}
}
%end

%hook SBLockScreenDateViewController
- (void)setDateHidden:(BOOL)hidden {
	if (enabled && (conditionallyHideDate || hideDate)) {
		if (conditionallyHideDate) {
			if (notificationsOrMedia && ![[%c(SBMediaController) sharedInstance] isPlaying]) {
				%orig(NO);
			}

			else {
				%orig(YES);
			}
		}
		
		else {
			%orig(YES);
		}
	}

	else {
		%orig;
	}
}
%end

%hook SBSlideUpAppGrabberView
- (void)layoutSubviews {
	%orig;
	
	if (enabled && hideCameraGrabber) {
		self.hidden = YES;
	}
}
%end

%hook SBLockScreenViewController
- (void)loadView {
	%orig;

	if (enabled) {
		UIView *dimView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		dimView.backgroundColor = [UIColor blackColor];
		dimView.alpha = dimViewAlpha;
		[self.view insertSubview:dimView atIndex:0];
	}		
}

- (BOOL)isBounceEnabledForPresentingController:(id)presentingController locationInWindow:(CGPoint)window {
	if (enabled) {
		return NO;
	}

	else {
		return %orig;
	}
}

- (BOOL)_shouldShowDate {
	if (enabled && (conditionallyHideDate || hideDate)) {
		if (conditionallyHideDate) {
			if (notificationsOrMedia) {
				return YES;
			}

			else {
				return NO;
			}
		}
		
		else {
			return NO;
		}
	}
	
	else {
		return %orig;
	}
}

- (BOOL)_shouldShowChargingText {
	if (enabled && hideChargingText) {
		return NO;
	}

	else {
		return %orig;
	}
}

- (void)notificationListBecomingVisible:(BOOL)visible {
	if (enabled) {
		if (visible || [self isShowingMediaControls]) {
			[self movePasscodeViewToLeft];
		}

		else {
			[self movePasscodeViewToRight];
		}
	}

	%orig;
}

- (void)_handleDisplayTurnedOn:(id)on {
	if (enabled) {
		if ([self lockScreenIsShowingBulletins] || [self isShowingMediaControls]) {
			[self movePasscodeViewToLeft];
		}

		else {
			[self movePasscodeViewToRight];
		}
	}

	%orig;
}

- (void)_dismissNotificationCenterToRevealPasscode {
	if (enabled) {
		[self movePasscodeViewToLeft];
	}

	%orig;
}

- (void)attemptToUnlockUIFromNotification {
	if (enabled) {
		[self movePasscodeViewToLeft];
	}

	%orig;
}

- (void)passcodeLockViewCancelButtonPressed:(id)pressed {
	if (enabled && !([self lockScreenIsShowingBulletins] || [self isShowingMediaControls])) {
		[self movePasscodeViewToRight];
	}

	%orig;
}

%new
- (void)movePasscodeViewToLeft {
	notificationsOrMedia = YES;

	SBUIPasscodeLockViewWithKeypad *passcodeView = (SBUIPasscodeLockViewWithKeypad *)MSHookIvar<id <SBUIPasscodeLockView> >([self lockScreenScrollView], "_passcodeView");
	passcodeView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	
	[passcodeView layoutSubviews];

	if (conditionallyHideDate) {
		SBLockScreenDateViewController *dateViewController = MSHookIvar<SBLockScreenDateViewController *>(self, "_dateViewController");
		[dateViewController setDateHidden:NO];
	}
}

%new
- (void)movePasscodeViewToRight {
	notificationsOrMedia = NO;

	SBUIPasscodeLockViewWithKeypad *passcodeView = (SBUIPasscodeLockViewWithKeypad *)MSHookIvar<id <SBUIPasscodeLockView> >([self lockScreenScrollView], "_passcodeView");

	if (pushPasscodeViewDown) {
		passcodeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, pushPasscodeViewDown, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	}

	else {
		passcodeView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	}

	[passcodeView layoutSubviews];

	if (conditionallyHideDate) {
		SBLockScreenDateViewController *dateViewController = MSHookIvar<SBLockScreenDateViewController *>(self, "_dateViewController");
		[dateViewController setDateHidden:YES];
	}
}
%end

%ctor {
	loadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.TweaksByLogan.InstaCode/saved"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}