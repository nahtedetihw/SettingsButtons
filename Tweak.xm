#import <Cephei/HBPreferences.h>
#import <HBLog.h>
#import "SparkColourPickerUtils.h"
#import "SparkColourPickerView.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>

UIViewController *respringPopController;
UIBarButtonItem *respringButtonItem;
UIButton *respringButton;
UIViewController *safeModePopController;
UIBarButtonItem *safeModeButtonItem;

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

@interface PSUIPrefsListController : UIViewController
- (void)respringYesGesture:(UIButton *)sender;
- (void)respringNoGesture:(UIButton *)sender;
- (void)respring:(UIButton *)sender;
- (void)safeModeYesGesture:(UIButton *)sender;
- (void)safeModeNoGesture:(UIButton *)sender;
- (void)safeMode:(UIButton *)sender;
- (void)darkMode:(UIButton *)sender;
@end

@interface UISUserInterfaceStyleMode : NSObject
@property (nonatomic, assign) long long modeValue;
@end

@interface UIColor (Private)
+ (id)tableCellGroupedBackgroundColor;
@end


%hook PSUIPrefsListController

- (void)viewDidLoad {
    %orig;
    
    respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    respringButton.frame = CGRectMake(0,0,30,30);
    respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
    respringButton.layer.masksToBounds = YES;
    
    respringButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    
    [respringButton setImage:[UIImage systemImageNamed:@"staroflife.fill"] forState:UIControlStateNormal];
    
    [respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
    
    respringButton.tintColor = [UIColor labelColor];
    
    respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
    
    UIButton *safeModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    safeModeButton.frame = CGRectMake(0,0,30,30);
    safeModeButton.layer.cornerRadius = safeModeButton.frame.size.height / 2;
    safeModeButton.layer.masksToBounds = YES;

    safeModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];

    [safeModeButton setImage:[UIImage systemImageNamed:@"exclamationmark.shield.fill"] forState:UIControlStateNormal];
    
    [safeModeButton addTarget:self action:@selector(safeMode:) forControlEvents:UIControlEventTouchUpInside];

    safeModeButton.tintColor = [UIColor labelColor];
    
    safeModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:safeModeButton];
    
    UIButton *darkModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    darkModeButton.frame = CGRectMake(0,0,30,30);
    darkModeButton.layer.cornerRadius = darkModeButton.frame.size.height / 2;
    darkModeButton.layer.masksToBounds = YES;

    darkModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];

    [darkModeButton setImage:[UIImage systemImageNamed:@"circle.righthalf.fill"] forState:UIControlStateNormal];
    [darkModeButton addTarget:self action:@selector(darkMode:) forControlEvents:UIControlEventTouchUpInside];
    
    darkModeButton.tintColor = [UIColor labelColor];
    
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
