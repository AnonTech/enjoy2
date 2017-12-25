//
//  TargetKeyboard.m
//  Enjoy
//
//  Created by Sam McCall on 5/05/09.
//

@implementation TargetKeyboard

static int cmod=0;

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

+(int) cmod{
    return cmod;
}
+(void) setCmod: (int) newmod{
    cmod=newmod;
}

-(void) trigger: (JoystickController *)jc {
    for(int i=0;i<FLAGNUM;i++){
        if(mods & flags[i]){
            //NSLog(@"Creating key %hu %hu",mod[i], vk);
            CGEventRef modDown = CGEventCreateKeyboardEvent(NULL, mod[i], true);
            CGEventPost(kCGHIDEventTap, modDown);
            CFRelease(modDown);
        }
    }
    int tempcmod=[TargetKeyboard cmod];
    
	CGEventRef keyDown = CGEventCreateKeyboardEvent(NULL, vk, true);
    CGEventSetFlags(keyDown, (mods | tempcmod));
	CGEventPost(kCGHIDEventTap, keyDown);
    CFRelease(keyDown);
    
    if(vk==0x3f ){tempcmod|=NSEventModifierFlagFunction;}
    if((vk==0x37 || vk==0x36)) {tempcmod|=NSEventModifierFlagCommand;}
    if((vk==0x38 || vk==0x3c)) {tempcmod|=NSEventModifierFlagShift;}
    if((vk==0x3a || vk==0x3d)) {tempcmod|=NSEventModifierFlagOption;}
    if((vk==0x3b || vk==0x3c)) {tempcmod|=NSEventModifierFlagControl;}
    [TargetKeyboard setCmod:tempcmod];
}

-(void) untrigger: (JoystickController *)jc {
	CGEventRef keyUp = CGEventCreateKeyboardEvent(NULL, vk, false);
	CGEventPost(kCGHIDEventTap, keyUp);
    //CGEventSetFlags(keyUp, mods);
	CFRelease(keyUp);
    for(int i=0;i<FLAGNUM;i++){
        if(mods & flags[i]){
            CGEventRef modUp = CGEventCreateKeyboardEvent(NULL, mod[i], false);
            CGEventPost(kCGHIDEventTap, modUp);
            CFRelease(modUp);
        }
    }
    int tempcmod=[TargetKeyboard cmod];
    if(vk==0x3f && (tempcmod&NSEventModifierFlagFunction)){tempcmod^=NSEventModifierFlagFunction;}
    if((vk==0x37 || vk==0x36) && (tempcmod&NSEventModifierFlagCommand)) {tempcmod^=NSEventModifierFlagCommand;}
    if((vk==0x38 || vk==0x3c) && (tempcmod&NSEventModifierFlagShift)) {tempcmod^=NSEventModifierFlagShift;}
    if((vk==0x3a || vk==0x3d) && (tempcmod&NSEventModifierFlagOption)) {tempcmod^=NSEventModifierFlagOption;}
    if((vk==0x3b || vk==0x3c) && (tempcmod&NSEventModifierFlagControl)) {tempcmod^=NSEventModifierFlagControl;}
    [TargetKeyboard setCmod:tempcmod];
}


@end
