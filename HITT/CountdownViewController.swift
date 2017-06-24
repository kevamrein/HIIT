//
//  CountdownViewController.swift
//  HITT
//
//  Created by Kevin Amrein on 6/9/17.
//  Copyright © 2017 Kevin Amrein. All rights reserved.
//

import Foundation
import UIKit

class CountdownViewController : UIViewController {
    // Constants
    private static let COUNTDOWN_START_TIME: Int16 = (CoreDataConstants.settings?.countdownTime)!
    
    @IBOutlet weak var countdownLabel: UILabel!
    private var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        countdownLabel.text = String(CountdownViewController.COUNTDOWN_START_TIME)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
    }
    
    func updateLabel() {
        var value: Int = Int(countdownLabel.text!)!
        value -= 1
        
        if (value <= 0) {
            timer.invalidate()
            countdownLabel.text = "START!"
            performSegue(withIdentifier: "doneCountDown", sender: nil)
        } else {
            countdownLabel.text = String(value)
        }
        
    }
}
