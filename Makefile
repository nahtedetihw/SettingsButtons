TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Preferences

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsButton

SettingsButton_FILES = Tweak.xm
SettingsButton_CFLAGS = -fobjc-arc
SettingsButton_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"
include $(THEOS_MAKE_PATH)/aggregate.mk