#import "PSRootVC.h"


@implementation PSRootVC {

	UIImageView *iconView;
	UIButton *killButton;
	UIButton *changelogButton;
	UIView *headerView;
	UIImageView *headerImageView;
	OBWelcomeController *changelogController;

}


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;

}


- (id)init {

	self = [super init];
	if(self) [self setupUI];
	return self;

}


- (void)setupUI {

	UIImage *icon = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PSpotifyPrefs.bundle/Assets/PSIcon@2x.png"];;
	UIImage *banner = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PSpotifyPrefs.bundle/Assets/PSBanner.png"];

	changelogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
	changelogButton.tintColor = kPSpotifyTintColor;
	[changelogButton setImage:[UIImage systemImageNamed:@"atom"] forState:UIControlStateNormal];
	[changelogButton addTarget:self action:@selector(showWtfChangedInThisVersion) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *changelogButtonItem = [[UIBarButtonItem alloc] initWithCustomView:changelogButton];

	killButton = [UIButton buttonWithType:UIButtonTypeCustom];
	killButton.tintColor = kPSpotifyTintColor;
	[killButton setImage:[UIImage systemImageNamed:@"checkmark.circle"] forState:UIControlStateNormal];
	[killButton addTarget:self action:@selector(killSpotify) forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *killButtonItem = [[UIBarButtonItem alloc] initWithCustomView:killButton];

	NSArray *rightButtons;
	rightButtons = @[killButtonItem, changelogButtonItem];
	self.navigationItem.rightBarButtonItems = rightButtons;

	self.navigationItem.titleView = [UIView new];
	iconView = [UIImageView new];
	iconView.image = icon;
	iconView.contentMode = UIViewContentModeScaleAspectFit;
	iconView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.navigationItem.titleView addSubview:iconView];

	headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	headerImageView = [UIImageView new];
	headerImageView.image = banner;
	headerImageView.contentMode = UIViewContentModeScaleAspectFill;
	headerImageView.translatesAutoresizingMaskIntoConstraints = NO;
	[headerView addSubview:headerImageView];

	[self layoutUI];

}


- (void)layoutUI {

	[iconView.topAnchor constraintEqualToAnchor: self.navigationItem.titleView.topAnchor].active = YES;
	[iconView.bottomAnchor constraintEqualToAnchor: self.navigationItem.titleView.bottomAnchor].active = YES;
	[iconView.leadingAnchor constraintEqualToAnchor: self.navigationItem.titleView.leadingAnchor].active = YES;
	[iconView.trailingAnchor constraintEqualToAnchor: self.navigationItem.titleView.trailingAnchor].active = YES;

	[headerImageView.topAnchor constraintEqualToAnchor: headerView.topAnchor].active = YES;
	[headerImageView.bottomAnchor constraintEqualToAnchor: headerView.bottomAnchor].active = YES;
	[headerImageView.leadingAnchor constraintEqualToAnchor: headerView.leadingAnchor].active = YES;
	[headerImageView.trailingAnchor constraintEqualToAnchor: headerView.trailingAnchor].active = YES;

}


- (void)killSpotify {

	AudioServicesPlaySystemSound(1521);

	pid_t pid;
	const char* args[] = {"killall", "Spotify", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PerfectSpotify" message:@"Spotify was succesfully destroyed and shattered into pieces, shall we rebuild it by launching it again?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

		[self launchSpotify];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Maybe later" style:UIAlertActionStyleDefault handler:nil];

	[alertController addAction: confirmAction];
	[alertController addAction: cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)launchSpotify {

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		[UIApplication.sharedApplication launchApplicationWithIdentifier:@"com.spotify.client" suspended:0];

	});

}


- (void)showWtfChangedInThisVersion {

	AudioServicesPlaySystemSound(1521);

	UIImage *tweakIconImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/PSpotifyPrefs.bundle/Assets/PSpotifyIcon.png"];
	UIImage *checkmarkImage = [UIImage systemImageNamed:@"checkmark.circle.fill"];

	changelogController = [[OBWelcomeController alloc] initWithTitle:@"PerfectSpotify" detailText:@"2.3~EOL" icon: tweakIconImage];
	[changelogController addBulletedListItemWithTitle:@"Tweak" description:@"Please visit the source on GitHub to see the changelog." image: checkmarkImage];

	_UIBackdropViewSettings *settings = [_UIBackdropViewSettings settingsForStyle:2];

	_UIBackdropView *backdropView = [[_UIBackdropView alloc] initWithSettings:settings];	
	backdropView.clipsToBounds = YES;
	backdropView.layer.masksToBounds = YES;
	backdropView.translatesAutoresizingMaskIntoConstraints = NO;
	[changelogController.viewIfLoaded insertSubview:backdropView atIndex:0];

	[backdropView.topAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.topAnchor].active = YES;
	[backdropView.bottomAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.bottomAnchor].active = YES;
	[backdropView.leadingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.leadingAnchor].active = YES;
	[backdropView.trailingAnchor constraintEqualToAnchor: changelogController.viewIfLoaded.trailingAnchor].active = YES;

	changelogController.view.tintColor = kPSpotifyTintColor;
	changelogController.modalInPresentation = NO;
	changelogController.modalPresentationStyle = UIModalPresentationPageSheet;
	changelogController.viewIfLoaded.backgroundColor = UIColor.clearColor;

	[self presentViewController:changelogController animated:YES completion:nil];

}


- (void)resetPreferences {

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PerfectSpotify" message:@"Do You Really Want To Reset Your Preferences?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Shoot" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {

		NSFileManager *fileM = [NSFileManager defaultManager];

		BOOL success = [fileM removeItemAtPath:@"/var/mobile/Library/Preferences/me.luki.perfectspotifyprefs.plist" error:nil];
		if(success) [self crossDissolveBlur];

	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Maybe not" style:UIAlertActionStyleCancel handler:nil];

	[alertController addAction:confirmAction];
	[alertController addAction:cancelAction];

	[self presentViewController:alertController animated:YES completion:nil];

}


- (void)crossDissolveBlur {

	UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	blurView.alpha = 0;
	blurView.frame = self.view.bounds;
	[self.view addSubview:blurView];

	[UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

		blurView.alpha = 1;

	} completion:^(BOOL finished) { [self launchRespring]; }];

}


- (void)launchRespring {

	pid_t pid;
	const char* args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);

}


// Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	tableView.tableHeaderView = headerView;
	return [super tableView:tableView cellForRowAtIndexPath:indexPath];

}


@end


@implementation PSContributorsVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"PSContributors" target:self];
	return _specifiers;

}


@end


@implementation PSLinksVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"PSLinks" target:self];
	return _specifiers;

}


- (void)launchLyricsLink {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://techcrunch.com/2020/06/29/in-a-significant-expansion-spotify-to-launch-real-time-lyrics-in-26-markets/"] options:@{} completionHandler:nil];

}


- (void)launchPayPal {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://paypal.me/Luki120"] options:@{} completionHandler:nil];

}


- (void)launchGitHub {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://github.com/Luki120/PerfectSpotify"] options:@{} completionHandler:nil];

}


- (void)launchAmelija {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/me.luki.amelija"] options:@{} completionHandler:nil];

}


- (void)launchApril {

	[UIApplication.sharedApplication openURL:[NSURL URLWithString: @"https://repo.twickd.com/get/com.twickd.luki120.april"] options:@{} completionHandler:nil];

}


@end


@implementation PSpotifyTableCell


- (void)setTitle:(NSString *)t {

	[super setTitle:t];
	self.titleLabel.textColor = kPSpotifyTintColor;

}


@end
