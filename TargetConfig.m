//
//  TargetConfig.m
//  Enjoy
//
//  Created by Sam McCall on 6/05/09.
//

#import "TargetConfig.h"


@implementation TargetConfig

@synthesize config, onpress, myJsa;

-(id) init {
    if(self=[super init]) {
        configsController=[[[NSApplication sharedApplication] delegate] configsController];
    }
    return self;
}

-(NSString*) stringify {
	return [[NSString alloc] initWithFormat: @"cfg~%@~%d", [config name],onpress];
}

+(TargetConfig*) unstringifyImpl: (NSArray*) comps withConfigList: (NSArray*) configs {
	NSParameterAssert([comps count] > 1);
	NSString* name = [comps objectAtIndex: 1];
	TargetConfig* target = [[TargetConfig alloc] init];
	for(int i=0; i<[configs count]; i++)
		if([[[configs objectAtIndex:i] name] isEqualToString:name]) {
			[target setConfig: [configs objectAtIndex:i]];
            if([comps count]>2)[target setOnpress: (int)[[comps objectAtIndex:2] integerValue]];
            else [target setOnpress: 0];
			return target;
		}
	NSLog(@"Warning: couldn't find matching config to restore from: %@",name);
	return NULL;
}

-(void) trigger: (JoystickController *)jc {
    //NSLog(@"TC trigg op:%d config:%@",onpress,[config name]);
    if(onpress==0){
        [configsController activateConfig:config forApplication: NULL];
        [[config getTargetForAction:myJsa] setRunning:YES];
    }
}

-(void) untrigger: (JoystickController *)jc {
    //NSLog(@"TC untrg op:%d config:%@",onpress,[config name]);
    if(onpress==1){
        [configsController activateConfig:config forApplication: NULL];
        [[config getTargetForAction:myJsa] setRunning:NO];
    }
}


@end
