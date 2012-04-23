//
//  MyImageView.h
//  MenuApp
//
//  Created by Oriol Ferrer Mesià on 23/04/12.
//  Copyright 2012 uri.cat. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MyImageView : NSImageView
{
    NSImage *_ourImage;
	NSString * appPath;
	NSString * bundleName;
	NSString * imgPath;
	
}

-(NSString*) getAppPath;
-(NSString*) getAppBundleID;

- (void)setImage:(NSImage *)newImage;

-(void)loadPrefs;
-(void)savePrefs;

- (NSImage *)image;

@end