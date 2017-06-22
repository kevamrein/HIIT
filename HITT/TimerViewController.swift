//
//  TimerViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/9/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit

class TimerViewController : UIViewController {
    // Constants
    private let MINUTE_DEFAULT : String = "00"
    private let SECOND_DEFAULT : String = "00"
    private let MILLISECOND_DEFAULT : String = "000"
    
    @IBOutlet weak var minuteTimer: UILabel!
    @IBOutlet weak var secondTimer: UILabel!
    @IBOutlet weak var millisecondTimer: UILabel!
    
    private var timer : Timer = Timer()
    private var stopChanging: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        minuteTimer.text = MINUTE_DEFAULT;
        secondTimer.text = SECOND_DEFAULT;
        millisecondTimer.text = MILLISECOND_DEFAULT
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateLabels), userInfo: nil, repeats: true)
    }
    
    func updateLabels() {
        
        if (!stopChanging) {
            var minuteValue: Int = Int(minuteTimer.text!)!
            var secondValue: Int = Int(secondTimer.text!)!
            var millisecondValue: Int = Int(millisecondTimer.text!)!
            
            if (millisecondValue < 999) {
                millisecondValue += 1
                millisecondTimer.text = String(format: "%03d", millisecondValue)
            } else if (millisecondValue == 999) {
                millisecondTimer.text = MILLISECOND_DEFAULT
                secondValue += 1
                secondTimer.text = String(format: "%02d", secondValue)
            }
            
            if (secondValue == 60) {
                secondTimer.text = SECOND_DEFAULT
                minuteValue += 1
                minuteTimer.text = String(format: "%02d", minuteValue)
                
            }
        }
    }
    
    @IBAction func endWorkout(_ sender: Any) {
        if (timer.isValid) {
            timer.invalidate()
            
            let minuteValue: Int = Int(minuteTimer.text!)!
            let secondValue: Int = Int(secondTimer.text!)!
            let millisecondValue: Int = Int(millisecondTimer.text!)!
            
            CoreDataConstants.workoutToSave?.burnoutTime = CoreDataConstants.burnoutTimeFormatter.date(from: "\(minuteValue):\(secondValue).\(millisecondValue)") as! NSDate
            
            
        }
        performSegue(withIdentifier: "endWorkout", sender: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "Cancel", message: "Are you sure you want to cancel this workout?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: handleAlert))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: handleAlert))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        if (timer.isValid) {
            stopChanging = true
        }
    }
    
    private func handleAlert(alert: UIAlertAction!) {
        if (alert.title == "Yes") {
            if (timer.isValid) {
                timer.invalidate()
            }
            performSegue(withIdentifier: "cancelSegue", sender: nil)
        } else if (alert.title == "No") {
            alert.isEnabled = false
            stopChanging = false
        }
    }
}
