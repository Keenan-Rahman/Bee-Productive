//
//  Reminder.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 09/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import Foundation

private struct propertyKey {
    static let date = "date"
    static let remindText = "remindText"
    
}
class Reminder: NSObject, NSCoding{
    var date : Date
    var remindText : String
    
    init(_ date:Date, _ remindText:String){
        self.date = date
        self.remindText = remindText
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: propertyKey.date) as! Date
        self.remindText = aDecoder.decodeObject(forKey: propertyKey.remindText) as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: propertyKey.date)
        aCoder.encode(remindText, forKey: propertyKey.remindText)
    }
    
}


class ReminderPresistStorage: presistantStorage {
    var key = "reminders"
    
    func saveData(_ reminders: [AnyObject]) {
        var reminderArray : [Reminder] = []
        for obj in reminders{
            reminderArray.append(obj as! Reminder)
        }
        let reminderData = NSKeyedArchiver.archivedData(withRootObject: reminderArray)
        UserDefaults.standard.set(reminderData, forKey: self.key)
        
        
    }
    
    func loadData() -> [AnyObject] {
        guard let reminderData = UserDefaults.standard.object(forKey: self.key) as? NSData else{
            print("reminder data not found in userdefaultd")
            return []
        }
        guard let reminderArray = NSKeyedUnarchiver.unarchiveObject(with: reminderData as Data) as? [Reminder] else{
            print("can't unarchieve reminder")
            return []
        }
        
        return reminderArray
        
    }
}


