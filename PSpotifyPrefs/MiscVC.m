#import "MiscVC.h"


@implementation MiscVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"PSMisc" target:self];
	return _specifiers;

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:prefsKeys atomically:YES];

	NSString *key = [specifier propertyForKey:@"key"];
	if(![key isEqualToString:@"enableLyricsForAllTracks"]) return;
	if(![[self readPreferenceValue:[self specifierForID:@"LyricsSwitch"]] boolValue]) return;

	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PerfectSpotify" message:@"No, this switch won't enable lyrics if they aren't already available for your country. What it does is to 'unlock' them for new released songs which for some reason still don't have them. Do you understand? You better, I don't want to get DM's about this ok? Lol just kidding, but yeah." preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Got it" style:UIAlertActionStyleDefault handler:nil];
	[alertController addAction:confirmAction];
	[self presentViewController:alertController animated:YES completion:nil];

	[super setPreferenceValue:value specifier:specifier];

}


@end


@implementation NowPlayingUIVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Now Playing UI" target:self];
	return _specifiers;

}


@end


@implementation SpringBoardVC


- (NSArray *)specifiers {

	if(!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"SpringBoard" target:self];
	return _specifiers;

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:prefsKeys atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	[NSNotificationCenter.defaultCenter postNotificationName:@"updateShortcutItems" object:nil];

}


@end


@implementation ExtraFeaturesVC


- (NSArray *)specifiers {

	if(!_specifiers) {

		_specifiers = [self loadSpecifiersFromPlistName:@"++ Features" target:self];

		NSArray *chosenIDs = @[
			@"ArtworkBasedColorsSwitch",
			@"GroupCell1",
			@"HapticsSwitch",
			@"GroupCell2",
			@"HapticsOptionsCell",
			@"GroupCell3",
			@"CanvasOptionsCell"
		];

		self.savedSpecifiers = self.savedSpecifiers ?: [NSMutableDictionary new];

		for(PSSpecifier *specifier in _specifiers)

			if([chosenIDs containsObject:[specifier propertyForKey:@"id"]])

				[self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];

	}

	return _specifiers;

}


- (void)viewDidLoad {

	[super viewDidLoad];
	[self reloadSpecifiers];

}


- (void)reloadSpecifiers {

	[super reloadSpecifiers];

	if(![[self readPreferenceValue:[self specifierForID:@"SpotifyUISwitch"]] boolValue])

		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"ArtworkBasedColorsSwitch"], self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"HapticsSwitch"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"HapticsOptionsCell"]] animated:NO];


	else if(![self containsSpecifier:self.savedSpecifiers[@"ArtworkBasedColorsSwitch"]])

		[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"ArtworkBasedColorsSwitch"], self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"HapticsSwitch"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"HapticsOptionsCell"]] afterSpecifierID:@"SpotifyUISwitch" animated:NO];


	if(![[self readPreferenceValue:[self specifierForID:@"SaveCanvasSwitch"]] boolValue]) {

		[self removeSpecifier:self.savedSpecifiers[@"GroupCell3"] animated:NO];
		[self removeSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"] animated:NO];

	}

	else if(![self containsSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"]]) {

		[self insertSpecifier:self.savedSpecifiers[@"GroupCell3"] afterSpecifierID:@"SaveCanvasSwitch" animated:NO];
		[self insertSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"] afterSpecifierID:@"GroupCell3" animated:NO];

	}

}


- (id)readPreferenceValue:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];

}


- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {

	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:prefsKeys]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:prefsKeys atomically:YES];

	[super setPreferenceValue:value specifier:specifier];

	NSString *key = [specifier propertyForKey:@"key"];

	if([key isEqualToString:@"enableSpotifyUI"]) {

		if(![[self readPreferenceValue:[self specifierForID:@"SpotifyUISwitch"]] boolValue])

			[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"ArtworkBasedColorsSwitch"], self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"HapticsSwitch"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"HapticsOptionsCell"]] animated:YES];

		else if(![self containsSpecifier:self.savedSpecifiers[@"ArtworkBasedColorsSwitch"]])

			[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"ArtworkBasedColorsSwitch"], self.savedSpecifiers[@"GroupCell1"], self.savedSpecifiers[@"HapticsSwitch"], self.savedSpecifiers[@"GroupCell2"], self.savedSpecifiers[@"HapticsOptionsCell"]] afterSpecifierID:@"SpotifyUISwitch" animated:YES];
		
	}

	if([key isEqualToString:@"saveCanvas"]) {

		if(![value boolValue]) {

			[self removeSpecifier:self.savedSpecifiers[@"GroupCell3"] animated:YES];
			[self removeSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"] animated:YES];

		}

		else if(![self containsSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"]]) {

			[self insertSpecifier:self.savedSpecifiers[@"GroupCell3"] afterSpecifierID:@"SaveCanvasSwitch" animated:YES];
			[self insertSpecifier:self.savedSpecifiers[@"CanvasOptionsCell"] afterSpecifierID:@"GroupCell3" animated:YES];

		}

	}

}

@end
