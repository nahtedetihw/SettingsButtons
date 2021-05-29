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

%group SettingsButtons

@interface RespringViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation RespringViewController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface SafeModeViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation SafeModeViewController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface ldrestartViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation ldrestartViewController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationNone;
}
@end

@interface lpmViewController : UIViewController <UIPopoverPresentationControllerDelegate>
@end

@implementation lpmViewController
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
traitCollection:(UITraitCollection *)traitCollection {
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

%hook PSUIPrefsListController

- (void)viewDidLoad {
    %orig;
    
    UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    respringButton.frame = CGRectMake(0,0,30,30);
    respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
    respringButton.layer.masksToBounds = YES;
    
    if (colorStyle == 0) {
    respringButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    } else if (colorStyle == 1) {
    respringButton.backgroundColor = backgroundDynamicColor;
    }
    
    [respringButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/respring.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    respringButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    respringButton.imageEdgeInsets = UIEdgeInsetsMake(-2,-2,-2,-2);
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

    [safeModeButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/safemode.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    safeModeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    safeModeButton.imageEdgeInsets = UIEdgeInsetsMake(-2,-2,-2,-2);
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

    [darkModeButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/lightmode.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    darkModeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

    [flashLightButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/flashlight.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    flashLightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

    [ldrestartButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/ldrestart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    ldrestartButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

    [lpmButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/lowpower.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    lpmButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
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

%new
- (void)respring:(UIButton *)sender {
    
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
    //respringPopover.barButtonItem = respringButtonItem;
    // you can replace the barButtonItem with the below two methods to anchor the popover to a different view
    respringPopover.sourceView = sender;
    respringPopover.sourceRect = sender.frame;
    
    [self presentViewController:respringPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}

%new
- (void)respringYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char* args[] = {"sbreload", NULL};
    posix_spawn(&pid, "/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

%new
- (void)respringNoGesture:(UIButton *)sender {
    [respringPopController dismissViewControllerAnimated:YES completion:nil];
}

%new
- (void)safeMode:(UIButton *)sender {
    
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
    //safeModePopover.barButtonItem = safeModeButtonItem;
    // you can replace the barButtonItem with the below two methods to anchor the popover to a different view
    safeModePopover.sourceView = sender;
    safeModePopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:safeModePopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}

%new
- (void)safeModeYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char *args[] = {"killall", "-SEGV", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
}

%new
- (void)safeModeNoGesture:(UIButton *)sender {
    [safeModePopController dismissViewControllerAnimated:YES completion:nil];
}

%new
- (void)darkMode:(UIButton *)sender {
    
    AudioServicesPlaySystemSound(1519);
        
        BOOL darkEnabled = ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark);
        
        UISUserInterfaceStyleMode *styleMode = [[%c(UISUserInterfaceStyleMode) alloc] init];
        if (darkEnabled) {
            styleMode.modeValue = 1;
            [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
                [darkModeButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/darkmode.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                darkModeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            } completion:nil];
        } else if (!darkEnabled)  {
            styleMode.modeValue = 2;
            [UIView animateWithDuration:1.0 delay:0 options:nil animations:^{
                [darkModeButton setImage:[[UIImage imageWithContentsOfFile:@"/Library/Application Support/SettingsButtons/lightmode.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
                darkModeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            } completion:nil];
        }
}

%new
- (void)flashLight:(UIButton *)sender {
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

%new
- (void)ldrestart:(UIButton *)sender {
    
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
    //ldrestartPopover.barButtonItem = ldrestartButtonItem;
    // you can replace the barButtonItem with the below two methods to anchor the popover to a different view
    ldrestartPopover.sourceView = sender;
    ldrestartPopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:ldrestartPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}

%new
- (void)ldrestartYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);
    
    NSTask *t = [[NSTask alloc] init];
    [t setLaunchPath:@"/usr/bin/sreboot"];
    [t setArguments:[NSArray arrayWithObjects:@"ldrestart", nil]];
    [t launch];
}

%new
- (void)ldrestartNoGesture:(UIButton *)sender {
    [ldrestartPopController dismissViewControllerAnimated:YES completion:nil];
}

%new
- (void)lpm:(UIButton *)sender {
    
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
    //lpmPopover.barButtonItem = lpmButtonItem;
    // you can replace the barButtonItem with the below two methods to anchor the popover to a different view
    lpmPopover.sourceView = sender;
    lpmPopover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:lpmPopController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);
}

%new
- (void)lpmYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);
    BOOL success = NO;
    if ([[%c(NSProcessInfo) processInfo] isLowPowerModeEnabled]) {
        [[%c(_CDBatterySaver) batterySaver] setPowerMode:0 error:nil];
        success = YES;
    } else {
        [[%c(_CDBatterySaver) batterySaver] setPowerMode:1 error:nil];
        success = YES;
    }
    
    if (success == YES) {
        [self dismissViewControllerAnimated:ldrestartPopController completion:nil];
    }
}

%new
- (void)lpmNoGesture:(UIButton *)sender {
    [lpmPopController dismissViewControllerAnimated:YES completion:nil];
}
%end

%hook UIApplication
-(void)applicationWillSuspend {
    %orig;
    [self.keyWindow.rootViewController dismissViewControllerAnimated:respringPopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:safeModePopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:ldrestartPopController completion:nil];
    [self.keyWindow.rootViewController dismissViewControllerAnimated:lpmPopController completion:nil];
}
%end

%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    // Notification for colors
    colorDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.nahtedetihw.settingsbuttonsprefs.color.plist"];
}

%ctor {
    notificationCallback(NULL, NULL, NULL, NULL, NULL);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)nsNotificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
        
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.nahtedetihw.settingsbuttonsprefs"];
    [preferences registerBool:&enable default:NO forKey:@"enable"];
    [preferences registerBool:&enableLeftButtons default:NO forKey:@"enableLeftButtons"];
    [preferences registerInteger:&colorStyle default:0 forKey:@"colorStyle"];
    [preferences registerInteger:&rightButtonStyle default:0 forKey:@"rightButtonStyle"];
    [preferences registerInteger:&leftButtonStyle default:0 forKey:@"leftButtonStyle"];

    if (enable) {
        %init(SettingsButtons);
        return;
    }
        return;
}
