//
//  ViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/5/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataConstants.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        CoreDataConstants.burnoutTimeFormatter.dateFormat = "mm:ss.SSS"
        
        let settingsRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        settingsRequest.fetchLimit = 1
        
        do {
            let settingsArray = try CoreDataConstants.managedObjectContext.fetch(settingsRequest)
            
            if (settingsArray.count == 0) {
                CoreDataConstants.settings = Settings(context: CoreDataConstants.managedObjectContext)
                
                CoreDataConstants.settings?.countdownTime = CoreDataConstants.DEFAULT_COUNTDOWN_TIMER
                
                try CoreDataConstants.managedObjectContext.save()
            } else {
                CoreDataConstants.settings = settingsArray[0]
            }
        } catch {
            print("Error could not save/fetch settings: \(error.localizedDescription)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}

