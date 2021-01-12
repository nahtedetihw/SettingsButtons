#import "Tweak.h"

%group SettingsButtons


UIColor *respringTintDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonTintColorLight"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    return [UIColor labelColor];
}];

UIColor *respringBackgroundDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonBackgroundColorLight"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"respringButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    return [UIColor tableCellGroupedBackgroundColor];
}];

UIColor *safeModeTintDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonTintColorLight"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    return [UIColor labelColor];
}];

UIColor *safeModeBackgroundDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonBackgroundColorLight"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"safeModeButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    return [UIColor tableCellGroupedBackgroundColor];
}];

UIColor *darkModeTintDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonTintColorLight"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonTintColorDark"] withFallback:@"#FFFFFF"];
    }
    return [UIColor labelColor];
}];

UIColor *darkModeBackgroundDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonBackgroundColorLight"] withFallback:@"#FFFFFF"];
    }
    if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
        return [SparkColourPickerUtils colourWithString:[colorDictionary objectForKey:@"darkModeButtonBackgroundColorDark"] withFallback:@"#000000"];
    }
    return [UIColor tableCellGroupedBackgroundColor];
}];


%hook PSUIPrefsListController

- (void)viewDidLoad {
    %orig;
    
    respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    respringButton.frame = CGRectMake(0,0,30,30);
    respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
    respringButton.layer.masksToBounds = YES;
    
    if (enableCustomColors) {
        respringButton.backgroundColor = respringBackgroundDynamicColor;
    } else {
        respringButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    }
    
    [respringButton setImage:[UIImage systemImageNamed:@"staroflife.fill"] forState:UIControlStateNormal];
    
    // 0=NoPopovers 1=RespringOnly 2=SafeModeOnly 3=Both
    if (popoverConfirmationStyle == 0) {
        [respringButton addTarget:self action:@selector(respringYesGesture:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 1) {
        [respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 2) {
        [respringButton addTarget:self action:@selector(respringYesGesture:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 1) {
        [respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (enableCustomColors) {
        respringButton.tintColor = respringTintDynamicColor;
    } else {
    respringButton.tintColor = [UIColor labelColor];
    }
    
    respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
    
    UIButton *safeModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    safeModeButton.frame = CGRectMake(0,0,30,30);
    safeModeButton.layer.cornerRadius = safeModeButton.frame.size.height / 2;
    safeModeButton.layer.masksToBounds = YES;
    
    if (enableCustomColors) {
        safeModeButton.backgroundColor = safeModeBackgroundDynamicColor;
    } else {
        safeModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    }

    [safeModeButton setImage:[UIImage systemImageNamed:@"exclamationmark.shield.fill"] forState:UIControlStateNormal];
    
    // 0=NoPopovers 1=RespringOnly 2=SafeModeOnly 3=Both
    if (popoverConfirmationStyle == 0) {
        [safeModeButton addTarget:self action:@selector(safeModeYesGesture:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 1) {
        [safeModeButton addTarget:self action:@selector(safeModeYesGesture:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 2) {
        [safeModeButton addTarget:self action:@selector(safeMode:) forControlEvents:UIControlEventTouchUpInside];
    } else if (popoverConfirmationStyle == 1) {
        [safeModeButton addTarget:self action:@selector(safeMode:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (enableCustomColors) {
        safeModeButton.tintColor = safeModeTintDynamicColor;
    } else {
        safeModeButton.tintColor = [UIColor labelColor];
    }
    
    safeModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:safeModeButton];
    
    UIButton *darkModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    darkModeButton.frame = CGRectMake(0,0,30,30);
    darkModeButton.layer.cornerRadius = darkModeButton.frame.size.height / 2;
    darkModeButton.layer.masksToBounds = YES;
    
    if (enableCustomColors) {
        darkModeButton.backgroundColor = darkModeBackgroundDynamicColor;
    } else {
        darkModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    }

    [darkModeButton setImage:[UIImage systemImageNamed:@"circle.righthalf.fill"] forState:UIControlStateNormal];
    [darkModeButton addTarget:self action:@selector(darkMode:) forControlEvents:UIControlEventTouchUpInside];
    
    if (enableCustomColors) {
        darkModeButton.tintColor = darkModeTintDynamicColor;
    } else {
        darkModeButton.tintColor = [UIColor labelColor];
    }
    
    UIBarButtonItem *darkModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:darkModeButton];
    
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    space.width = 2;

    NSArray *buttons = @[space, respringButtonItem, space, safeModeButtonItem, space, darkModeButtonItem, space];
    
    self.navigationItem.rightBarButtonItems = buttons;
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
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
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
        } else if (!darkEnabled)  {
            styleMode.modeValue = 2;
        }
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
    [preferences registerBool:&enabled default:NO forKey:@"enabled"];
    [preferences registerBool:&enableCustomColors default:NO forKey:@"enableCustomColors"];
    [preferences registerInteger:&popoverConfirmationStyle default:0 forKey:@"popoverConfirmationStyle"];
    
    if (enabled) {
        %init(SettingsButtons);
        return;
    }
    return;
}
