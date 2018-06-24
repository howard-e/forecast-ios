//
//  AppDelegate.swift
//  Forecast
//
//  Created by Howard Edwards on 6/22/18.
//  Copyright © 2018 Howard Edwards. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var db: Firestore!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		firebaseSetup()
		
		if getUserDefaults(string: UserDefaultsKeys.deviceId) == nil {
			if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
				setUserDefaults(string: deviceId, key: UserDefaultsKeys.deviceId)
			}
		}
		
		let seenOnboarding = getUserDefaults(bool: UserDefaultsKeys.seenOnboarding)
		let rootController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: seenOnboarding ? ControllerIdentifiers.dashboardTabController : ControllerIdentifiers.onboardingController)
		window?.rootViewController = rootController
		
		return true
	}
	
	/*func realmSetup() {
		// To Account for when any of the realm models change (Automatic Migration)
		let config = Realm.Configuration(
			// Set the new schema version. This must be greater than the previously used
			// version (if you've never set a schema version before, the version is 0).
			schemaVersion: 1,
			
			// Set the block which will be called automatically when opening a Realm with
			// a schema version lower than the one set above
			migrationBlock: { migration, oldSchemaVersion in
				// We haven’t migrated anything yet, so oldSchemaVersion == 0
				if (oldSchemaVersion <= 1) {
					// Nothing to do!
					// Realm will automatically detect new properties and removed properties
					// And will update the schema on disk automatically
				}
		}, deleteRealmIfMigrationNeeded: true)
		
		// Tell Realm to use this new configuration object for the default Realm
		Realm.Configuration.defaultConfiguration = config
		_ = try! Realm()
	}*/
	
	func firebaseSetup() {
		FirebaseApp.configure()
		
		// Database Set Up
		db = Firestore.firestore()
		let settings = db.settings
		settings.areTimestampsInSnapshotsEnabled = true
		db.settings = settings
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


}

