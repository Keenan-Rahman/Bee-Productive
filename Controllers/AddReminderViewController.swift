//
//  AddReminderViewController.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 05/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderViewController: UIViewController , UNUserNotificationCenterDelegate{


    // variables
    
    var preControllerReference : ReminderViewController?
    let center = UNUserNotificationCenter.current()
    // outlets
    
  
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var noteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if error != nil {
                print("Request authorization failed!")
            } else {
                print("Request authorization succeeded!")
            }
        }
        
        reminderDatePicker.setValue(UIColor.white, forKey: "textColor")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        noteTextField.becomeFirstResponder()
    }
    func showAlert() {
        let objAlert = UIAlertController(title: "Alert", message: "Request authorization succeeded", preferredStyle: UIAlertControllerStyle.alert)
        
        objAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        //self.presentViewController(objAlert, animated: true, completion: nil)
        UIApplication.shared.keyWindow?.rootViewController?.present(objAlert, animated: true, completion: nil)
    }
    @IBAction func reminderSaveButton(_ sender: Any) {
        
        let date = reminderDatePicker.date
        let remindermessage = noteTextField.text
        let reminder = Reminder(date,remindermessage!)
        preControllerReference?.reminders.append(reminder)
        preControllerReference?.reminderPersistStorage.saveData((preControllerReference?.reminders)!)
        preControllerReference?.reminderTableView.reloadData()
        setReminder()
        self.dismiss(animated: true, completion: nil)
    }
  
    @IBAction func reminderCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setReminder(){

        let content = UNMutableNotificationContent()
        content.title = "Bee Productive"
        content.body = self.noteTextField.text!
        content.sound = UNNotificationSound.default()
        let date = self.reminderDatePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "hh mm ss a"
        var ssdate = formatter.string(from: date).components(separatedBy: " ")
        var hour = Int(ssdate[0])!
        let minute = Int(ssdate[1])!
        var second = Int(ssdate[2])!
        second = 0
        if(ssdate[3] == "PM"){
          hour += 12
        }
        var reminder = DateComponents()
        reminder.hour = hour
        reminder.minute = minute
        reminder.second = second
        let trigger = UNCalendarNotificationTrigger(dateMatching: reminder, repeats: false)
        let identifier = "reminder-notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger )
        center.add(request) { (error) in
            if let err = error {
                print("something wrong \(err)")
            }
        }
    }
    
    
    
   

}
