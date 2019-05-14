//
//  AddAlarmViewController.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 05/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit
import Foundation

class AddAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    // constraints
    
    @IBOutlet weak var inputViewBottomConstrain: NSLayoutConstraint!
    
    // Variables
    
    var cellId = "TodoListCell"
    var alarm = Alarm(Date(),[String](),[Int](),Int())
    weak var preControllerReference : AlarmViewController?
    
    // UI Fields
    @IBOutlet weak var TodotableView: UITableView!
    @IBOutlet weak var InputTextView: UITextView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var addButtonField: UIImageView!
    
    @IBOutlet weak var characterCountLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //register Custom cell class for table view
        TodotableView.register(TodoListCell.self, forCellReuseIdentifier: cellId)
        TodotableView.dataSource = self
        TodotableView.delegate = self
        TodotableView.separatorColor = UIColor.init(red: 40/255, green: 38/255, blue: 96/255, alpha: 1)
        addButtonField.layer.cornerRadius = addButtonField.frame.size.width / 2
        addButtonField.layer.masksToBounds = true
      
       InputTextView.delegate = self
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked))
        addButtonField.addGestureRecognizer(tap)
        addButtonField.isUserInteractionEnabled = true
        
        datePickerView.setValue(UIColor.white, forKey: "textColor")
        
        // delete empty seperator lines
        TodotableView.tableFooterView = UIView(frame: CGRect.zero)
    }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
    if(newText.count <= 70){
        characterCountLable.text = "\(newText.count)/70"
    }
    
    return newText.count <= 70
  }
  
    func addButtonClicked(){
        inputViewBottomConstrain.constant = 300
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
        }
        InputTextView.becomeFirstResponder()
    }
    
    @IBAction func undoButtonInputView(_ sender: Any) {
        inputViewBottomConstrain.constant = 800
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
            
        }
        InputTextView.endEditing(true)
    }
    
    @IBAction func Save(_ sender: Any) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "hh:mm a"
        let dateSelectedFromDatePicker = self.datePickerView.date
        let AlaramTimeLable = dateFormater.string(from: dateSelectedFromDatePicker)
        print(AlaramTimeLable)
        alarm.date = datePickerView.date
        alarm.alarmStatus = 1
        self.preControllerReference?.alarms.append(alarm)
        setAlaram(alarm.date)
        self.preControllerReference?.alarmStorage.saveData((self.preControllerReference?.alarms)!)
        self.preControllerReference?.alarmTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setAlaram(_ date:Date){
        
        var date = date
        if(date < Date()){
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        var component = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        component.second = 0
        let modifiedDateTime = calendar.date(from: component)!
        
        let rem = Timer(fireAt: modifiedDateTime, interval: 0, target: self, selector: #selector(self.setSpeechRecognizeAsAlaram(sender:)), userInfo:self.alarm.todoList, repeats: false)
        RunLoop.main.add(rem, forMode: RunLoopMode.commonModes)
        
        
    }
    
    @objc func setSpeechRecognizeAsAlaram(sender:Timer){
        
        let todoList = sender.userInfo as! [String]
        
        let numberOfTodo = String(todoList.count)


        var items = String()
        var counter = 1
        for item in todoList {
            items += String(counter) + ", " + item + ". "
            counter += 1
        }

        let date = Date()
        let dateformat1 = DateFormatter()
        let dateformat2 = DateFormatter()
        dateformat1.dateStyle = .full
        dateformat2.dateFormat = "hh:mm a"
        var sentence = String()
        
        if(todoList.count == 0){
            sentence = " Good Morning! It’s" + dateformat2.string(from: date) + "!. And it’s time to wake up!. I’m disappointed in you today. You forgot to add in new “TO-DO” items to your list."
        }
        else{
            sentence = "Good Morning! Its " + dateformat2.string(from: date) + "!. And its time to wake up. Today is " + dateformat1.string(from: date) + ". You have " + numberOfTodo + " items on your to-do list for the day. " + items + " Thats all!. I hope you have a productive day! "
        }

        let spk = Speaking()
        spk.speak(string: sentence)
        
    }
    

    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func SaveTodoItemButton(_ sender: Any) {
        inputViewBottomConstrain.constant = 800
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
        InputTextView.endEditing(true)
        let text  = InputTextView.text!
        alarm.todoList.append(text)
        alarm.todoItemStatus.append(0)
        self.TodotableView.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarm.todoList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodotableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TodoListCell
      
        let fontSize: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 16.0)]
        let str = NSMutableAttributedString(string: alarm.todoList[indexPath.row], attributes: fontSize)
        cell.textfield.attributedText = str
      
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.checkboxImage.addGestureRecognizer(tap)
        cell.checkboxImage.image = UIImage(named: "unchecked")
        alarm.todoItemStatus.append(0)
        cell.checkboxImage.isUserInteractionEnabled = true
        
        // cell colour
        cell.backgroundColor = UIColor.init(red: 71/255, green: 70/255, blue: 134/255, alpha: 1)
        cell.textfield.backgroundColor = UIColor.init(red: 71/255, green: 70/255, blue: 134/255, alpha: 1)
        cell.textfield.textColor = UIColor.white
        // delete empty seperator lines
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.TodotableView)
        let indexPath = self.TodotableView.indexPathForRow(at: tapLocation)! as NSIndexPath
        
        let cell = self.TodotableView.cellForRow(at: indexPath as IndexPath) as! TodoListCell
        
        cell.checkboxImage.image = cell.checkboxImage.image == UIImage(named: "checked") ?  UIImage(named: "unchecked"):UIImage(named: "checked")
        alarm.todoItemStatus[indexPath.row] = alarm.todoItemStatus[indexPath.row] == 0 ? 1:0
        print(indexPath.row)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.TodotableView) == true {
            return false
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            alarm.todoList.remove(at: indexPath.row)
            alarm.todoItemStatus.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
}


