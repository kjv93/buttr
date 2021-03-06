//
//  TimerProgressViewController.swift
//  Buttr
//
//  Created by Kyle Lucovsky on 8/10/15.
//  Copyright (c) 2015 Kyle Lucovsky. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class TimerProgressViewController: UIViewController {
    
    // time left in seconds
    var timeLeft: Int! {
        didSet {
            self.updateTimerLabel()
        }
    }
    
    var timer: Timer!
    var nsTimerInstance: NSTimer!
    var timerIsPaused: Bool = false
    
    // alarm properties
    var nsTimerAlertInstance: NSTimer!
    var audioPlayer: AVAudioPlayer!
    var butterBark: SystemSoundID = 0
    
    @IBOutlet var timerProgressView: TimerProgressView!
    @IBOutlet var timerLabelView: TimerLabelView!
    @IBOutlet var timerControlButton: KeyPadControlButton!
    @IBOutlet var timerResetButton: KeyPadControlButton!
    @IBOutlet var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeLeft = self.timer.timeLeft()
        self.containerView.backgroundColor = UIColor.backgroundColor()
        self.timerProgressView.startTimer(duration: Int(self.timer.duration), timeLeft: self.timer.timeLeft())
        self.updateTimerLabel()
        
        // start tracking timer
        nsTimerInstance = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFired", userInfo: nil, repeats: true)
    }
    
    deinit {
        self.invalidateTimersAndAlerts()
    }

    func updateTimerLabel() {
        timerLabelView?.seconds = timeLeft % 60
        timerLabelView?.minutes = (timeLeft / 60) % 60
        timerLabelView?.hours = (timeLeft / 3600)
    }
    
    func playButterBark() {
        let butterPath = NSBundle.mainBundle().pathForResource("butter_bark", ofType: "wav")
        let butterUrl = NSURL.fileURLWithPath(butterPath!)
        audioPlayer = AVAudioPlayer(contentsOfURL: butterUrl!, error: nil)
        
        audioPlayer.play()
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        nsTimerAlertInstance = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "alert", userInfo: nil, repeats: true)
    }
    
    func alert() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func invalidateTimersAndAlerts() {
        audioPlayer?.stop()
        nsTimerAlertInstance?.invalidate()
        nsTimerInstance?.invalidate()
    }
    
    func closeScreen() {
        Timer.deleteTimers()
        self.invalidateTimersAndAlerts()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Gestures and Events
    
    func timerFired() {
        if (timeLeft == 0) {
            self.playButterBark()
            nsTimerInstance.invalidate()
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10.0, options: nil, animations: {
                [unowned self] () ->  Void in
                self.timerProgressView.transform = CGAffineTransformMakeScale(0, 0)
                self.containerView.transform = CGAffineTransformMakeTranslation(0, -70)
                self.timerControlButton.layer.opacity = 0
                self.timerResetButton.standardBackgroundImage = UIImage(named: "bark_speech_bubble")
            }, completion: nil)
        } else {
            timeLeft = self.timer.timeLeft()
            self.timerProgressView.updateSlider()
        }
    }
    
    @IBAction func toggleTimerState() {
        if (timerIsPaused) {
            self.timer.resetStartTime()
            DataManager.sharedInstance.save()

            nsTimerInstance = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerFired", userInfo: nil, repeats: true)
            timerIsPaused = false
            timerControlButton.standardBackgroundImage = UIImage(named: "pause_button")
        } else {
            self.timer.pauseTime = NSDate()
            nsTimerInstance.invalidate()
            timerIsPaused = true
            timerControlButton.standardBackgroundImage = UIImage(named: "start_button")
        }
    }
    
    @IBAction func onTapReset() {
        self.closeScreen()
    }
    
    @IBAction func onDoneTap() {
        self.closeScreen()
    }

}
