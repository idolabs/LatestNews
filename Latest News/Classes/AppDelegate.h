//
//  AppDelegate.h
//  Latest News
//
//  Created by Inanc Sevinc on 9/1/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// used for sharing data between controllers, views etc.
@property (strong, nonatomic) NSMutableDictionary *sharedContext;

+(AppDelegate*)getInstance;

+(NSMutableDictionary*)getSharedContextInstance;

+ (BOOL) isInternetConnectionAvailable;
+ (BOOL) isICloudEnabled;

@end
