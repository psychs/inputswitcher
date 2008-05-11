// Created by Satoshi Nakagawa.
// You can redistribute it and/or modify it under the MIT License.

#import <Cocoa/Cocoa.h>

@interface PrefUtil : NSObject

+ (BOOL)isAppInLoginItems;
+ (void)setAppInLoginItems:(BOOL)doAdd;

@end
