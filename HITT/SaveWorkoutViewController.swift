//
//  SaveWorkoutViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/9/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit

class SaveWorkoutViewController : UIViewController {
    
    @IBOutlet weak var startingWeightField: UITextField!
    @IBOutlet weak var endingWeightField: UITextField!
    @IBOutlet weak var numRepsField: UITextField!
    @IBOutlet weak var notesField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapOutside(_ sender: UITapGestureRecognizer) {
        var didEnd: Bool = false
        if (startingWeightField.isEditing || endingWeightField.isEditing || numRepsField.isEditing || notesField.isEditing) {
                self.view.endEditing(true)
                didEnd = true
        }

        
        if (!didEnd && sender.state == .ended) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if (startingWeightField.text!.characters.count == 0 || endingWeightField.text!.characters.count == 0 ||
            numRepsField.text!.characters.count == 0) {
        } else {
            createWorkoutToSave()
            
            if (CoreDataConstants.maxWeightObject == nil) {
                createNewMaxWeight()
            } else {
                editMaxWeight()
            }

            do {
                try CoreDataConstants.managedObjectContext.save()
            } catch {
                print("Error could not save: \(error.localizedDescription)")
            }
            
            CoreDataConstants.workoutToSave = nil
            self.performSegue(withIdentifier: "savedSegue", sender: nil)
        }
    }
    
    private func createWorkoutToSave() {
        CoreDataConstants.workoutToSave?.completionDate = NSDate()
        CoreDataConstants.workoutToSave?.endingWeight = Int16(endingWeightField.text!)!
        CoreDataConstants.workoutToSave?.startingWeight = Int16(startingWeightField.text!)!
        CoreDataConstants.workoutToSave?.notes = notesField.text
        CoreDataConstants.workoutToSave?.reps = Int16(numRepsField.text!)!
    }
    
    private func createNewMaxWeight() {
        CoreDataConstants.maxWeightObject = MaxWeight(context: CoreDataConstants.managedObjectContext)
        CoreDataConstants.maxWeightObject?.maxWeight = Int16(startingWeightField.text!)! > Int16(endingWeightField.text!)! ? Int16(startingWeightField.text!)! : Int16(endingWeightField.text!)!
        CoreDataConstants.maxWeightObject?.identifier = CoreDataConstants.workoutToSave?.identifier
        CoreDataConstants.maxWeightObject?.units = (CoreDataConstants.workoutToSave?.units)!
    }
    
    private func editMaxWeight() {
        // Get the unit and the measurement for the current max value stored in the database
        let currentMaxUnit = CoreDataConstants.getUnitMass((CoreDataConstants.maxWeightObject?.units)!)
        let currentMaxWeightMeasurement = Measurement(value: Double((CoreDataConstants.maxWeightObject?.maxWeight)!), unit: currentMaxUnit)
        
        // Get the maximum of the starting and ending
        let startingWeight: Int16 = Int16(startingWeightField.text!)!
        let endingWeight: Int16 = Int16(endingWeightField.text!)!
        
        let maxOfCompleted: Int16 = startingWeight > endingWeight ? startingWeight : endingWeight
        
        let maxOfCompletedMeasurement = Measurement(value: Double(maxOfCompleted), unit: CoreDataConstants.unitMass)
        
        if (currentMaxUnit == CoreDataConstants.unitMass) {
            if (maxOfCompleted > (CoreDataConstants.maxWeightObject?.maxWeight)!) {
                CoreDataConstants.maxWeightObject?.maxWeight = maxOfCompleted
            }
        } else {
                let maxOfCompletedLbs = maxOfCompletedMeasurement.converted(to: UnitMass.pounds)
                let currentMaxLbs = currentMaxWeightMeasurement.converted(to: UnitMass.pounds)
                
                if (maxOfCompletedLbs.value > currentMaxLbs.value) {
                    CoreDataConstants.maxWeightObject?.maxWeight = maxOfCompleted
                    CoreDataConstants.maxWeightObject?.units = CoreDataConstants.getUnitNumber(CoreDataConstants.unitMass)
                }
        }
    }

    @IBAction func tapInside(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func donePressed(_ sender: UITextField) {
        sender.endEditing(true)
    }
}
