//
//  UIImage+Resources.h
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

// helper for m:
// ls Airkey/Resources/Interfaces.xcassets/ | perl -lpe 's/[.]imageset//' | perl -lne '$old = $_; s/^smk//; s/btn/button/g; s/_(\w)/uc($1)/eg; $_ = ucfirst; $_ = q|get|. $_ .q|Image|; print qq(+(UIImage *) $_ { \n return getImageWithName(@"$old"); \n })' | pbcopy
// helper for h:
// ls Airkey/Resources/Interfaces.xcassets/ | perl -lpe 's/[.]imageset//' | perl -lne '$old = $_; s/^smk//; s/btn/button/g; s/_(\w)/uc($1)/eg; $_ = ucfirst; $_ = q|get|. $_ .q|Image|; print qq(+(UIImage *) $_;\n)' | pbcopy

@interface UIImage (Resources)

+(UIImage *) getBackgroundImage;

+(UIImage *) getButtonAddKeyImage;

+(UIImage *) getButtonBarcodeScanImage;

+(UIImage *) getButtonDeleteImage;

+(UIImage *) getButtonDrawerImage;

+(UIImage *) getButtonDrawerBackImage;

+(UIImage *) getButtonKeyRefreshImage;

+(UIImage *) getButtonKeySendImage;

+(UIImage *) getButtonLockClosedImage;

+(UIImage *) getButtonLockDisabledImage;

+(UIImage *) getButtonLockOpenedImage;

+(UIImage *) getButtonMapSelectionImage;

+(UIImage *) getButtonMenuAddImage;

+(UIImage *) getButtonMenuDerivedImage;

+(UIImage *) getButtonMenuHelpImage;

+(UIImage *) getButtonMenuInfoImage;

+(UIImage *) getButtonMenuKeysImage;

+(UIImage *) getButtonMenuProfileImage;

+(UIImage *) getButtonPinDeleteImage;

+(UIImage *) getButtonPopupImage;

+(UIImage *) getButtonSettingsImage;

+(UIImage *) getGestureRotateLeftRightImage;

+(UIImage *) getGestureRotateUpDownImage;

+(UIImage *) getLogoImage;

+(UIImage *) getSliderIconImage;

@end
