ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = InstaCodePrefs
InstaCodePrefs_FILES = InstaCodePrefs.mm
InstaCodePrefs_INSTALL_PATH = /Library/PreferenceBundles
InstaCodePrefs_FRAMEWORKS = Foundation UIKit
InstaCodePrefs_PRIVATE_FRAMEWORKS = Preferences Twitter

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InstaCodePrefs.plist$(ECHO_END)
