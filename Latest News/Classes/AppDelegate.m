//
//  AppDelegate.m
//  Latest News
//
//  Created by Inanc Sevinc on 9/1/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#import "AppDelegate.h"
#import "../Libraries/Reachability/Reachability.h"

@implementation AppDelegate

-(id)init {
    self = [super init];
    if(self) {
        _sharedContext = [[NSMutableDictionary alloc]init];
        // disable NSURLCache, fix memory growth problem related with xml response caching
        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil]];
//        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    }
    return (self);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(AppDelegate*) getInstance{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(NSMutableDictionary*) getSharedContextInstance{
    return [AppDelegate getInstance].sharedContext;
}
+ (BOOL) isInternetConnectionAvailable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if(internetStatus == NotReachable) {
        UIAlertView *connectionErrorAlert= [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Bağlantı hatası", @"Network error")
                     message: NSLocalizedString(@"Lütfen cihazınızın internet bağlantısını kontrol edin.", @"Check your internet connection")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Kapat", @"Close") otherButtonTitles: nil];
        [connectionErrorAlert show];
        return NO;
    }
    return YES;
}

+ (BOOL) iCloudIsEnabled {
    // TODO:  use [[NSFileManager defaultManager] ubiquityIdentityToken] after IOS 6 support
    id urlForUbiquityContainerIdentifier =[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil ];
    if (urlForUbiquityContainerIdentifier) {
        return YES;
    }
    return NO;
}



@end
