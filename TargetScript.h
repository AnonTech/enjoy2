//
//  TargetScript.h
//  Enjoy2
//
//  Created by Aaron Schain on 11/18/17.
//
//

#import "Target.h"
@class Target;

@interface TargetScript : Target {
    NSString* scriptname;
}

@property(readwrite) NSString* scriptname;

+(TargetScript*) unstringifyImpl: (NSArray*) comps;

@end

