#line 1 "Tweak.xm"
#import <Cephei/HBPreferences.h>
#import <HBLog.h>
#import "SparkColourPickerUtils.h"
#import "SparkColourPickerView.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>
#import <AVKit/AVKit.h>
#import "NSTask.h"

UIViewController *respringPopController;
UIViewController *safeModePopController;
UIViewController *ldrestartPopController;
UIViewController *lpmPopController;
UIButton *darkModeButton;

static NSMutableDictionary *colorDictionary;
static NSString *nsNotificationString = @"com.nahtedetihw.settingsbuttonsprefs.color/changed";

UIColor *tintDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"tintColorDark"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"tintColorLight"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"tintColorDark"] withFallback:@"#FFFFFF"];
    }
    return [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
}];

UIColor *backgroundDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColorDark"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColorLight"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"backgroundColorDark"] withFallback:@"#000000"];
    }
    return [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
}];

HBPreferences *preferences;
BOOL enable;
BOOL enableLeftButtons;
NSInteger colorStyle;
NSInteger rightButtonStyle;
NSInteger leftButtonStyle;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class UISUserInterfaceStyleMode; @class UIApplication; @class _CDBatterySaver; @class NSProcessInfo; @class PSUIPrefsListController; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$_CDBatterySaver(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("_CDBatterySaver"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$UISUserInterfaceStyleMode(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("UISUserInterfaceStyleMode"); } return _klass; }static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$NSProcessInfo(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("NSProcessInfo"); } return _klass; }
#line 53 "Tweak.xm"
static void (*_logos_orig$SettingsButtons$PSUIPrefsListController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$SettingsButtons$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL); static void _logos_method$SettingsButtons$PSUIPrefsListController$respring$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$respringYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$respringNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$safeMode$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$safeModeYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$safeModeNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$darkMode$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$flashLight$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestart$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestartYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestartNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$lpm$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$lpmYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void _logos_method$SettingsButtons$PSUIPrefsListController$lpmNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST, SEL, UIButton *); static void (*_logos_orig$SettingsButtons$UIApplication$applicationWillSuspend)(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL); static void _logos_method$SettingsButtons$UIApplication$applicationWillSuspend(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST, SEL); 

@interface RespringViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation RespringViewController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface SafeModeViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation SafeModeViewController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface ldrestartViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation ldrestartViewController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface lpmViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation lpmViewController

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface PSUIPrefsListController : UIViewController
- (void)respringYesGesture:(UIButton *)sender;
- (void)respringNoGesture:(UIButton *)sender;
- (void)respring:(UIButton *)sender;
- (void)safeModeYesGesture:(UIButton *)sender;
- (void)safeModeNoGesture:(UIButton *)sender;
- (void)safeMode:(UIButton *)sender;
- (void)darkMode:(UIButton *)sender;
- (void)flashLight:(UIButton *)sender;
- (void)ldrestartYesGesture:(UIButton *)sender;
- (void)ldrestartNoGesture:(UIButton *)sender;
- (void)ldrestart:(UIButton *)sender;
@end

@interface UISUserInterfaceStyleMode : NSObject
@property (nonatomic, assign) long long modeValue;
@end

@interface UIColor (Private)
+ (id)tableCellGroupedBackgroundColor;
@end

@interface _CDBatterySaver
-(id)batterySaver;
-(BOOL)setPowerMode:(long long)arg1 error:(id *)arg2;
@end



