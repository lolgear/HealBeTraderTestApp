//
//  UIImage+Resources.m
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "UIImage+Resources.h"

@implementation UIImage (Resources)

UIImage* getImageWithName (NSString* name){
    UIImage* image = [UIImage imageNamed:name];
    if (!image)
    {
        NSLog(@"wowow, I have not an image by name: %@",name);
    }
    return image;
}

+(UIImage *) getBackgroundImage {
    return getImageWithName(@"background");
}
+(UIImage *)getButtonAddKeyImage {
    return getImageWithName(@"smk_btm_menu_add");
}
+(UIImage *) getButtonBarcodeScanImage {
    return getImageWithName(@"smk_btn_barcode_scan");
}
+(UIImage *) getButtonDeleteImage {
    return getImageWithName(@"smk_btn_delete");
}
+(UIImage *) getButtonDrawerImage {
    return getImageWithName(@"smk_btn_drawer");
}
+(UIImage *) getButtonDrawerBackImage {
    return getImageWithName(@"smk_btn_drawer_back");
}
+(UIImage *) getButtonKeyRefreshImage {
    return getImageWithName(@"smk_btn_key_refresh");
}
+(UIImage *) getButtonKeySendImage {
    return getImageWithName(@"smk_btn_key_send");
}
+(UIImage *) getButtonLockClosedImage {
    return getImageWithName(@"smk_btn_lock_closed");
}
+(UIImage *) getButtonLockDisabledImage {
    return getImageWithName(@"smk_btn_lock_disabled");
}
+(UIImage *) getButtonLockOpenedImage {
    return getImageWithName(@"smk_btn_lock_opened");
}
+(UIImage *) getButtonMapSelectionImage {
    return getImageWithName(@"smk_btn_map_selection");
}
+(UIImage *) getButtonMenuAddImage {
    return getImageWithName(@"smk_btn_menu_add");
}
+(UIImage *) getButtonMenuDerivedImage {
    return getImageWithName(@"smk_btn_menu_derived");
}
+(UIImage *) getButtonMenuHelpImage {
    return getImageWithName(@"smk_btn_menu_help");
}
+(UIImage *) getButtonMenuInfoImage {
    return getImageWithName(@"smk_btn_menu_info");
}
+(UIImage *) getButtonMenuKeysImage {
    return getImageWithName(@"smk_btn_menu_keys");
}
+(UIImage *) getButtonMenuProfileImage {
    return getImageWithName(@"smk_btn_menu_profile");
}
+(UIImage *) getButtonPinDeleteImage {
    return getImageWithName(@"smk_btn_pin_delete");
}
+(UIImage *) getButtonPopupImage {
    return getImageWithName(@"smk_btn_popup");
}
+(UIImage *) getButtonSettingsImage {
    return getImageWithName(@"smk_btn_settings");
}
+(UIImage *) getGestureRotateLeftRightImage {
    return getImageWithName(@"smk_gesture_rotate_left_right");
}
+(UIImage *) getGestureRotateUpDownImage {
    return getImageWithName(@"smk_gesture_rotate_up_down");
}
+(UIImage *) getLogoImage {
    return getImageWithName(@"smk_logo");
}
+(UIImage *) getSliderIconImage {
    return getImageWithName(@"smk_slider_icon");
}


@end
