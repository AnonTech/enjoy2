//
//  TargetKeyboard.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

@implementation TargetKeyboard

@synthesize vk, descr, mods;

const int FLAGNUM=5;
const CGKeyCode mod[FLAGNUM]={55,56,58,59,63};
const NSEventModifierFlags flags[FLAGNUM]={NSEventModifierFlagCommand,NSEventModifierFlagShift,NSEventModifierFlagOption,NSEventModifierFlagControl,NSEventModifierFlagFunction};

-(NSString*) stringify {
	return [[NSString alloc] initWithFormat: @"key~%d~%@", vk, descr];
}

+(TargetKeyboard*) unstringifyImpl: (NSArray*) comps {
	NSParameterAssert([comps count] == 3);
	TargetKeyboard* target = [[TargetKeyboard alloc] init];
    NSString *desc=[comps objectAtIndex:2];
    NSArray *modArray=[desc componentsSeparatedByString:@" "];
    unsigned long tmods=0;
    for(int i=0;i<[modArray count];i++){
        if([[modArray objectAtIndex:i] isEqualToString:@"cmd"])tmods|=flags[0];
        if([[modArray objectAtIndex:i] isEqualToString:@"shift"])tmods|=flags[1];
        if([[modArray objectAtIndex:i] isEqualToString:@"opt"])tmods|=flags[2];
        if([[modArray objectAtIndex:i] isEqualToString:@"ctrl"])tmods|=flags[3];
        if([[modArray objectAtIndex:i] isEqualToString:@"fn"])tmods|=flags[4];
    }
    [target setMods: tmods];
    [target setVk: [[comps objectAtIndex:1] integerValue]];
    [target setDescr: [comps objectAtIndex:2]];
	return target;
}

-(void) trigger: (JoystickController *)jc {
    for(int i=0;i<FLAGNUM;i++){
        if(mods & flags[i]){
            //NSLog(@"Creating key %hu %hu",mod[i], vk);
            CGEventRef modDown = CGEventCreateKeyboardEvent(NULL, mod[i], true);
	    CGEventSetFlags(modDown, ([NSEvent modifierFlags] | flags[i]));
            CGEventPost(kCGHIDEventTap, modDown);
            CFRelease(modDown);
	    usleep(500);
        }
    }
    
    CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, vk, true);
    CGEventSetFlags(keyDown, (mods | [NSEvent modifierFlags]));
    CGEventPost(kCGHIDEventTap, keyDown);
    CFRelease(keyDown);
    usleep(2000);
}

-(void) untrigger: (JoystickController *)jc {
	CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, vk, false);
	CGEventPost(kCGHIDEventTap, keyUp);
    //CGEventSetFlags(keyUp, mods);
	CFRelease(keyUp);
	usleep(2000);
	
    for(int i=0;i<FLAGNUM;i++){
        if(mods & flags[i]){
            CGEventRef modUp = CGEventCreateKeyboardEvent(NULL, mod[i], false);
            CGEventPost(kCGHIDEventTap, modUp);
            CFRelease(modUp);
	    usleep(500);
        }
    }
}


@end
