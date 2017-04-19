THEOS_DEVICE_IP = 192.168.1.13

include /opt/theos/makefiles/common.mk

TWEAK_NAME = IOMAp
IOMAp_FILES = Listener.xm CDTContextHostProvider.mm UIDraggableWindow.mm
IOMAp_LIBRARIES = activator
IOMAP_FRAMEWORKS = UIKit CoreGraphics QuartzCore 
IOMAp_LIBRARIES += objcipc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	#Filter plist
	$(ECHO_NOTHING)if [ -f Filter.plist ]; then mkdir -p $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/; cp Filter.plist $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/IOMAp.plist; fi$(ECHO_END)
	#PreferenceLoader plist
	$(ECHO_NOTHING)if [ -f Preferences.plist ]; then mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/IOMAp; cp Preferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/IOMAp/; fi$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
