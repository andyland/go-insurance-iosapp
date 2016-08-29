//
//  ScheduleViewController.swift
//  GoInsurance
//
//  Created by Andrew McSherry on 8/29/16.
//  Copyright © 2016 Andy McSherry. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var timeOfDayPicker: UISegmentedControl?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var scheduleButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker!.minimumDate = NSCalendar.currentCalendar().startOfDayForDate(NSDate().dateByAddingTimeInterval(60*60*24))
    }
    
    
    @IBAction func schedule() {
        scheduleButton!.hidden = true
        activityIndicator!.hidden = false
        
        var timeOfDay: TimeOfDay? = nil
        switch (timeOfDayPicker!.selectedSegmentIndex) {
        case 0:
            timeOfDay = .Morning
        case 1:
            timeOfDay = .Afternoon
        case 2:
            timeOfDay = .Evening
        default: break
        }
        
        createAppointment(datePicker!.date, timeOfDay: timeOfDay!, successBlock: { [weak self] in
            self?.close()
            }) { (error) in
                //TODO: Handle error
        }
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}