//
//  Models.swift
//  AppStore
//
//  Created by Bishal Kurumbang on 04/02/17.
//  Copyright © 2017 kBangProduction. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject{
    
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            
            for dict in value as! [[String: AnyObject]]{
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
            
        }else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String : AnyObject])
        }else{
            super.setValue(value, forKey: key)
        }
    }
}

class AppCategory: NSObject{
    
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps"{
            apps = [App]()
            for dict in value as! [[String: AnyObject]]{
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
                
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApps) -> ()){
        if let path = Bundle.main.path(forResource: "MockData", ofType: "json"){
            do{
                let data = try(NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe))
                
                let json = try(JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers))
                
                let dictionary = json as? NSDictionary
                
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeys(dictionary as! [String : AnyObject])
                
                DispatchQueue.main.async {
                    completionHandler(featuredApps)
                }
                
                
            }catch let err{
                print(err)
            }
        }
       
    }
    
    static func sampleAppCategories() -> [AppCategory]{
        
        //create app category
        let bestNewAppCategory = AppCategory()
        bestNewAppCategory.name = "Best New Apps"
        
        var apps = [App]()
        // create array of apps
        let frozenApp = App()
        frozenApp.name = "Disney Built It: Frozen"
        frozenApp.category = "Entertainment"
        frozenApp.imageName = "frozen"
        frozenApp.price = NSNumber(floatLiteral: 3.99)
        apps.append(frozenApp)
        
        bestNewAppCategory.apps = apps
        
        
        // another app category
        let bestNewGameCategory = AppCategory()
        bestNewGameCategory.name = "Best New Games"
        
        // create array of apps
        
        var bestNewGamesApps = [App]()
        
        //create app and append to the app array
        
        let telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.category = "Games"
        telepaintApp.imageName = "telepaint"
        telepaintApp.price = NSNumber(floatLiteral: 2.99)
        
        bestNewGamesApps.append(telepaintApp)
        
        bestNewGameCategory.apps = bestNewGamesApps
        
        return [bestNewAppCategory, bestNewGameCategory]
    }
    
}

class App: NSObject{
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
    var screenshots: [String]?
    var desc: String?
    var appInformation: AnyObject?
    
    // description is a special keyword for NSObject so safe way to do is like follows
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            self.desc = value as? String
        }else {
            super.setValue(value, forKey: key)
        }
    }
    
    
}
