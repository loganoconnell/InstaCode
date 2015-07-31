ARCHS = armv7 arm64
THEOS_BUILD_DIR = Packages
include theos/makefiles/common.mk

TWEAK_NAME = InstaCode
InstaCode_FILES = InstaCode.xm
InstaCode_LIBRARIES = substrate
InstaCode_FRAMEWORKS = Foundation UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += instacodeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
