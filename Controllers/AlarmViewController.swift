//
//  AlarmViewController.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 05/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit


class AlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    // variables
    let cellID = "AlarmCell"
    var alarms : [Alarm] = []
    let alarmStorage = AlarmPresistStorage()
    
    // outlets
    
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        guard let alarmData = alarmStorage.loadData() as? [Alarm] else{
            print("error in loading alarm")
            return
        }
        self.alarms = alarmData
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = alarmTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        //cell text
        let alarm: Alarm = alarms[indexPath.row]
        let amAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 20.0)]
        let dateformater = DateFormatter()
        dateformater.dateFormat = "hh:mm a"
        let dateString = dateformater.string(from: alarm.date)
        let str = NSMutableAttributedString(string: dateString, attributes: amAttr)
        let timeAttr: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 45.0)]
        str.addAttributes(timeAttr, range: NSMakeRange(0, str.length-2))
        cell.textLabel?.attributedText = str
        cell.detailTextLabel?.text = "Alarm"
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
        alarmTableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.alarms.remove(at: indexPath.row)
            self.alarmTableView.deleteRows(at: [indexPath], with: .fade)
            self.alarmStorage.saveData(self.alarms)
            
            
        }
    }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAlarm"{
          let navController = segue.destination as! UINavigationController
          let controller = navController.topViewController as! AddAlarmViewController
          controller.preControllerReference = self
           
            
        }
        else if segue.identifier == "AlaramDetail"{
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! TodoListViewController
            controller.preControllerReference = self
            if let indexpath = alarmTableView.indexPathForSelectedRow {
                controller.selectedrow = indexpath.row
            }
        }
    }
}
