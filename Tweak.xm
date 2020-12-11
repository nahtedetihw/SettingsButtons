#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import <spawn.h>

@interface PSUIPrefsListController : UINavigationController
- (void)respring:(UIButton *)sender;
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
    
    UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    respringButton.frame = CGRectMake(0,0,30,30);
    respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
    respringButton.layer.masksToBounds = YES;
    respringButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    [respringButton setImage:[UIImage systemImageNamed:@"staroflife.fill"] forState:UIControlStateNormal];
    [respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
    respringButton.tintColor = [UIColor labelColor];
    
    UIBarButtonItem *respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
    
    UIButton *safeModeButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    safeModeButton.frame = CGRectMake(0,0,30,30);
    safeModeButton.layer.cornerRadius = safeModeButton.frame.size.height / 2;
    safeModeButton.layer.masksToBounds = YES;
    safeModeButton.backgroundColor = [UIColor tableCellGroupedBackgroundColor];
    [safeModeButton setImage:[UIImage systemImageNamed:@"exclamationmark.shield.fill"] forState:UIControlStateNormal];
    [safeModeButton addTarget:self action:@selector(safeMode:) forControlEvents:UIControlEventTouchUpInside];
    safeModeButton.tintColor = [UIColor labelColor];
    
    UIBarButtonItem *safeModeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:safeModeButton];
    
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
    AudioServicesPlaySystemSound(1521);
    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

%new
-(void)safeMode:(UIButton *)sender {

    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char *args[] = {"killall", "-SEGV", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char * const *)args, NULL);
}

%new
- (void)darkMode:(UIButton *)sender {
    
    AudioServicesPlaySystemSound(1521);
    
    BOOL darkEnabled = ([UITraitCollection currentTraitCollection].userInterfaceStyle == UIUserInterfaceStyleDark);
    
    UISUserInterfaceStyleMode *styleMode = [[%c(UISUserInterfaceStyleMode) alloc] init];
    if (darkEnabled) {
        styleMode.modeValue = 1;
    } else if (!darkEnabled)  {
        styleMode.modeValue = 2;
    }
}

%end
