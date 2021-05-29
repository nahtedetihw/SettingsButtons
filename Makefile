TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Preferences

ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

SYSROOT=$(THEOS)/sdks/iphoneos14.0.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SettingsButtons

SettingsButtons_FILES = Tweak.xm
SettingsButtons_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
SettingsButtons_FRAMEWORKS = UIKit
SettingsButtons_EXTRA_FRAMEWORKS += Cephei
SettingsButtons_LIBRARIES += sparkcolourpicker

SUBPROJECTS += settingsbuttonsprefs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Preferences && killall -9 SpringBoard"
include $(THEOS_MAKE_PATH)/aggregate.mk