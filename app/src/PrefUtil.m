// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import "PrefUtil.h"

@implementation PrefUtil

+ (BOOL)isAppInLoginItems
{
  NSMutableArray* loginItems = (NSMutableArray*)CFPreferencesCopyValue((CFStringRef)@"AutoLaunchedApplicationDictionary",
                                (CFStringRef)@"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  NSString* appPath = [[NSBundle mainBundle] bundlePath];
  BOOL result = NO;
  
  if (loginItems) {
    // determine if App is in the list
    NSEnumerator* e = [loginItems objectEnumerator];
    NSDictionary* i;
    while (i = [e nextObject]) {
      if ([[i objectForKey:@"Path"] isEqualToString:appPath]) {
        result = YES;
        break;
      }
    }
  }
  
  [loginItems release];
  return result;
}

+ (void)setAppInLoginItems:(BOOL)doAdd 
{
  // at first, get the login items from loginwindow pref
  NSMutableArray* loginItems = (NSMutableArray*)CFPreferencesCopyValue((CFStringRef)@"AutoLaunchedApplicationDictionary",
                                (CFStringRef)@"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
  NSString* appPath = [[NSBundle mainBundle] bundlePath];
  BOOL changed = NO;
  BOOL found = NO;
  int index = 0;

  if (loginItems) {
    // determine if App is in the list
    NSEnumerator* e = [loginItems objectEnumerator];
    NSDictionary* i;
    while (i = [e nextObject]) {
      if ([[i objectForKey:@"Path"] isEqualToString:appPath]) {
        found = YES;
        break;
      }
      index++;
    }
  }

  if (doAdd && !found) {
    // create a new item and add it to the list
    FSRef fsref;
    OSStatus result = FSPathMakeRef((const UInt8*)[appPath fileSystemRepresentation], &fsref, NULL);

    if (loginItems) {
      loginItems = [[loginItems autorelease] mutableCopy];
    } else {
      loginItems = [[NSMutableArray alloc] init];
    }
    
    if (result == noErr) {
      AliasHandle alias = NULL;

      //make alias record             
      result = FSNewAlias(NULL, &fsref, &alias);
      if (result == noErr && alias != NULL) {
        // add the item
        NSDictionary* myStartupItem = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSData dataWithBytes:*alias length:GetHandleSize((Handle)alias)],
                                        @"AliasData", [NSNumber numberWithBool:NO], @"Hide", appPath, @"Path", nil];
        [loginItems addObject:myStartupItem];
        
        // release the new alias handle
        DisposeHandle((Handle)alias);
        changed = YES;
      }
    }
  } else if (!doAdd && found) {
    // remove the item
    loginItems = [[loginItems autorelease] mutableCopy];
    [loginItems removeObjectAtIndex:index];
    changed = YES;
  }

  if (changed) {
    // save system settings
    CFPreferencesSetValue((CFStringRef)@"AutoLaunchedApplicationDictionary", loginItems,
                          (CFStringRef)@"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost); 
    CFPreferencesSynchronize((CFStringRef) @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost); 
  }
  
  [loginItems release];
}

@end
