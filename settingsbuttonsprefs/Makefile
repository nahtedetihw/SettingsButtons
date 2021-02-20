ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = settingsbuttonsprefs
settingsbuttonsprefs_FILES = SETBTNSPreferences.m
settingsbuttonsprefs_INSTALL_PATH = /Library/PreferenceBundles
settingsbuttonsprefs_FRAMEWORKS = UIKit
settingsbuttonsprefs_PRIVATE_FRAMEWORKS = Preferences
settingsbuttonsprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
settingsbuttonsprefs_LIBRARIES += sparkcolourpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/settingsbuttonsprefs.plist$(ECHO_END)
