//
//  ViewController.swift
//  GoInsurance
//
//  Created by Andrew McSherry on 8/28/16.
//  Copyright © 2016 Andy McSherry. All rights reserved.
//

import UIKit

let uiDateFormatter: NSDateFormatter = {
    let dateFormat = NSDateFormatter()
    dateFormat.dateStyle = .MediumStyle
    dateFormat.timeStyle = .NoStyle
    return dateFormat
}()

class AppointmentViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var loading: UIActivityIndicatorView?
    @IBOutlet weak var hasAppointmentButtons: UIView?
    @IBOutlet weak var noAppointmentButtons: UIView?
    
    var appointment: Appointment? {
        didSet {
            timeLabel?.hidden = false
            loading?.hidden = true
            if appointment != nil {
                self.timeLabel?.text = String(format: NSLocalizedString("APPOINTMENT_FORMAT", comment: ""),
                                              uiDateFormatter.stringFromDate(appointment!.date),
                                              NSLocalizedString(appointment!.timeOfDay.rawValue, comment: ""))
                
                self.hasAppointmentButtons?.hidden = false
            } else {
                self.timeLabel?.text = NSLocalizedString("NO_APPOINTMENT", comment: "")
                self.noAppointmentButtons?.hidden = false
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showLoading()
        getAppointment(
            { [weak self] (appointment: Appointment) in
                self?.appointment = appointment
        }) { [weak self] (error) in
            if 404 == error.code {
                self?.appointment = nil
            } else {
                //TODO: Show some error
            }
        }
    }
    
    private func showLoading() {
        timeLabel?.hidden = true
        loading?.hidden = false
        hasAppointmentButtons?.hidden = true
        noAppointmentButtons?.hidden = true
    }
    
    @IBAction func cancel() {
        showLoading()
        deleteAppointment({ [weak self] in
            self?.appointment = nil
        }) { (error) in
            //TODO: Show some error
        }
    }
}

