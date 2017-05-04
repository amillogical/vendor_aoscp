PRODUCT_BRAND ?= aoscp

# Include versioning information
# Format: Major.minor.maintenance(-TAG)
export AOSCP_VERSION := 3.6.3

export AOSCP_RELEASE_ID := CR.N-MR2.362.R3-0421

export AOSCP_API_LEVEL := Macchiato

AOSCP_DISPLAY_VERSION := $(AOSCP_VERSION)

export ROM_VERSION := $(AOSCP_VERSION)-$(shell date -u +%Y%m%d)

ifneq ($(RELEASE_TYPE),)
    AOSCP_BUILDTYPE := $(RELEASE_TYPE)
endif

#We build unofficial by default
ifndef AOSCP_BUILDTYPE
    AOSCP_BUILDTYPE := unofficial
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=$(ROM_VERSION) \
    ro.aoscp.version=$(AOSCP_VERSION) \
    ro.aoscp.release.id=$(AOSCP_RELEASE_ID) \
    ro.aoscp.device=$(AOSCP_DEVICE) \
    ro.aoscp.display.version=$(AOSCP_DISPLAY_VERSION) \
    ro.aoscp.releasetype=$(AOSCP_BUILDTYPE) \
    ro.aoscp.api=$(AOSCP_API_LEVEL)

export AOSCP_TARGET_ZIP := aoscp_$(AOSCP_DEVICE)-$(AOSCP_VERSION)-$(shell date -u +%Y%m%d)-$(AOSCP_BUILDTYPE)

# Bootanimation
PRODUCT_PACKAGES += bootanimation.zip

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
	ro.setupwizard.network_required=false \
    ro.setupwizard.gservices_delay=-1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
	ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
	ro.setupwizard.rotation_locked=true \
    ro.opa.eligible_device=true

#SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# OMS Verified
PRODUCT_PROPERTY_OVERRIDES += \
    ro.substratum.verified=true

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=Titania.ogg \
    ro.config.notification_sound=Tethys.ogg \
    ro.config.alarm_alert=Argon.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

ifneq ($(TARGET_BUILD_VARIANT),userdebug)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aoscp/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aoscp/prebuilt/common/bin/50-aoscp.sh:system/addon.d/50-aoscp.sh \
    vendor/aoscp/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/aoscp/prebuilt/common/bin/99-backup.sh:system/addon.d/99-backup.sh \
    vendor/aoscp/prebuilt/common/etc/backup.conf:system/etc/backup.conf

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/aoscp/configs/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.d/00start:system/etc/init.d/00start \
    vendor/aoscp/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/aoscp/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/aoscp/prebuilt/common/bin/sysinit:system/bin/sysinit

# userinit support
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# AOSCP-specific init file
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/init.local.rc:root/init.aoscp.rc \

# Installer
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/bin/persist.sh:install/bin/persist.sh \
    vendor/aoscp/prebuilt/common/etc/persist.conf:system/etc/persist.conf

PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/aoscp/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

PRODUCT_COPY_FILES += \
    vendor/aoscp/configs/permissions/com.aoscp.android.xml:system/etc/permissions/com.aoscp.android.xml

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Substratum ThemeInterfacer
PRODUCT_PACKAGES += \
    ThemeInterfacer

# Common overlay
DEVICE_PACKAGE_OVERLAYS += vendor/aoscp/overlay/common

# Version information used on all builds
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_VERSION_TAGS=release-keys USER=android-build BUILD_UTC_DATE=$(shell date +"%s")

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/aoscp/configs/partner_gms.mk
-include vendor/aoscp/configs/common_packages.mk

include frameworks/opt/aoscp/aoscp_framework.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
