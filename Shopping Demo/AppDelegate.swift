//
//  AppDelegate.swift
//  Shopping Demo
//
//  Created by Zach Owens on 6/26/19.
//  Copyright © 2019 Zach Owens. All rights reserved.
//

import UIKit
#if DEBUG
    import AdSupport
#endif
import Leanplum


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let appID:String = "app_Ulqv3N2c6KDle54DBgGE00NHCOpyy53tLDsGRCC8B34"
    let devKey:String = "dev_rpYBtisMxOFDyfprcvg1R09crmStDpId7MHb4r31zY8"
    let prodKey:String = "prod_h7DamIIhRhomBbwQNC2GAJi1R3Nhns1Jo4v9j6fvPyw"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let navController = self.window?.rootViewController as? UINavigationController {
            if let shopingTableController = navController.topViewController  as? ShoppingTableViewController {
                shopingTableController.cart = MyCart()
            }
        }
        
        //MARK: Leanplum SDK Implementation
        Leanplum.setDeviceId(ASIdentifierManager.shared().advertisingIdentifier.uuidString)
        Leanplum.setAppId(appID, withDevelopmentKey:devKey)
        /*#if DEBUG
        Leanplum.setAppId(appID, withDevelopmentKey:devKey)
        Leanplum.setAppId(appID, withProductionKey: prodKey)
        #else
        //some command
        #endif */
        
        // Optional: Tracks in-app purchases automatically as the "Purchase" event.
        // To require valid receipts upon purchase or change your reported
        // currency code from USD, update your app settings.
        // Leanplum.trackInAppPurchases()
        
        // Optional: Tracks all screens in your app as states in Leanplum.
        // Leanplum.trackAllAppScreens()
        
        // Sets the app version, which otherwise defaults to
        // the build number (CFBundleVersion).
        Leanplum.setAppVersion("1.0.0")
        Leanplum.setVerboseLoggingInDevelopmentMode(true)
        
        // Starts a new session and updates the app content from Leanplum.
        Leanplum.start()
        
        registerForPushNotifications()
        
        return true
 
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self]granted, error in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    // MARK: - Deep Linking
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let url = url.absoluteURL.absoluteString
        if url.contains("shoppingdemo://register") {
            let registerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            if let vc = UIApplication.shared.keyWindow?.rootViewController {
                if vc is UINavigationController {
                    vc.present(registerController, animated: true, completion: nil)
                }
            }
        }
        
        return false
    }


}

