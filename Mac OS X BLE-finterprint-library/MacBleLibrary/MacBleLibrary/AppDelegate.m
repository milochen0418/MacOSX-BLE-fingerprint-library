//
//  AppDelegate.m
//  MacBleLibrary
//
//  Created by Milo Chen on 1/2/14.
//  Copyright (c) 2014 Milo Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "BtPairAndConnectWindowController.h"

@interface AppDelegate()
{
    BtPairAndConnectWindowController * mBtPairAndConnectWindowController;
}

@end



@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)clickToBtPairAndConnect:(id)sender {

    if(mBtPairAndConnectWindowController != nil ) {
        [mBtPairAndConnectWindowController close];
        mBtPairAndConnectWindowController = nil;
    }
    
    
    BtPairAndConnectWindowController * wc = [[BtPairAndConnectWindowController alloc] initWithWindowNibName:@"BtPairAndConnectWindowController"];
    
    [wc showWindow:self];
    mBtPairAndConnectWindowController = wc;
 

    
}


@end
