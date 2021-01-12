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
HBPreferences *preferences;
BOOL enabled;
BOOL enableCustomColors;
NSInteger popoverConfirmationStyle;

static NSMutableDictionary *colorDictionary;
static NSString *nsNotificationString = @"com.nahtedetihw.settingsbuttonsprefs.color/changed";

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
