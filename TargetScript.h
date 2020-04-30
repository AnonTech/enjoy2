//
//  TargetScript.h
//  Enjoy2
//
//  Created by Aaron Schain on 11/18/17.
//
//
#import <Foundation/Foundation.h>
@class Target;

@interface TargetScript : Target {
    NSString* scriptPath;
}

@property(readwrite,copy) NSString* scriptPath;

+(TargetScript*) unstringifyImpl: (NSArray*) comps;

@end