//extension AddAlarmViewController{
//
//  // tableview cell dragging code ends here
//
//  func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
//    let longPress = gestureRecognizer as! UILongPressGestureRecognizer
//    let state = longPress.state
//    let locationInView = longPress.location(in: TableViewForList)
//    let indexPath = TableViewForList.indexPathForRow(at: locationInView)
//
//    struct My {
//      static var cellSnapshot : UIView? = nil
//      static var cellIsAnimating : Bool = false
//      static var cellNeedToShow : Bool = false
//    }
//    struct Path {
//      static var initialIndexPath : IndexPath? = nil
//    }
//
//    switch state {
//    case UIGestureRecognizerState.began:
//      if indexPath != nil {
//        Path.initialIndexPath = indexPath
//        let cell = TableViewForList.cellForRow(at: indexPath!) as UITableViewCell!
//        My.cellSnapshot  = snapshotOfCell(cell!)
//
//        var center = cell?.center
//        My.cellSnapshot!.center = center!
//        My.cellSnapshot!.alpha = 0.0
//        TableViewForList.addSubview(My.cellSnapshot!)
//
//        UIView.animate(withDuration: 0.25, animations: { () -> Void in
//          center?.y = locationInView.y
//          My.cellIsAnimating = true
//          My.cellSnapshot!.center = center!
//          My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
//          My.cellSnapshot!.alpha = 0.98
//          cell?.alpha = 0.0
//        }, completion: { (finished) -> Void in
//          if finished {
//            My.cellIsAnimating = false
//            if My.cellNeedToShow {
//              My.cellNeedToShow = false
//              UIView.animate(withDuration: 0.25, animations: { () -> Void in
//                cell?.alpha = 1
//              })
//            } else {
//              cell?.isHidden = true
//            }
//          }
//        })
//      }
//
//    case UIGestureRecognizerState.changed:
//      if My.cellSnapshot != nil {
//        var center = My.cellSnapshot!.center
//        center.y = locationInView.y
//        My.cellSnapshot!.center = center
//
//        if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
//          appData.ToDoList.insert(appData.ToDoList.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
//          appData.Status.insert(appData.Status.remove(at: Path.initialIndexPath!.row), at: indexPath!.row)
//          TableViewForList.moveRow(at: Path.initialIndexPath!, to: indexPath!)
//          Path.initialIndexPath = indexPath
//        }
//      }
//    default:
//      if Path.initialIndexPath != nil {
//        let cell = TableViewForList.cellForRow(at: Path.initialIndexPath!) as UITableViewCell!
//        if My.cellIsAnimating {
//          My.cellNeedToShow = true
//        } else {
//          cell?.isHidden = false
//          cell?.alpha = 0.0
//        }
//
//        UIView.animate(withDuration: 0.25, animations: { () -> Void in
//          My.cellSnapshot!.center = (cell?.center)!
//          My.cellSnapshot!.transform = CGAffineTransform.identity
//          My.cellSnapshot!.alpha = 0.0
//          cell?.alpha = 1.0
//
//        }, completion: { (finished) -> Void in
//          if finished {
//            Path.initialIndexPath = nil
//            My.cellSnapshot!.removeFromSuperview()
//            My.cellSnapshot = nil
//          }
//        })
//      }
//    }
//    saveAppData()
//  }
//}

