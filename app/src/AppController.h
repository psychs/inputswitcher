// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import <Cocoa/Cocoa.h>
#import "PSInputSource.h"

@interface AppController : NSObject
{
  int activePid;
  BOOL qs;
  NSMutableDictionary* processDic;
}
@end
