//
//  TargetConfig.h
//  Enjoy
//
//  Created by Sam McCall on 6/05/09.
//  Copyright 2009 University of Otago. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Config;
@class Target;

@interface TargetConfig : Target {
    ConfigsController* configsController;
    Config *config;
    int onpress;
    NSString* myJsaKey;
}

@property(readwrite, retain) Config* config;
@property(readwrite) int onpress;
@property(readwrite,retain) NSString* myJsaKey;

+(TargetConfig*) unstringifyImpl: (NSArray*) comps withConfigList: (NSArray*) configs;

@end
