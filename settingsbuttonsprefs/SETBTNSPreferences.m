#include "SETBTNSPreferences.h"
#import <AudioToolbox/AudioServices.h>

UIImageView *secondaryHeaderImage;
UIBarButtonItem *respringButtonItem;
UIViewController *popController;

@implementation SETBTNSPreferencesListController
@synthesize killButton;
@synthesize versionArray;

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
    }

    return _specifiers;
}


- (instancetype)init {

    self = [super init];

    if (self) {
        
        UIColor *buttonBackgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
            }
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return [UIColor colorWithRed:186/255.0f green:204/255.0f blue:211/255.0f alpha:1.0f];
            }
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
                return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
            }
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }];
        
        SETBTNSAppearanceSettings *appearanceSettings = [[SETBTNSAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        
        UIButton *respringButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        respringButton.frame = CGRectMake(0,0,30,30);
        respringButton.layer.cornerRadius = respringButton.frame.size.height / 2;
        respringButton.layer.masksToBounds = YES;
        respringButton.backgroundColor = buttonBackgroundColor;
        [respringButton setImage:[UIImage systemImageNamed:@"checkmark.circle"] forState:UIControlStateNormal];
        [respringButton addTarget:self action:@selector(apply:) forControlEvents:UIControlEventTouchUpInside];
        respringButton.tintColor = [UIColor whiteColor];
        
        respringButtonItem = [[UIBarButtonItem alloc] initWithCustomView:respringButton];
        
        self.navigationItem.rightBarButtonItem = respringButtonItem;
        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"";
        self.titleLabel.textColor = [UIColor systemRedColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/settingsbuttonsprefs.bundle/icon.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];

    }

    return self;

}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {

    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;
    
    UIColor *navbarTintColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:186/255.0f green:204/255.0f blue:211/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
    }];

    self.navigationController.navigationController.navigationBar.barTintColor = navbarTintColor;
    [self.navigationController.navigationController.navigationBar setShadowImage: [UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = NO;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/settingsbuttonsprefs.bundle/banner.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.headerImageView.alpha = 1;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
    
    secondaryHeaderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
    secondaryHeaderImage.contentMode = UIViewContentModeScaleAspectFill;
    secondaryHeaderImage.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/settingsbuttonsprefs.bundle/banner2.png"];
    secondaryHeaderImage.translatesAutoresizingMaskIntoConstraints = NO;
    secondaryHeaderImage.alpha = 0.0;
    [self.headerView addSubview:secondaryHeaderImage];

    [NSLayoutConstraint activateConstraints:@[
    [secondaryHeaderImage.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
    [secondaryHeaderImage.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
    [secondaryHeaderImage.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
    [secondaryHeaderImage.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    [UIView animateWithDuration:1.0 delay:0 options: UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        secondaryHeaderImage.alpha = 1.0;
        self.headerImageView.alpha = 0;
    } completion:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) offsetY = 0;
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

}

- (void)apply:(UIButton *)sender {
    
    popController = [[UIViewController alloc] init];
    popController.modalPresentationStyle = UIModalPresentationPopover;
    popController.preferredContentSize = CGSizeMake(200,130);
    UILabel *respringLabel = [[UILabel alloc] init];
    respringLabel.frame = CGRectMake(20, 20, 160, 60);
    respringLabel.numberOfLines = 2;
    respringLabel.textAlignment = NSTextAlignmentCenter;
    respringLabel.adjustsFontSizeToFitWidth = YES;
    respringLabel.font = [UIFont boldSystemFontOfSize:20];
    respringLabel.textColor = [UIColor labelColor];
    respringLabel.text = @"Are you sure you want to respring?";
    [popController.view addSubview:respringLabel];
    
    UIButton *yesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yesButton addTarget:self
                  action:@selector(handleYesGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    yesButton.frame = CGRectMake(100, 100, 100, 30);
    [popController.view addSubview:yesButton];
    
    UIButton *noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [noButton addTarget:self
                  action:@selector(handleNoGesture:)
     forControlEvents:UIControlEventTouchUpInside];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    noButton.frame = CGRectMake(0, 100, 100, 30);
    [popController.view addSubview:noButton];
     
    UIPopoverPresentationController *popover = popController.popoverPresentationController;
    popover.delegate = self;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.barButtonItem = respringButtonItem;
    //popover.sourceView = sender;
    //popover.sourceRect = CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height);
    
    [self presentViewController:popController animated:YES completion:nil];
    
    AudioServicesPlaySystemSound(1519);

}

- (void)handleYesGesture:(UIButton *)sender {
    AudioServicesPlaySystemSound(1521);

    pid_t pid;
    const char* args[] = {"killall", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)handleNoGesture:(UIButton *)sender {
    [popController dismissViewControllerAnimated:YES completion:nil];
}
@end

@implementation SETBTNSAppearanceSettings: HBAppearanceSettings

- (UIColor *)tintColor {

    UIColor *tintDynamicColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:131/255.0f green:156/255.0f blue:186/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:75/255.0f green:111/255.0f blue:155/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor colorWithRed:131/255.0f green:156/255.0f blue:186/255.0f alpha:1.0f];
        }
        return [UIColor colorWithRed:131/255.0f green:156/255.0f blue:186/255.0f alpha:1.0f];
    }];

    return tintDynamicColor;

}

- (UIColor *)tableViewCellSeparatorColor {

    return [UIColor clearColor];

}

- (UIColor *)tableViewCellBackgroundColor {
    
    UIColor *tableCellBackgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:186/255.0f green:204/255.0f blue:211/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
    }];

    return tableCellBackgroundColor;

}

- (UIColor *)tableViewCellSelectionColor {
    
    UIColor *tableCellSelectionColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:186/255.0f green:204/255.0f blue:211/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
        }
        return [UIColor colorWithRed:83/255.0f green:95/255.0f blue:109/255.0f alpha:1.0f];
    }];

    return tableCellSelectionColor;

}

- (UIColor *)tableViewCellTextColor {
    
    UIColor *tableCellTextColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor colorWithRed:196/255.0f green:212/255.0f blue:217/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor colorWithRed:94/255.0f green:107/255.0f blue:123/255.0f alpha:1.0f];
        }
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor colorWithRed:196/255.0f green:212/255.0f blue:217/255.0f alpha:1.0f];
        }
        return [UIColor colorWithRed:196/255.0f green:212/255.0f blue:217/255.0f alpha:1.0f];
    }];
    
    return tableCellTextColor;
    
}


@end
