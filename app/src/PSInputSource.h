// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface PSInputSource : NSObject
{
  TISInputSourceRef ref;
}

+ (PSInputSource*)currentInputSource;
+ (PSInputSource*)currentAsciiInputSource;

- (void)setValue:(TISInputSourceRef)value;
- (void)select;

- (NSString*)inputSourceId;
- (void)inspect;

@end
