import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var navigstionCoordinator: NavigationCoordinator!
    static var dependencyRegistry: DependencyRegistry!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        MockedWebServer.sharedInstance.start()  // ovo  nije potrebno vise jer ce se hendlati pomocu dependencyRegistry-ja
        return true
    }
}

