//
//  TargetScript.m
//  Enjoy2
//
//  Created by Aaron Schain on 11/18/17.
//

#import <Foundation/Foundation.h>
#import "TargetScript.h"

@implementation TargetScript

@synthesize scriptname;

-(NSString*) stringify {
    return [[NSString alloc] initWithFormat: @"scpt~%@", scriptname];
}

+(TargetScript*) unstringifyImpl: (NSArray*) comps {
    NSParameterAssert([comps count] == 2);
    TargetScript* target = [[TargetScript alloc] init];
    [target setScriptname: [comps objectAtIndex:1]];
    return target;
}

-(void) trigger: (JoystickController *)jc {
    [self runScript: scriptname];
}

-(void) untrigger: (JoystickController *)jc {
}

-(void) runScript:(NSString*)scriptName
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    NSArray *arguments= [NSArray arrayWithObjects:scriptname, nil];
    [task setArguments: arguments];
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    NSLog (@"script returned:\n%@", string);
}

@end
