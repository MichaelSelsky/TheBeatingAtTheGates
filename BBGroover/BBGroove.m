//
//  BBGroove.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/25/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBGroove.h"

@implementation BBGroove

#pragma mark Convenience Constructors
+ (id) groove {
	BBGroove *groove = [[BBGroove alloc] init];
	return groove;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_voices = @[];
	}
	return self;
}

#pragma mark Instance Methods
- (BBGrooverBeat) maxSubdivision {
    return [[_voices valueForKeyPath:@"@max.subdivision"] unsignedIntegerValue];
}

- (void) addVoice:(BBVoice *)object {
	NSParameterAssert(object);
	if (!object) {
		return;
	}
	
	NSMutableArray *newVoices = [NSMutableArray arrayWithArray:_voices];
    [newVoices addObject:object];
    
    _voices = newVoices;
}

@end
