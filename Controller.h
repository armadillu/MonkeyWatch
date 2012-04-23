/* Controller */

#import <Cocoa/Cocoa.h>
#import "MyImageView.h"

@interface Controller : NSObject
{
    IBOutlet id menu;
	IBOutlet id aboutWin;
	IBOutlet NSWindow* prefsWin;
	IBOutlet MyImageView* dropBox;
	
	NSStatusItem	*_statusItem;
	NSTimer * timer;
}


- (IBAction)do:(id)sender;

@end
