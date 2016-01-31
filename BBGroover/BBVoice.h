//
//  BBVoice.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/24/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BBGroover/BBGrooverBeat.h>

NS_ASSUME_NONNULL_BEGIN

@interface BBVoice : NSObject

@property (nonatomic, strong, readonly) NSArray <NSNumber *>	*values;
@property (nonatomic, strong, readonly) NSArray <NSNumber *>	*velocities;
@property (nonatomic, strong) NSString							*name;
@property (nonatomic, strong) NSString							*audioPath;
@property (nonatomic, assign, readonly) BBGrooverBeat			subdivision;

#pragma mark Initializers
- (instancetype) initWithValues:(NSArray <NSNumber *> *)values;
- (instancetype) initWithValues:(NSArray <NSNumber *> *)values andVelocities:(NSArray <NSNumber *> *)velocities;
- (instancetype) initWithSubdivision:(BBGrooverBeat)subdivision;

#pragma mark Convenience Contructors
+ (instancetype) voiceWithValues:(NSArray <NSNumber *> *)values;
+ (instancetype) voiceWithValues:(NSArray <NSNumber *> *)values andVelocities:(NSArray <NSNumber *> *)velocities;
+ (instancetype) voiceWithSubdivision:(BBGrooverBeat)subdivision;

#pragma mark Instance Methods
- (void) setValue:(BOOL)value forIndex:(NSUInteger)index;
- (void) setVelocity:(float)velocity forIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
