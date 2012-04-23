#import "Controller.h"

@implementation Controller

-(void)awakeFromNib{
	
	_statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [_statusItem setHighlightMode:YES];
    [_statusItem setEnabled:YES];
    [_statusItem setMenu:menu];
	[_statusItem setTarget:self];
	[_statusItem setImage:[NSImage imageNamed:@"menubar.png"]];
	timer = [NSTimer scheduledTimerWithTimeInterval: 3 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer: timer forMode:NSEventTrackingRunLoopMode];
	[[NSGraphicsContext currentContext]setImageInterpolation:NSImageInterpolationHigh];
	
	[dropBox loadPrefs];
	[self refresh];

}

-(void)click{
	NSLog(@"click");
}


-(void)refresh{
	if ([dropBox getAppBundleID] == nil){
		[_statusItem setImage:[NSImage imageNamed:@"menubar2.png"]];
		return;
	}

	NSArray * apps = [NSRunningApplication runningApplicationsWithBundleIdentifier: [dropBox getAppBundleID]];
	
	NSString * filter = [dropBox getAppBundleID];
	BOOL running = NO;
	
	for (NSRunningApplication* app in apps){	
		if ( [app.bundleIdentifier isEqualToString: filter] ){
			running = YES;
			//NSLog(@"app %@ is running", app);
		}
	}
	
	if (!running){		
		NSLog(@"App not running! relaunching (%@)", [dropBox getAppPath]);
		[_statusItem setImage:[NSImage imageNamed:@"menubar2.png"]];
		[[NSWorkspace sharedWorkspace] launchApplication: [dropBox getAppPath]];
		
	}else{
		if ( [apps count] > 0 ){
			[(NSRunningApplication*)[apps objectAtIndex:0] activateWithOptions: NSApplicationActivateIgnoringOtherApps];
		}
		[_statusItem setImage:[NSImage imageNamed:@"menubar.png"]];
	}
}


- (IBAction)do:(id)sender{
	
	switch ([sender tag]) {
		
		case 0: //about
			[aboutWin performSelector:@selector(makeKeyAndOrderFront:) withObject:self afterDelay:0.0];
			[aboutWin center];
			[aboutWin setLevel:NSTornOffMenuWindowLevel];
			break;

		case 1: //quit
			[dropBox savePrefs];
			[[NSApplication sharedApplication] terminate:self];
			break;

		case 2: //prefs
			[prefsWin performSelector:@selector(makeKeyAndOrderFront:) withObject:self afterDelay:0.0];
			[prefsWin setLevel:NSTornOffMenuWindowLevel];
			[prefsWin center];
			break;

		default:
			break;
	}
}
@end