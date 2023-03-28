//
//  RCTSwiftLog.h
//  nativeUIModulesTest
//
//  Created by Dominic Go on 6/27/20.
//

#import <Foundation/Foundation.h>

@interface _RNILog : NSObject

+ (void)error:(NSString * _Nonnull)message file:(NSString * _Nonnull)file line:(NSUInteger)line;

+ (void)warn:(NSString * _Nonnull)message file:(NSString * _Nonnull)file line:(NSUInteger)line;

+ (void)info:(NSString * _Nonnull)message file:(NSString * _Nonnull)file line:(NSUInteger)line;

+ (void)log:(NSString * _Nonnull)message file:(NSString * _Nonnull)file line:(NSUInteger)line;

+ (void)trace:(NSString * _Nonnull)message file:(NSString * _Nonnull)file line:(NSUInteger)line;

@end
