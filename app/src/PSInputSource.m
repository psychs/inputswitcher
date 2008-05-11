// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import "PSInputSource.h"

@interface PSInputSource (Private)
- (void)inspect;
@end


@implementation PSInputSource

- (id)init
{
  self = [super init];
  ref = NULL;
  return self;
}

- (void)dealloc
{
  if (ref) CFRelease(ref);
  [super dealloc];
}

+ (PSInputSource*)currentInputSource
{
  PSInputSource* r = [[[PSInputSource alloc] init] autorelease];
  [r setValue:TISCopyCurrentKeyboardInputSource()];
  return r;
}

+ (PSInputSource*)currentAsciiInputSource
{
  PSInputSource* r = [[[PSInputSource alloc] init] autorelease];
  [r setValue:TISCopyCurrentASCIICapableKeyboardInputSource()];
  return r;
}

- (void)setValue:(TISInputSourceRef)value
{
  if (ref) CFRelease(ref);
  ref = value;
}

- (void)select
{
  if (ref) {
    TISSelectInputSource(ref);
    //[self inspect];
  }
}

- (NSString*)inputSourceId
{
  return (NSString*)TISGetInputSourceProperty(ref, kTISPropertyInputSourceID);
}

- (void)inspect
{
  NSLog(@"LocalizedName: %@", TISGetInputSourceProperty(ref, kTISPropertyLocalizedName));
  //NSLog(@"InputSourceType: %@", TISGetInputSourceProperty(ref, kTISPropertyInputSourceType));
  NSLog(@"InputSourceID: %@", TISGetInputSourceProperty(ref, kTISPropertyInputSourceID));
  //NSLog(@"BundleID: %@", TISGetInputSourceProperty(ref, kTISPropertyBundleID));
  //NSLog(@"InputModeID: %@", TISGetInputSourceProperty(ref, kTISPropertyInputModeID));
  //NSLog(@"Languages: %@", TISGetInputSourceProperty(ref, kTISPropertyInputSourceLanguages));
}

@end
