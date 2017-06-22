//
//  AddWorkoutViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/9/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AddWorkoutViewController : UIViewController {
    @IBOutlet weak var workoutName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func outsideTapped(_ sender: UITapGestureRecognizer) {
        
        if (workoutName.isEditing) {
            endEditing()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func donePressed(_ sender: UITextField) {
        endEditing()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        endEditing()
        if (workoutName.text?.characters.count != 0) {
            let exerciseItem = Exercise(context: CoreDataConstants.managedObjectContext)
            exerciseItem.name = workoutName.text
            exerciseItem.identifier = UUID().uuidString
            
            do {
                try CoreDataConstants.managedObjectContext.save()
            } catch {
                print("Could not save exercise: \(error.localizedDescription)")
            }
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
}
