//
//  Appointment.swift
//  GoInsurance
//
//  Created by Andrew McSherry on 8/28/16.
//  Copyright © 2016 Andy McSherry. All rights reserved.
//

import Foundation

let serverDateFormatter: NSDateFormatter = {
    let dateFormat = NSDateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    return dateFormat
}()

enum TimeOfDay: String {
    case Morning = "Morning"
    case Afternoon = "Afternoon"
    case Evening = "Evening"
    
    func getUIString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct Appointment {
    var timeOfDay: TimeOfDay!
    var date: NSDate!
}

func parseAppointment(dictionary: Dictionary<String, AnyObject>) -> Appointment {
    let timeOfDay = TimeOfDay(rawValue:dictionary["time_of_day"] as! String)!
    let date = serverDateFormatter.dateFromString(dictionary["date"] as! String)!
    return Appointment(timeOfDay: timeOfDay, date: date)
}
