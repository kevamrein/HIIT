//
//  WorkoutSelectorViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/9/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WorkoutSelectorViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Constants
    private let MAX_WEIGHT_DEFAULT = 0
    private let PREVIOUS_BURNOUT_DEFAULT = "00:00.000"
    private let PREVIOUS_STARTING_DEFAULT = 0
    private let PREVIOUS_ENDING_DEFAULT = 0
    private let PREVIOUS_REPS_DEFAULT = 0
    private let NOTE_DEFAULT = "No Note From Previous Workout"
    
    @IBOutlet weak var tableView: UITableView!
    
    // Values
    @IBOutlet weak var maxWeightNumber: UILabel!
    @IBOutlet weak var previousBurnoutTimeNumber: UILabel!
    @IBOutlet weak var previousStartingWeightNumber: UILabel!
    @IBOutlet weak var previousEndingWeightNumber: UILabel!
    @IBOutlet weak var previousRepsNumber: UILabel!
    @IBOutlet weak var noteValue: UILabel!
    
    // Labels
    @IBOutlet weak var maxWeightLabel: UILabel!
    @IBOutlet weak var previousBurnoutTimeLabel: UILabel!
    @IBOutlet weak var previousStartingWeightLabel: UILabel!
    @IBOutlet weak var previousEndingWeightLabel: UILabel!
    @IBOutlet weak var previousRepsLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!
    
    // Global Variables
    private var exercises = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        CoreDataConstants.workoutToSave = Workouts(context: CoreDataConstants.managedObjectContext)
        
        CoreDataConstants.maxWeightObject = nil
        
        hideLabelsAndNumbers()
        
        // Hide Start Button
        startButton.isHidden = true
        
        // Set defaults
        
        
        CoreDataConstants.workoutToSave?.units = CoreDataConstants.isMetric ? CoreDataConstants.KILOGRAM : CoreDataConstants.POUND
        
        // Set max weight default value
        let max: Measurement = Measurement(value: Double(MAX_WEIGHT_DEFAULT), unit: CoreDataConstants.unitMass)
        maxWeightNumber.text = MeasurementFormatter().string(from: max)
        
        // Set Burnout time default
        previousBurnoutTimeNumber.text = PREVIOUS_BURNOUT_DEFAULT
        
        // Set previous starting weight default
        let previousStarting: Measurement = Measurement(value: Double(PREVIOUS_STARTING_DEFAULT), unit: CoreDataConstants.unitMass)
        previousStartingWeightNumber.text = MeasurementFormatter().string(from: previousStarting)
        
        // Set previous ending weight default
        let previousEnding: Measurement = Measurement(value: Double(PREVIOUS_ENDING_DEFAULT), unit: CoreDataConstants.unitMass)
        previousEndingWeightNumber.text = MeasurementFormatter().string(from: previousEnding)
        
        // Set default reps
        previousRepsNumber.text = String(PREVIOUS_REPS_DEFAULT)
        
        loadData()
    }
    
    @IBAction func startButton(_ sender: UIButton) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "excerciseCell", for: indexPath) as? ExerciseCell
        
        let exercise = exercises[indexPath.row]
        
        cell?.exerciseName.text = exercise.name
        let workoutRequest: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        workoutRequest.predicate = NSPredicate(format: "identifier == %@", exercise.identifier!)
        workoutRequest.sortDescriptors = [NSSortDescriptor(key: "completionDate", ascending: false)]
        workoutRequest.fetchLimit = 1
        
        do {
            let workoutArrayResult = try CoreDataConstants.managedObjectContext.fetch(workoutRequest)
            let result = workoutArrayResult.count == 0 ? nil : workoutArrayResult[0]
            
            if (result != nil) {
                cell?.lastCompletedLabel.isHidden = false
                let lastCompletedDate = DateFormatter()
                lastCompletedDate.dateStyle = .medium
                lastCompletedDate.timeStyle = .none
                cell?.lastCompletedLabel.text = lastCompletedDate.string(from: (result?.completionDate)! as Date)
            } else {
                cell?.lastCompletedLabel.isHidden = true
            }
        } catch {
            print("Error getting completion date: \(error.localizedDescription)")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exerciseIdentifier = exercises[indexPath.row].identifier
        
        // Previous workout request
        let workoutRequest: NSFetchRequest<Workouts> = Workouts.fetchRequest()
        workoutRequest.predicate = NSPredicate(format: "identifier == %@", exerciseIdentifier!)
        workoutRequest.sortDescriptors = [NSSortDescriptor(key: "completionDate", ascending: false)]
        workoutRequest.fetchLimit = 1
        
        // Max Weight Request
        let maxWeightRequest: NSFetchRequest<MaxWeight> = MaxWeight.fetchRequest()
        maxWeightRequest.predicate = NSPredicate(format: "identifier == %@", exerciseIdentifier!)
        maxWeightRequest.fetchLimit = 1
        
        do {
            // Workout Fetch
            let workoutArrayResult = try CoreDataConstants.managedObjectContext.fetch(workoutRequest)
            let result = workoutArrayResult.count == 0 ? nil : workoutArrayResult[0]
            var unit: String
            switch result?.units {
            case CoreDataConstants.KILOGRAM?:
                unit = CoreDataConstants.KILOGRAM_LABEL
            case CoreDataConstants.POUND?:
                unit = CoreDataConstants.POUND_LABEL
            default:
                unit = CoreDataConstants.POUND_LABEL
            }
            
            // Max Weight Fetch
            let maxArrayResult = try CoreDataConstants.managedObjectContext.fetch(maxWeightRequest)
            
            if (result != nil) {
                CoreDataConstants.maxWeightObject = maxArrayResult[0]
                maxWeightNumber.text = "\(CoreDataConstants.maxWeightObject?.maxWeight ?? Int16(MAX_WEIGHT_DEFAULT)) \(unit)"
                previousBurnoutTimeNumber.text = CoreDataConstants.burnoutTimeFormatter.string(from: (result?.burnoutTime)! as Date)
                previousStartingWeightNumber.text = "\(result?.startingWeight ?? Int16(PREVIOUS_STARTING_DEFAULT)) \(unit)"
                previousEndingWeightNumber.text = "\(result?.endingWeight ?? Int16(PREVIOUS_ENDING_DEFAULT)) \(unit)"
                previousRepsNumber.text = "\(result?.reps ?? Int16(PREVIOUS_REPS_DEFAULT))"
                noteValue.text = "\(result?.notes ?? NOTE_DEFAULT)"
                showLabelsAndNumbers()
            } else {
                hideLabelsAndNumbers()
            }
            
        } catch {
            print("Error retrieving workout: \(error.localizedDescription)")
        }
        
        CoreDataConstants.workoutToSave?.identifier = exerciseIdentifier
        
        startButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            CoreDataConstants.managedObjectContext.delete(exercises[indexPath.row])
            exercises.remove(at: indexPath.row)
            self.tableView.reloadData()
            do {
                try CoreDataConstants.managedObjectContext.save()
            } catch {
                print("Could not save \(error.localizedDescription)")
            }
            
        }
    }
    
    func loadData() {
        let exerciseRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        do {
            exercises = try CoreDataConstants.managedObjectContext.fetch(exerciseRequest)
            
            /*
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Exercise")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                try CoreDataConstants.managedObjectContext.execute(request)
            } catch {
                
            }
            */
        } catch {
            print("Error getting data: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    private func hideLabelsAndNumbers() {
        // Hide Numbers
        maxWeightNumber.isHidden = true
        previousBurnoutTimeNumber.isHidden = true
        previousStartingWeightNumber.isHidden = true
        previousEndingWeightNumber.isHidden = true
        previousRepsNumber.isHidden = true
        noteValue.isHidden = true
        
        // Hide Labels
        maxWeightLabel.isHidden = true
        previousBurnoutTimeLabel.isHidden = true
        previousStartingWeightLabel.isHidden = true
        previousEndingWeightLabel.isHidden = true
        previousRepsLabel.isHidden = true
    }
    
    private func showLabelsAndNumbers() {
        // Hide Numbers
        maxWeightNumber.isHidden = false
        previousBurnoutTimeNumber.isHidden = false
        previousStartingWeightNumber.isHidden = false
        previousEndingWeightNumber.isHidden = false
        previousRepsNumber.isHidden = false
        noteValue.isHidden = false
        
        // Hide Labels
        maxWeightLabel.isHidden = false
        previousBurnoutTimeLabel.isHidden = false
        previousStartingWeightLabel.isHidden = false
        previousEndingWeightLabel.isHidden = false
        previousRepsLabel.isHidden = false
    }
}
