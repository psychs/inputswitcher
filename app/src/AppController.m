// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import "AppController.h"
#import "PrefUtil.h"

static NSString* NOTE_BECOME_ACTIVE = @"InputSwitcherClientDidBecomeActive";
static NSString* NOTE_RESIGN_ACTIVE = @"InputSwitcherClientWillResignActive";
static NSString* NOTE_TERMINATE = @"InputSwitcherClientWillTerminate";
static NSString* NOTE_QS_ACTIVATE = @"InputSwitcherQSInterfaceActivated";
static NSString* NOTE_QS_DEACTIVATE = @"InputSwitcherQSInterfaceDeactivated";

//#define DEBUG

@implementation AppController

- (id)init
{
  self = [super init];
  processDic = [[NSMutableDictionary alloc] init];
  return self;
}

- (void)dealloc
{
  [processDic release];
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification*)note
{
#ifndef DEBUG
  if (![PrefUtil isAppInLoginItems]) [PrefUtil setAppInLoginItems:YES];
#endif
  
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c addObserver:self selector:@selector(clientDidBecomeActive:) name:NOTE_BECOME_ACTIVE object:nil];
  [c addObserver:self selector:@selector(clientWillResignActive:) name:NOTE_RESIGN_ACTIVE object:nil];
  [c addObserver:self selector:@selector(clientWillTerminate:) name:NOTE_TERMINATE object:nil];
  [c addObserver:self selector:@selector(qsInterfaceActivated:) name:NOTE_QS_ACTIVATE object:nil];
  [c addObserver:self selector:@selector(qsInterfaceDeactivated:) name:NOTE_QS_DEACTIVATE object:nil];
}

- (void)applicationWillTerminate:(NSNotification*)note
{
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c removeObserver:self name:NOTE_BECOME_ACTIVE object:nil];
  [c removeObserver:self name:NOTE_RESIGN_ACTIVE object:nil];
  [c removeObserver:self name:NOTE_TERMINATE object:nil];
  [c removeObserver:self name:NOTE_QS_ACTIVATE object:nil];
  [c removeObserver:self name:NOTE_QS_DEACTIVATE object:nil];
}

- (void)clientDidBecomeActive:(NSNotification*)note
{
  NSDictionary* dic = [note userInfo];
  NSNumber* pid = [dic objectForKey:@"pid"];
  NSString* appid = [dic objectForKey:@"appid"];
#ifdef DEBUG
  NSString* appname = [dic objectForKey:@"appname"];
  NSLog(@"+++ active %d %@ %@", [pid intValue], appid, appname);
#endif

  // store the current source
  if (qs) {
    // for qs
    if (appid && [appid isEqualTo:@"com.blacktree.Quicksilver"]) return;
    qs = NO;
  } else if (activePid == 0) {
    // for not supported applications
    [processDic setObject:[PSInputSource currentInputSource] forKey:[NSNumber numberWithInteger:0]];
  } else if (activePid != [pid intValue]) {
    // for other applications
    [processDic setObject:[PSInputSource currentInputSource] forKey:[NSNumber numberWithInteger:activePid]];
  }
  
  activePid = [pid intValue];
  
  // restore the previous source
  PSInputSource* state = [processDic objectForKey:[NSNumber numberWithInteger:activePid]];
  if (state) {
    [state select];
  } else {
    [[PSInputSource currentAsciiInputSource] select];
  }
}

- (void)clientWillResignActive:(NSNotification*)note
{
  NSDictionary* dic = [note userInfo];
  NSNumber* pid = [dic objectForKey:@"pid"];
#ifdef DEBUG
  NSString* appid = [dic objectForKey:@"appid"];
  NSString* appname = [dic objectForKey:@"appname"];
  NSLog(@"--- deactive %d %@ %@", [pid intValue], appid, appname);
#endif

  if (activePid && activePid == [pid intValue]) {
    // store the current source
    if (qs) {
      // for qs
      qs = NO;
    } else {
      // for the active source
      [processDic setObject:[PSInputSource currentInputSource] forKey:[NSNumber numberWithInteger:activePid]];
    }
    
    activePid = 0;

    // select the source for other applications
    PSInputSource* other = [processDic objectForKey:[NSNumber numberWithInteger:0]];
    if (other) {
      BOOL allowChange = YES;
      NSDictionary* d = [[NSWorkspace sharedWorkspace] activeApplication];
      if (d) {
        NSString* aid = [d objectForKey:@"NSApplicationBundleIdentifier"];
        if (aid && [aid isEqualTo:@"org.mozilla.thunderbird"]) {
          // if the next active application is Thunderbird, don't restore
          allowChange = NO;
        }
      }
      if (allowChange) {
        [other select];
      } else {
        // ensure the current state is stored
        [processDic setObject:[PSInputSource currentInputSource] forKey:[NSNumber numberWithInteger:0]];
      }
    }
  }
}

- (void)clientWillTerminate:(NSNotification*)note
{
  NSDictionary* dic = [note userInfo];
  NSNumber* pid = [dic objectForKey:@"pid"];
#ifdef DEBUG
  NSString* appid = [dic objectForKey:@"appid"];
  NSString* appname = [dic objectForKey:@"appname"];
  NSLog(@"*** terminate %d %@ %@", [pid intValue], appid, appname);
#endif

  [self clientWillResignActive:note];
  [processDic removeObjectForKey:pid];
}

- (void)qsInterfaceActivated:(NSNotification*)note
{
#ifdef DEBUG
  //NSDictionary* dic = [note userInfo];
  //NSNumber* pid = [dic objectForKey:@"pid"];
  //NSString* appid = [dic objectForKey:@"appid"];
  //NSString* appname = [dic objectForKey:@"appname"];
  NSLog(@"   +++ qs activate");
#endif
  
  if (!qs) {
    qs = YES;
    // store the active source
    [processDic setObject:[PSInputSource currentInputSource] forKey:[NSNumber numberWithInteger:activePid]];    
  }

  // select the ascii source
  [[PSInputSource currentAsciiInputSource] select];
}

- (void)qsInterfaceDeactivated:(NSNotification*)note
{
#ifdef DEBUG
  //NSDictionary* dic = [note userInfo];
  //NSNumber* pid = [dic objectForKey:@"pid"];
  //NSString* appid = [dic objectForKey:@"appid"];
  //NSString* appname = [dic objectForKey:@"appname"];
  NSLog(@"   --- qs deactivate");
#endif

  if (qs) {
    qs = NO;
    // restore the active source
    [[processDic objectForKey:[NSNumber numberWithInteger:activePid]] select];
  } else {
    // check if the current source is different from the stored source
    NSDictionary* d = [[NSWorkspace sharedWorkspace] activeApplication];
    if (d) {
      NSString* apid = [d objectForKey:@"NSApplicationProcessIdentifier"];
      if (apid && [apid intValue] == activePid) {
        NSString* current = [[PSInputSource currentInputSource] inputSourceId];
        NSString* active = [[processDic objectForKey:[NSNumber numberWithInteger:activePid]] inputSourceId];
        if (current && ![current isEqual:active]) {
          // if different, restore it
          [[processDic objectForKey:[NSNumber numberWithInteger:activePid]] select];
        }
      }
    }
  }
}

@end