static void _logos_method$SettingsButtons$PSUIPrefsListController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$SettingsButtons$PSUIPrefsListController$viewDidLoad(self, _cmd);
    
    UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    respringButton.frame = CGRectMake(0,0,30,30);
    respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
    respringButton.layer.masksToBounds = YES;
    
    if (colorStyle == 0) {
    respringButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    respringButton.backgroundColor = backgroundDynamicColor;
    }
    
    [respringButton setImage:[UIImage systemImageNamed:@"staroflife.fill"] forState:UIControlStateNormal];
    
    [respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
    
    if (colorStyle == 0) {
    respringButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    respringButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
    
    UIButton *safeModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    safeModeButton.frame = CGRectMake(0,0,30,30);
    safeModeButton.layer.cornerRadius = safeModeButton.frame.size.height / 2;
    safeModeButton.layer.masksToBounds = YES;
    
    if (colorStyle == 0) {
    safeModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    safeModeButton.backgroundColor = backgroundDynamicColor;
    }

    [safeModeButton setImage:[UIImage systemImageNamed:@"exclamationmark.shield.fill"] forState:UIControlStateNormal];
    
    [safeModeButton addTarget:self action:@selector(safeMode:) forControlEvents:UIControlEventTouchUpInside];

    if (colorStyle == 0) {
    safeModeButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    safeModeButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *safeModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:safeModeButton];
    
    darkModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    darkModeButton.frame = CGRectMake(0,0,30,30);
    darkModeButton.layer.cornerRadius = darkModeButton.frame.size.height / 2;
    darkModeButton.layer.masksToBounds = YES;
    
    if (colorStyle == 0) {
    darkModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    darkModeButton.backgroundColor = backgroundDynamicColor;
    }

    [darkModeButton setImage:[UIImage systemImageNamed:@"circle.righthalf.fill"] forState:UIControlStateNormal];
    [darkModeButton addTarget:self action:@selector(darkMode:) forControlEvents:UIControlEventTouchUpInside];
    
    if (colorStyle == 0) {
    darkModeButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    darkModeButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *darkModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:darkModeButton];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 2;
    
    UIButton *flashLightButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    flashLightButton.frame = CGRectMake(0,0,30,30);
    flashLightButton.layer.cornerRadius = flashLightButton.frame.size.height / 2;
    flashLightButton.layer.masksToBounds = YES;

    if (colorStyle == 0) {
    flashLightButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    flashLightButton.backgroundColor = backgroundDynamicColor;
    }

    [flashLightButton setImage:[UIImage systemImageNamed:@"bolt.fill"] forState:UIControlStateNormal];
    [flashLightButton addTarget:self action:@selector(flashLight:) forControlEvents:UIControlEventTouchUpInside];
    
    if (colorStyle == 0) {
    flashLightButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    flashLightButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *flashLightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:flashLightButton];
    
    UIButton *ldrestartButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    ldrestartButton.frame = CGRectMake(0,0,30,30);
    ldrestartButton.layer.cornerRadius = ldrestartButton.frame.size.height / 2;
    ldrestartButton.layer.masksToBounds = YES;

    if (colorStyle == 0) {
    ldrestartButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    ldrestartButton.backgroundColor = backgroundDynamicColor;
    }

    [ldrestartButton setImage:[UIImage systemImageNamed:@"exclamationmark.circle.fill"] forState:UIControlStateNormal];
    [ldrestartButton addTarget:self action:@selector(ldrestart:) forControlEvents:UIControlEventTouchUpInside];
    
    if (colorStyle == 0) {
    ldrestartButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    ldrestartButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *ldrestartButtonItem = [[UIBarButtonItem alloc] initWithCustomView:ldrestartButton];
    
    UIButton *lpmButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    lpmButton.frame = CGRectMake(0,0,30,30);
    lpmButton.layer.cornerRadius = lpmButton.frame.size.height / 2;
    lpmButton.layer.masksToBounds = YES;

    if (colorStyle == 0) {
    lpmButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    lpmButton.backgroundColor = backgroundDynamicColor;
    }

    [lpmButton setImage:[UIImage systemImageNamed:@"battery.25"] forState:UIControlStateNormal];
    [lpmButton addTarget:self action:@selector(lpm:) forControlEvents:UIControlEventTouchUpInside];
    
    if (colorStyle == 0) {
    lpmButton.tintColor = [UIColor labelColor];
    } else if (colorStyle == 1) {
    lpmButton.tintColor = tintDynamicColor;
    }
    
    UIBarButtonItem *lpmButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lpmButton];
    
    NSArray *rightButtons;
    
    if (rightButtonStyle == 0) {
    rightButtons = @[space, respringButtonItem, space, safeModeButtonItem, space, darkModeButtonItem, space];
    } else if (rightButtonStyle == 1) {
    rightButtons = @[space, respringButtonItem, space, safeModeButtonItem, space, ldrestartButtonItem, space];
    } else if (rightButtonStyle == 2) {
    rightButtons = @[space, respringButtonItem, space, ldrestartButtonItem, space, darkModeButtonItem, space];
    } else if (rightButtonStyle == 3) {
    rightButtons = @[space, respringButtonItem, space, flashLightButtonItem, space, darkModeButtonItem, space];
    } else if (rightButtonStyle == 4) {
    rightButtons = @[space, respringButtonItem, space, flashLightButtonItem, space, safeModeButtonItem, space];
    }
    
    self.navigationItem.rightBarButtonItems = rightButtons;

    NSArray *leftButtons;
    
    if (leftButtonStyle == 0) {
    leftButtons = @[space, lpmButtonItem, space, ldrestartButtonItem, space, flashLightButtonItem, space];
    } else if (leftButtonStyle == 1) {
    leftButtons = @[space, darkModeButtonItem, space, lpmButtonItem, space, flashLightButtonItem, space];
    } else if (leftButtonStyle == 2) {
    leftButtons = @[space, safeModeButtonItem, space, lpmButtonItem, space, flashLightButtonItem, space];
    } else if (leftButtonStyle == 3) {
    leftButtons = @[space, safeModeButtonItem, space, lpmButtonItem, space, ldrestartButtonItem, space];
    } else if (leftButtonStyle == 3) {
    leftButtons = @[space, darkModeButtonItem, space, lpmButtonItem, space, ldrestartButtonItem, space];
    }
    
    if (enableLeftButtons) {
    self.navigationItem.leftBarButtonItems = leftButtons;
    }
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$respring$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    respringPopController = [[UIViewController alloc] init];
    respringPopController.modalPresentationStyle = UIModalPresentationPopover;
    respringPopController.preferredContentSize = CGSizeMake(200,130);

    UILabel *respringLabel = [[UILabel alloc] init];
    respringLabel.frame = CGRectMake(10, 20, 180, 60);
    respringLabel.numberOfLines = 2;
    respringLabel.textAlignment = NSTextAlignmentCenter;
    respringLabel.adjustsFontSizeToFitWidth = YES;
    respringLabel.font = [UIFont boldSystemFontOfSize:20];
    respringLabel.textColor = [UIColor labelColor];
    respringLabel.text = @"Are you sure you want to respring?";
    [respringPopController.view addSubview:respringLabel];
    
    UIButton *respringYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [respringYesButton addTarget:self
                  action:@selector(respringYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [respringYesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [respringYesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    respringYesButton.frame = CGRectMake(100, 100, 100, 30);
    [respringPopController.view addSubview:respringYesButton];
    
    UIButton *respringNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [respringNoButton addTarget:self
                  action:@selector(respringNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [respringNoButton setTitle:@"No" forState:UIControlStateNormal];
    [respringNoButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    respringNoButton.frame = CGRectMake(0, 100, 100, 30);
    [respringPopController.view addSubview:respringNoButton];
     
    UIPopoverPresentationController *respringPopover = respringPopController.popoverPresentationController;
    RespringViewController *vc = [[RespringViewController alloc] init];
    respringPopover.delegate = vc;
    respringPopover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    
    respringPopover.sourceView = sender;
    respringPopover.sourceRect = sender.frame;
    
    [self presentViewController:respringPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$respringYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$respringNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    [respringPopController dismissViewControllerAnimated:YES completion:nil];
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$safeMode$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    safeModePopController = [[UIViewController alloc] init];
    safeModePopController.modalPresentationStyle = UIModalPresentationPopover;
    safeModePopController.preferredContentSize = CGSizeMake(200,130);
    
    UILabel *safeModeLabel = [[UILabel alloc] init];
    safeModeLabel.frame = CGRectMake(20, 20, 160, 60);
    safeModeLabel.numberOfLines = 2;
    safeModeLabel.textAlignment = NSTextAlignmentCenter;
    safeModeLabel.adjustsFontSizeToFitWidth = YES;
    safeModeLabel.font = [UIFont boldSystemFontOfSize:20];
    safeModeLabel.textColor = [UIColor labelColor];
    safeModeLabel.text = @"Are you sure you want to enter Safe Mode?";
    [safeModePopController.view addSubview:safeModeLabel];
    
    UIButton *safeModeYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [safeModeYesButton addTarget:self
                  action:@selector(safeModeYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [safeModeYesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [safeModeYesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    safeModeYesButton.frame = CGRectMake(100, 100, 100, 30);
    [safeModePopController.view addSubview:safeModeYesButton];
    
    UIButton *safeModeNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [safeModeNoButton addTarget:self
                  action:@selector(safeModeNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [safeModeNoButton setTitle:@"No" forState:UIControlStateNormal];
    [safeModeNoButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    safeModeNoButton.frame = CGRectMake(0, 100, 100, 30);
    [safeModePopController.view addSubview:safeModeNoButton];
     
    UIPopoverPresentationController *safeModePopover = safeModePopController.popoverPresentationController;
    SafeModeViewController *vc = [[SafeModeViewController alloc] init];
    safeModePopover.delegate = vc;
    safeModePopover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    
    safeModePopover.sourceView = sender;
    safeModePopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:safeModePopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$safeModeYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char *args[] = {"killall", "-SEGV", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$safeModeNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    [safeModePopController dismissViewControllerAnimated:YES completion:nil];
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$darkMode$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    AudioServicesPlaySystemSound(1519);
        
        BOOL darkEnabled = ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark);
        
        UISUserInterfaceStyleMode *styleMode = [[_logos_static_class_lookup$UISUserInterfaceStyleMode() alloc] init];
        if (darkEnabled) {
            styleMode.modeValue = 1;
            [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
                [darkModeButton setImage:[UIImage systemImageNamed:@"circle.righthalf.fill"] forState:UIControlStateNormal];
            } completion:nil];
        } else if (!darkEnabled)  {
            styleMode.modeValue = 2;
            [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
                [darkModeButton setImage:[UIImage systemImageNamed:@"circle.lefthalf.fill"] forState:UIControlStateNormal];
            } completion:nil];
        }
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$flashLight$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    AVCaptureDevice *flashLight = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([flashLight isTorchAvailable] && [flashLight isTorchModeSupported:AVCaptureTorchModeOn]) {
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success) {
            if ([flashLight isTorchActive]) {
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            } else {
                [flashLight setTorchMode:AVCaptureTorchModeOn];
        }
        [flashLight unlockForConfiguration];
        }
    }
    AudioServicesPlaySystemSound(1519);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestart$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    ldrestartPopController = [[UIViewController alloc] init];
    ldrestartPopController.modalPresentationStyle = UIModalPresentationPopover;
    ldrestartPopController.preferredContentSize = CGSizeMake(200,130);
    
    UILabel *ldrestartLabel = [[UILabel alloc] init];
    ldrestartLabel.frame = CGRectMake(20, 20, 160, 60);
    ldrestartLabel.numberOfLines = 2;
    ldrestartLabel.textAlignment = NSTextAlignmentCenter;
    ldrestartLabel.adjustsFontSizeToFitWidth = YES;
    ldrestartLabel.font = [UIFont boldSystemFontOfSize:20];
    ldrestartLabel.textColor = [UIColor labelColor];
    ldrestartLabel.text = @"Are you sure you want to Soft Reboot?";
    [ldrestartPopController.view addSubview:ldrestartLabel];
    
    UIButton *ldrestartYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ldrestartYesButton addTarget:self
                  action:@selector(ldrestartYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [ldrestartYesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [ldrestartYesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    ldrestartYesButton.frame = CGRectMake(100, 100, 100, 30);
    [ldrestartPopController.view addSubview:ldrestartYesButton];
    
    UIButton *ldrestartNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ldrestartNoButton addTarget:self
                  action:@selector(ldrestartNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [ldrestartNoButton setTitle:@"No" forState:UIControlStateNormal];
    [ldrestartNoButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    ldrestartNoButton.frame = CGRectMake(0, 100, 100, 30);
    [ldrestartPopController.view addSubview:ldrestartNoButton];
     
    UIPopoverPresentationController *ldrestartPopover = ldrestartPopController.popoverPresentationController;
    ldrestartViewController *vc = [[ldrestartViewController alloc] init];
    ldrestartPopover.delegate = vc;
    ldrestartPopover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    
    ldrestartPopover.sourceView = sender;
    ldrestartPopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:ldrestartPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestartYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    AudioServicesPlaySystemSound(1521);
    
    NSTask *t = [[NSTask alloc] init];
    [t setLaunchPath:@"/usr/bin/sreboot"];
    [t setArguments:[NSArray arrayWithObjects:@"ldrestart", nil]];
    [t launch];
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$ldrestartNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    [ldrestartPopController dismissViewControllerAnimated:YES completion:nil];
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$lpm$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    
    lpmPopController = [[UIViewController alloc] init];
    lpmPopController.modalPresentationStyle = UIModalPresentationPopover;
    lpmPopController.preferredContentSize = CGSizeMake(200,130);
    
    UILabel *lpmLabel = [[UILabel alloc] init];
    lpmLabel.frame = CGRectMake(20, 20, 160, 60);
    lpmLabel.numberOfLines = 2;
    lpmLabel.textAlignment = NSTextAlignmentCenter;
    lpmLabel.adjustsFontSizeToFitWidth = YES;
    lpmLabel.font = [UIFont boldSystemFontOfSize:20];
    lpmLabel.textColor = [UIColor labelColor];
    lpmLabel.text = @"Are you sure you want to toggle Low Power Mode?";
    [lpmPopController.view addSubview:lpmLabel];
    
    UIButton *lpmYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lpmYesButton addTarget:self
                  action:@selector(lpmYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [lpmYesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [lpmYesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    lpmYesButton.frame = CGRectMake(100, 100, 100, 30);
    [lpmPopController.view addSubview:lpmYesButton];
    
    UIButton *lpmNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lpmNoButton addTarget:self
                  action:@selector(lpmNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [lpmNoButton setTitle:@"No" forState:UIControlStateNormal];
    [lpmNoButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    lpmNoButton.frame = CGRectMake(0, 100, 100, 30);
    [lpmPopController.view addSubview:lpmNoButton];
     
    UIPopoverPresentationController *lpmPopover = lpmPopController.popoverPresentationController;
    lpmViewController *vc = [[lpmViewController alloc] init];
    lpmPopover.delegate = vc;
    lpmPopover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    
    lpmPopover.sourceView = sender;
    lpmPopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:lpmPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$lpmYesGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    AudioServicesPlaySystemSound(1521);
    BOOL success = NO;
    if ([[_logos_static_class_lookup$NSProcessInfo() processInfo] isLowPowerModeEnabled]) {
        [[_logos_static_class_lookup$_CDBatterySaver() batterySaver] setPowerMode:0 error:nil];
        success = YES;
    } else {
        [[_logos_static_class_lookup$_CDBatterySaver() batterySaver] setPowerMode:1 error:nil];
        success = YES;
    }
    
    if (success == YES) {
        [self dismissViewControllerAnimated:ldrestartPopController completion:nil];
    }
}


static void _logos_method$SettingsButtons$PSUIPrefsListController$lpmNoGesture$(_LOGOS_SELF_TYPE_NORMAL PSUIPrefsListController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIButton * sender) {
    [lpmPopController dismissViewControllerAnimated:YES completion:nil];
}



static void _logos_method$SettingsButtons$UIApplication$applicationWillSuspend(_LOGOS_SELF_TYPE_NORMAL UIApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    _logos_orig$SettingsButtons$UIApplication$applicationWillSuspend(self, _cmd);
    [self.keyWindow.rootViewController dismissViewControllerAnimated:respringPopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:safeModePopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:ldrestartPopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:lpmPopController completion:nil];
}




static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    
    colorDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.nahtedetihw.settingsbuttonsprefs.color.plist"];
}

static __attribute__((constructor)) void _logosLocalCtor_f492776c(int __unused argc, char __unused **argv, char __unused **envp) {
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
        
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.settingsbuttonsprefs"];
    [preferences registerBool:&enable default:NO forKey:@"enable"];
    [preferences registerBool:&enableLeftButtons default:NO forKey:@"enableLeftButtons"];
    [preferences registerInteger:&colorStyle default:0 forKey:@"colorStyle"];
    [preferences registerInteger:&rightButtonStyle default:0 forKey:@"rightButtonStyle"];
    [preferences registerInteger:&leftButtonStyle default:0 forKey:@"leftButtonStyle"];

    if (enable) {
        {Class _logos_class$SettingsButtons$PSUIPrefsListController = objc_getClass("PSUIPrefsListController"); { MSHookMessageEx(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(viewDidLoad), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$viewDidLoad, (IMP*)&_logos_orig$SettingsButtons$PSUIPrefsListController$viewDidLoad);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(respring:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$respring$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(respringYesGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$respringYesGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(respringNoGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$respringNoGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(safeMode:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$safeMode$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(safeModeYesGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$safeModeYesGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(safeModeNoGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$safeModeNoGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(darkMode:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$darkMode$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(flashLight:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$flashLight$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(ldrestart:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$ldrestart$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(ldrestartYesGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$ldrestartYesGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(ldrestartNoGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$ldrestartNoGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(lpm:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$lpm$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(lpmYesGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$lpmYesGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIButton *), strlen(@encode(UIButton *))); i += strlen(@encode(UIButton *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$SettingsButtons$PSUIPrefsListController, @selector(lpmNoGesture:), (IMP)&_logos_method$SettingsButtons$PSUIPrefsListController$lpmNoGesture$, _typeEncoding); }Class _logos_class$SettingsButtons$UIApplication = objc_getClass("UIApplication"); { MSHookMessageEx(_logos_class$SettingsButtons$UIApplication, @selector(applicationWillSuspend), (IMP)&_logos_method$SettingsButtons$UIApplication$applicationWillSuspend, (IMP*)&_logos_orig$SettingsButtons$UIApplication$applicationWillSuspend);}}
        return;
    }
        return;
}
