//
//  ReminderViewController.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 05/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // variables
    
    var reminders : [Reminder] = []
    let cellId = "ReminderCell"
    let reminderPersistStorage = ReminderPresistStorage()
    // outlets
    
    @IBOutlet weak var reminderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        reminderTableView.delegate = self
        reminderTableView.dataSource = self
        reminders = reminderPersistStorage.loadData() as! [Reminder]

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
      
      //cell text
      let reminder: Reminder = reminders[indexPath.row]
      let amAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0)]
      let dateformater = DateFormatter()
      dateformater.dateFormat = "hh:mm a"
      let dateString = dateformater.string(from: reminder.date)
      let str = NSMutableAttributedString(string: dateString, attributes: amAttr)
      let timeAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 45.0)]
      str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
      cell.textLabel?.attributedText = str
      cell.detailTextLabel?.text = reminder.remindText
      //append switch button
      let sw = UISwitch(frame: CGRect())
      sw.transform = CGAffineTransform(scaleX: 0.9, y: 0.9);
      sw.tag = indexPath.row
      // sw.addTarget(self, action: #selector(AlarmViewController.switchTapped(_:)), for: UIControlEvents.valueChanged)
      cell.accessoryView = sw
      
        // delete empty seperator lines
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.reminderTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.reminders.remove(at: indexPath.row)
            self.reminderPersistStorage.saveData(self.reminders)
            self.reminderTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddReminder" {
            let navController =  segue.destination as! UINavigationController
            let controller = navController.topViewController as! AddReminderViewController
            controller.preControllerReference = self
      
        }
    }
  
    
}
