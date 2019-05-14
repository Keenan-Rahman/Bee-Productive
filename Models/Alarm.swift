//
//  Alaram.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 07/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import Foundation

private struct propertykey {
    static let date = "date"
    static let todoList = "todoList"
    static let todoItemStatus = "todoItemStatus"
    static let alarmStatus = "alarmStatus"
    static let alarmTimer = "alarmTimer"
}

class Alarm: NSObject, NSCoding{
    
  
    var date : Date
    var todoList : [String]
    var todoItemStatus : [Int]
    var alarmStatus : Int
    
    
    init(_ date:Date, _ todoList:[String],_ todoItemStatus:[Int], _ alarmStatus:Int) {
        self.date = date
        self.todoList = todoList
        self.todoItemStatus = todoItemStatus
        self.alarmStatus = alarmStatus
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.date = aDecoder.decodeObject(forKey: propertykey.date) as! Date
        self.todoList = aDecoder.decodeObject(forKey: propertykey.todoList) as! [String]
        self.todoItemStatus = aDecoder.decodeObject(forKey: propertykey.todoItemStatus) as! [Int]
        self.alarmStatus = Int(aDecoder.decodeInt64(forKey: propertykey.alarmStatus))
      
        
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: propertykey.date)
        aCoder.encode(todoList, forKey: propertykey.todoList)
        aCoder.encode(todoItemStatus, forKey: propertykey.todoItemStatus)
        aCoder.encode(alarmStatus, forKey: propertykey.alarmStatus)
       
        
    }
}

class AlarmPresistStorage: presistantStorage{
     var key: String = "a"
    
    func saveData(_ alarms: [AnyObject]) {
        var AlarmArray : [Alarm] = []
        for obj in alarms{
            AlarmArray.append(obj as! Alarm)
        }
        let AlarmsData = NSKeyedArchiver.archivedData(withRootObject: AlarmArray)
        UserDefaults.standard.set(AlarmsData, forKey:self.key)
        
        
    }
    
    func loadData() -> [AnyObject] {
        guard let alarmData = UserDefaults.standard.object(forKey: "a") as? NSData else{
            print("alarm data not found in userdefaultd")
            return []
        }
        guard let alarmArray = NSKeyedUnarchiver.unarchiveObject(with: alarmData as Data) as? [Alarm] else{
            print("can't unarchieve alarm")
            return []
        }
        
        return alarmArray
        
    }
    
}
