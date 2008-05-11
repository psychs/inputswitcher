// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import "PSInputSwitcherHook.h"

static NSString* NOTE_BECOME_ACTIVE = @"InputSwitcherClientDidBecomeActive";
static NSString* NOTE_RESIGN_ACTIVE = @"InputSwitcherClientWillResignActive";
static NSString* NOTE_TERMINATE = @"InputSwitcherClientWillTerminate";
static NSString* NOTE_QS_ACTIVATE = @"InputSwitcherQSInterfaceActivated";
static NSString* NOTE_QS_DEACTIVATE = @"InputSwitcherQSInterfaceDeactivated";

static int myPid;
static NSMutableDictionary* myDic;

//#define DEBUG

@implementation PSInputSwitcherHook

- (void)dealloc
{
  if (myDic) [myDic release];
  [super dealloc];
}

+ (void)load
{
}

+ (id)sharedInstance
{
  static id instance = nil;
  if (instance == nil) instance = [[self alloc] init];
  return instance;
}

+ (void)install
{
  myPid = [[NSProcessInfo processInfo] processIdentifier];
  myDic = [[NSMutableDictionary alloc] init];
  [myDic setObject:[NSNumber numberWithInteger:myPid] forKey:@"pid"];
  NSString* appid = [[NSBundle mainBundle] bundleIdentifier];
  if (appid) [myDic setObject:appid forKey:@"appid"];
  NSString* appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
  if (appname) [myDic setObject:appname forKey:@"appname"];
  
#ifdef DEBUG
  NSLog(@"### install %d %@ %@", myPid, appid, appname);
#endif
	
  PSInputSwitcherHook* i = [self sharedInstance];
  NSNotificationCenter* c = [NSNotificationCenter defaultCenter];
  [c addObserver:i selector:@selector(appDidBecomeActive:) name:@"NSApplicationDidBecomeActiveNotification" object:nil];
  [c addObserver:i selector:@selector(appWillResignActive:) name:@"NSApplicationWillResignActiveNotification" object:nil];
  [c addObserver:i selector:@selector(appWillTerminate:) name:@"NSApplicationWillTerminateNotification" object:nil];
  
  if (appid && [appid isEqualToString:@"com.blacktree.Quicksilver"]) {
    //[c addObserver:i selector:@selector(qsInterfaceActivated:) name:@"InterfaceActivated" object:nil];
    [c addObserver:i selector:@selector(qsInterfaceActivated:) name:@"NSWindowDidBecomeKeyNotification" object:nil];
    [c addObserver:i selector:@selector(qsInterfaceDeactivated:) name:@"InterfaceDeactivated" object:nil];
  }
}

- (void)appDidBecomeActive:(NSNotification*)note
{
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c postNotificationName:NOTE_BECOME_ACTIVE object:nil userInfo:myDic deliverImmediately:true];
}

- (void)appWillResignActive:(NSNotification*)note
{
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c postNotificationName:NOTE_RESIGN_ACTIVE object:nil userInfo:myDic deliverImmediately:true];
}

- (void)appWillTerminate:(NSNotification*)note
{
  NSDistributedNotificationCenter* d = [NSDistributedNotificationCenter defaultCenter];
  [d postNotificationName:NOTE_TERMINATE object:nil userInfo:myDic deliverImmediately:true];

  NSNotificationCenter* c = [NSNotificationCenter defaultCenter];
  [c removeObserver:self name:@"NSApplicationDidBecomeActiveNotification" object:nil];
  [c removeObserver:self name:@"NSApplicationWillResignActiveNotification" object:nil];
  [c removeObserver:self name:@"NSApplicationWillTerminateNotification" object:nil];
  [c removeObserver:self name:@"InterfaceActivated" object:nil];
  [c removeObserver:self name:@"InterfaceDeactivated" object:nil];
}

- (void)qsInterfaceActivated:(NSNotification*)note
{
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c postNotificationName:NOTE_QS_ACTIVATE object:nil userInfo:myDic deliverImmediately:true];
}

- (void)qsInterfaceDeactivated:(NSNotification*)note
{
  NSDistributedNotificationCenter* c = [NSDistributedNotificationCenter defaultCenter];
  [c postNotificationName:NOTE_QS_DEACTIVATE object:nil userInfo:myDic deliverImmediately:true];
}

@end
