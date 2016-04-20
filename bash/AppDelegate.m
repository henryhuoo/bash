//
//  AppDelegate.m
//  bash
//
//  Created by 胡旭 on 16/3/10.
//  Copyright © 2016年 胡旭. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "UIAdaptor.h"
#import "MeViewController.h"
#import "DiscoveryViewController.h"
#import "bleManager+control.h"
#import "pageInstructionViewController.h"

@interface TNavigationBar : UINavigationBar

@end

@implementation TNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.barStyle = UIBarStyleBlackTranslucent;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = UIColorRGB(0x40b8ef);    
}

@end

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = UIColorRGB(0x40b8ef);
    self.window.backgroundColor = [UIColor clearColor];
    
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    self.window.rootViewController = tabBar;

    
    //设置tab bar 颜色
    UIView *bgView = [[UIView alloc] initWithFrame:tabBar.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [tabBar.tabBar insertSubview:bgView atIndex:0];
    tabBar.tabBar.opaque = YES;
    
    
    UIViewController *c1=[[ViewController alloc]init];
//    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:c1];
    UINavigationController *navC1 = [[UINavigationController alloc] initWithNavigationBarClass:[TNavigationBar class]toolbarClass:[UIToolbar class]];
    navC1.viewControllers = @[c1];
    navC1.navigationBar.topItem.title = @"治疗方案";
    navC1.tabBarItem.image = [[UIImage imageNamed:@"Icons Bottom Treat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC1.tabBarItem.selectedImage = [[UIImage imageNamed:@"Icons Bottom Treat(select)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC1.tabBarItem.title = @"治疗";
    [navC1.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: UIColorRGB(0x40B7EF),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    backView.backgroundColor = UIColorRGB(0x40b8ef);
    [navC1.navigationBar addSubview:backView];
    
    UIViewController *c2=[[DiscoveryViewController alloc]init];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithNavigationBarClass:[TNavigationBar class]toolbarClass:[UIToolbar class]];
    navC2.viewControllers = @[c2];
    navC2.navigationBar.topItem.title = @"发现";
    navC2.tabBarItem.image = [[UIImage imageNamed:@"Icons Bottom Discover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC2.tabBarItem.selectedImage = [[UIImage imageNamed:@"Icons Bottom Discover(select)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC2.tabBarItem.title = @"发现";
    [navC2.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: UIColorRGB(0x40B7EF),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    UIView* backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    backView2.backgroundColor = UIColorRGB(0x40b8ef);
    [navC2.navigationBar addSubview:backView2];
    
    UIViewController *c3=[[MeViewController alloc]init];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithNavigationBarClass:[TNavigationBar class]toolbarClass:[UIToolbar class]];
    navC3.viewControllers = @[c3];
    navC3.navigationBar.topItem.title = @"我";
    navC3.tabBarItem.image = [[UIImage imageNamed:@"Icons Bottom me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC3.tabBarItem.selectedImage = [[UIImage imageNamed:@"Icons Bottom Me(select)"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navC3.tabBarItem.title = @"我";
    [navC3.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: UIColorRGB(0x40B7EF),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    UIView* backView3 = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 20)];
    backView3.backgroundColor = UIColorRGB(0x40b8ef);
    [navC3.navigationBar addSubview:backView3];
    
    tabBar.viewControllers = @[navC1, navC2, navC3];
    
    [self.window makeKeyAndVisible];
    
    
    
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    
    [[[treatManager shareInstance] manager] initCenteralManger];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"This device token is: %@", deviceToken);
//    NSString *token = [[[[deviceToken description]
//                         stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                        stringByReplacingOccurrencesOfString: @">" withString: @""]
//                       stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    // call the server function to register this device
    // ..
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"didReceiveRemoteNotification");
    
//    UIApplicationState applicationState = application.applicationState;
//    if ( applicationState == UIApplicationStateActive ){
//        // app was already in the foreground
//        NSLog(@"Content: %@", [[userInfo objectForKey: @"aps"] objectForKey: @"alert"]);
//        
//        UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if (enabledTypes & UIRemoteNotificationTypeBadge) {
//            //badge number is enabled
//        }
//        if (enabledTypes & UIRemoteNotificationTypeSound) {
//            //sound is enabled
//        }
//        if (enabledTypes & UIRemoteNotificationTypeAlert) {
//            //alert msg is enabled
//        }
//    }
//    else{
//        // app was just brought from background to foreground
//    }
}

@end
