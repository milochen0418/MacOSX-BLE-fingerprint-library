//
//  GlobalVars.m
//  MacBleLibrary
//
//  Created by Milo Chen on 1/2/14.
//  Copyright (c) 2014 Milo Chen. All rights reserved.
//

#import "GlobalVars.h"

@implementation GlobalVars


+(GlobalVars*) sharedInstance {
    static GlobalVars * vars = nil;
    if(vars == nil) {
        vars = [[GlobalVars alloc] init];
    }
    return vars;
}


@end
