//
//  TargetScript.m
//  Enjoy2
//
//  Created by Aaron Schain on 11/18/17.
//
#import "TargetScript.h"
@implementation TargetScript

@synthesize scriptPath;

-(NSString*) stringify {
    return [[NSString alloc] initWithFormat: @"scpt~%@", scriptPath];
}

+(TargetScript*) unstringifyImpl: (NSArray*) comps {
    NSParameterAssert([comps count] == 2);
    TargetScript* target = [[TargetScript alloc] init];
    NSLog(@"unstringifying TS: %@",[comps objectAtIndex:1]);
    [target setScriptPath: (NSString*)[comps objectAtIndex:1]];
    return target;
}

-(void) trigger: (JoystickController *)jc {
    NSLog(@"Running script %@",scriptPath);
    [self runScript];
}

-(void) untrigger: (JoystickController *)jc {
}

-(void) runScript
{
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    NSArray *arguments= [NSArray arrayWithObjects:scriptPath, nil];
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
