//
//  MyImageView.m
//  MenuApp
//
//  Created by Oriol Ferrer Mesià on 23/04/12.
//  Copyright 2012 uri.cat. All rights reserved.
//

#import "MyImageView.h"


@implementation MyImageView

- (id)initWithFrame:(NSRect)frame{
    self = [super initWithFrame:frame];    	
    return self;
}

- (void)savePrefs{
    [self unregisterDraggedTypes];
	NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
	[d setObject: appPath forKey:@"appPath"];
	[d setObject: bundleName forKey:@"bundleName"];
	[d setObject: imgPath forKey:@"imgPath"];	
	[d synchronize];
    [super dealloc];
}

-(void)loadPrefs{
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	NSUserDefaults * d = [NSUserDefaults standardUserDefaults];
	appPath = [d objectForKey:@"appPath"];
	bundleName = [d objectForKey:@"bundleName"];
	imgPath = [d objectForKey:@"imgPath"];
	if (imgPath != nil){
		_ourImage = [[NSImage alloc] initWithContentsOfFile: imgPath];
		[super setImage: _ourImage];
	}	
	
}

-(NSString*) getAppPath;{
	return appPath;
}

-(NSString*) getAppBundleID;{
	return bundleName;
}


- (void)setImage:(NSImage *)newImage{	
    NSImage *temp = [newImage retain];
    [_ourImage release];
    _ourImage = temp;
}

- (NSImage *)image{
    return _ourImage;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
                == NSDragOperationGeneric)
    {
        return NSDragOperationGeneric;
    }else{
        return NSDragOperationNone;
    }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender{}


- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask]) 
                    == NSDragOperationGeneric)
    {
        return NSDragOperationGeneric;
    }else{
        return NSDragOperationNone;
    }
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender{}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender{
    return YES;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
	
    NSPasteboard *paste = [sender draggingPasteboard];
    NSArray *types = [NSArray arrayWithObjects: NSFilenamesPboardType, nil];
    NSString *desiredType = [paste availableTypeFromArray:types];
    NSData *carriedData = [paste dataForType:desiredType];

    if (nil == carriedData){
        NSRunAlertPanel(@"Paste Error", @"Sorry, but the past operation failed", nil, nil, nil);
        return NO;

    }else{
		
        
        if ([desiredType isEqualToString:NSFilenamesPboardType]){
            //we have a list of file names in an NSData object
			NSArray *fileArray = [paste propertyListForType:@"NSFilenamesPboardType"];
			NSString *path = [fileArray objectAtIndex:0];
			NSLog(@"path: %@", path);
			appPath = path;
			[appPath retain];
			NSDictionary * appPlist = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Contents/Info.plist", appPath]];
			
			bundleName = [appPlist objectForKey:@"CFBundleIdentifier"];
			[bundleName retain];
			NSLog(@"bundleName: %@", bundleName);						
			
			NSString * iconName = [appPlist objectForKey:@"CFBundleIconFile"];			
			NSLog(@"iconName: %@", iconName);
			
			imgPath = [NSString stringWithFormat:@"%@/Contents/Resources/%@", appPath, iconName];
			_ourImage = [[NSImage alloc] initWithContentsOfFile: imgPath];
			if (_ourImage == nil){
				imgPath = [NSString stringWithFormat:@"%@/Contents/Resources/%@.icns", appPath, iconName];
				_ourImage = [[NSImage alloc] initWithContentsOfFile: imgPath];
			}
			[imgPath retain];
			[super setImage: _ourImage];

        }else{
			
            NSAssert(NO, @"This can't happen");
            return NO;
        }
    }
    [self setNeedsDisplay:YES];    //redraw us with the new image
    return YES;
}


- (void)concludeDragOperation:(id <NSDraggingInfo>)sender{
    [self setNeedsDisplay:YES];
}


@end
