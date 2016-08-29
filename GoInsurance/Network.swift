//
//  Network.swift
//  GoInsurance
//
//  Created by Andrew McSherry on 8/28/16.
//  Copyright © 2016 Andy McSherry. All rights reserved.
//

import Foundation

let host = NSURLComponents(string:"http://andy.local:5000")!.URL!
let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

func appointmentUrl() -> NSURL {
    return host.URLByAppendingPathComponent("users")
        .URLByAppendingPathComponent(getUserId())
        .URLByAppendingPathComponent("appointment")
}

func getAppointment(successBlock: Appointment -> Void, errorBlock: NSError -> Void) {
    
    let task = session.dataTaskWithURL(appointmentUrl()) {
        data, response, error in
        //This sleep is here just to test the loading state, it's too quick locally
        sleep(1)
        if let error = error {
            dispatch_async(dispatch_get_main_queue(), {
                errorBlock(error)
            })
        } else if let httpResponse = response as? NSHTTPURLResponse {
            let statusCode = httpResponse.statusCode
            if statusCode >= 200 && statusCode < 300 {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! Dictionary<String, AnyObject>
                let appointment = parseAppointment(json)
                dispatch_async(dispatch_get_main_queue(), {
                    successBlock(appointment)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    errorBlock(NSError(domain: "servererror", code: statusCode, userInfo: nil))
                })
            }
        }
    }
    task.resume()
}

func createAppointment(date: NSDate, timeOfDay: TimeOfDay, successBlock: Void -> Void, errorBlock: NSError -> Void) {
    let components = NSURLComponents(URL: appointmentUrl(), resolvingAgainstBaseURL: true)!
    components.queryItems = [NSURLQueryItem(name: "date", value: serverDateFormatter.stringFromDate(date)),
                             NSURLQueryItem(name:"time_of_day", value: timeOfDay.rawValue)]
    
    let request = NSMutableURLRequest(URL: components.URL!)
    request.HTTPMethod = "POST"
    let task = session.dataTaskWithRequest(request) {
        data, response, error in
        //This sleep is here just to test the loading state, it's too quick locally
        sleep(1)
        if let error = error {
            dispatch_async(dispatch_get_main_queue(), {
                errorBlock(error)
            })
        } else if let httpResponse = response as? NSHTTPURLResponse {
            let statusCode = httpResponse.statusCode
            if statusCode >= 200 || statusCode < 300 {
                dispatch_async(dispatch_get_main_queue(), {
                    successBlock()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    errorBlock(NSError(domain: "servererror", code: statusCode, userInfo: nil))
                })
            }
        }
    }
    task.resume()
}


func deleteAppointment(successBlock: Void -> Void, errorBlock: NSError -> Void) {
    let request = NSMutableURLRequest(URL: appointmentUrl())
    request.HTTPMethod = "DELETE"
    
    let task = session.dataTaskWithRequest(request) {
        data, response, error in
        //This sleep is here just to test the loading state, it's too quick locally
        sleep(1)
        if let error = error {
            dispatch_async(dispatch_get_main_queue(), {
                errorBlock(error)
            })
        } else if let httpResponse = response as? NSHTTPURLResponse {
            let statusCode = httpResponse.statusCode
            if statusCode >= 200 || statusCode < 300 {
                dispatch_async(dispatch_get_main_queue(), {
                    successBlock()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    errorBlock(NSError(domain: "servererror", code: statusCode, userInfo: nil))
                })
            }
        }
    }
    task.resume()
}