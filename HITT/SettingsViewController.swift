//
//  SettingsViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/18/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    private let COUNTDOWN_LABEL = "Countdown Time:"
    private let COUNTDOWN_UNITS = "sec"
    
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    
    
    override func viewDidLoad() {
        slider.value = Float((CoreDataConstants.settings?.countdownTime)!)
        countdownLabel.text = "\(COUNTDOWN_LABEL) \(Int16(slider.value)) \(COUNTDOWN_UNITS)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {        
        do {
            try CoreDataConstants.managedObjectContext.save()
        } catch {
            print("Error could not save settings: \(error.localizedDescription)")
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int16(sender.value)
        CoreDataConstants.settings?.countdownTime = Int16(value)
        countdownLabel.text = "\(COUNTDOWN_LABEL) \(value) \(COUNTDOWN_UNITS)"
    }
    
}
