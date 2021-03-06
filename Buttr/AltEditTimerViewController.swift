//
//  AltEditTimerViewController.swift
//  Buttr
//
//  Created by Kyle Lucovsky on 8/11/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

import UIKit

class AltEditTimerViewController: UIViewController {
    
    // buttons
    @IBOutlet var timeKeys: [UIButton]!
    @IBOutlet var startKey: UIButton!
    @IBOutlet var cancelKey: UIButton!
    
    // labels
    @IBOutlet var tertiaryColorLabels: [UILabel]!
    @IBOutlet var primaryColorLabels: [UILabel]!
    @IBOutlet var secondaryColorLabels: [UILabel]!
    
    @IBOutlet var secondsLabel: UILabel!
    @IBOutlet var minutesLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    
    // data
    var timerValue: [Int] = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundColor()
        self.primaryColorLabels.map { (label: UILabel) -> UILabel in
            label.textColor = UIColor.primaryTextColor()
            return label
        }
        
        self.secondaryColorLabels.map { (label: UILabel) -> UILabel in
            label.textColor = UIColor.secondaryTextColor()
            return label
        }
        
        self.tertiaryColorLabels.map { (label: UILabel) -> UILabel in
            label.textColor = UIColor.tertiaryTextColor()
            return label
        }
    }
    
    func parseTime() -> [String: Int] {
        var inputs = timerValue
        
        if (inputs.count < 6) {
            for i in 1...(6 - inputs.count) {
                inputs.insert(Int(0), atIndex: 0)
            }
        }
        
        return ["seconds": inputs[5] + (inputs[4] * 10),
                "minutes": inputs[3] + (inputs[2] * 10),
                "hours": inputs[1] + (inputs[0] * 10)]
    }
    
    func renderTime() {
        var timeDict = parseTime()
        
        self.hoursLabel.text = String(format: "%02ld", locale: nil, timeDict["hours"]!)
        self.minutesLabel.text = String(format: "%02ld", locale: nil, timeDict["minutes"]!)
        self.secondsLabel.text = String(format: "%02ld", locale: nil, timeDict["seconds"]!)
    }

    @IBAction func onDeleteTap() {
        if (timerValue.count > 0) {
            timerValue.removeLast()
            renderTime()
        }
    }
    
    @IBAction func onTimeKeyTap(button: UIButton) {
        if (timerValue.count < 6) {
            timerValue.append(Int(button.tag))
            renderTime()
        }
    }
    
    @IBAction func onStartKeyTap() {
        let parsedTime = self.parseTime()
        let totalSeconds = parsedTime["seconds"]! + (parsedTime["minutes"]! * 60) + (parsedTime["hours"]! * 3600)
        let actualTimes = ["seconds": totalSeconds % 60, "minutes": (totalSeconds / 60) % 60, "hours": totalSeconds / 3600]
        
        NSNotificationCenter.defaultCenter().postNotificationName("AltTimerSet", object: self, userInfo: ["times": actualTimes])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
