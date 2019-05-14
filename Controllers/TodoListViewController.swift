//
//  TodoListViewController.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 05/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
   
    
    // constraints
    
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    
    // variables
    var preControllerReference : AlarmViewController?
    var selectedrow : Int?
    var cellId = "detailTodos"
    // outlets
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    
    @IBOutlet weak var characterCountLable: UILabel!
    @IBOutlet weak var addTodoitem: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailTableView.delegate = self
        self.detailTableView.dataSource = self
    self.detailTableView.register(TodoListCell.self, forCellReuseIdentifier: self.cellId)
      self.inputTextView.delegate = self
        
        addTodoitem.layer.cornerRadius = addTodoitem.frame.size.width / 2
        addTodoitem.layer.masksToBounds = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(addButtonClicked))
        addTodoitem.addGestureRecognizer(tap)
        addTodoitem.isUserInteractionEnabled = true
      // delete empty seperator lines
       detailTableView.tableFooterView = UIView(frame: CGRect.zero)
       
        // Do any additional setup after loading the view.
    }
    
    func addButtonClicked(){
        inputViewBottomConstraint.constant = 300
        UIView.animate(withDuration: 0.15) {
            self.view.layoutIfNeeded()
        }
        inputTextView.becomeFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if(newText.count <= 70){
            characterCountLable.text = "\(newText.count)/70"
        }
        
        return newText.count <= 70
    }
    
    @IBAction func undoButtonInputView(_ sender: Any) {
        
        inputViewBottomConstraint.constant = 800
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
        inputTextView.endEditing(true)
    }
    
    @IBAction func saveTodoItemButton(_ sender: Any) {
        self.inputTextView.endEditing(true)
        inputViewBottomConstraint.constant = 800
        UIView.animate(withDuration: 0.6) {
            self.view.layoutIfNeeded()
        }
        self.preControllerReference?.alarms[selectedrow!].todoList.append(self.inputTextView.text)
        self.preControllerReference?.alarms[selectedrow!].todoItemStatus.append(0)
        self.preControllerReference?.alarmStorage.saveData((self.preControllerReference?.alarms)!)
        self.detailTableView.reloadData()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (preControllerReference?.alarms[selectedrow!].todoList.count)!
    }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailTableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! TodoListCell
      cell.checkboxImage.image = preControllerReference?.alarms[selectedrow!].todoItemStatus[indexPath.row] == 0 ? UIImage(named:"unchecked"): UIImage(named:"checked")
       let todoItem = preControllerReference?.alarms[selectedrow!].todoList[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
      cell.checkboxImage.addGestureRecognizer(tap)
      cell.checkboxImage.isUserInteractionEnabled = true
      
      let fontSize: [String : Any] = [NSFontAttributeName : UIFont.systemFont(ofSize: 16.0)]
      let str = NSMutableAttributedString(string: todoItem!, attributes: fontSize)
      cell.textfield.attributedText = str
      
      // cell colour
      cell.backgroundColor = UIColor.init(red: 71/255, green: 70/255, blue: 134/255, alpha: 1)
      cell.textfield.backgroundColor = UIColor.init(red: 71/255, green: 70/255, blue: 134/255, alpha: 1)
      cell.textfield.textColor = UIColor.white
      // delete empty seperator lines
      tableView.tableFooterView = UIView(frame: CGRect.zero)
      
        return cell
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self.detailTableView)
        let indexPath = self.detailTableView.indexPathForRow(at: tapLocation)! as NSIndexPath
        
        let cell = self.detailTableView.cellForRow(at: indexPath as IndexPath) as! TodoListCell
        
        cell.checkboxImage.image = cell.checkboxImage.image == UIImage(named: "checked") ?  UIImage(named: "unchecked"):UIImage(named: "checked")
        self.preControllerReference?.alarms[selectedrow!].todoItemStatus[indexPath.row] = self.preControllerReference?.alarms[selectedrow!].todoItemStatus[indexPath.row] == 0 ? 1:0
        self.preControllerReference?.alarmStorage.saveData((self.preControllerReference?.alarms)!)
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.preControllerReference?.alarms[selectedrow!].todoList.remove(at: indexPath.row)
            self.preControllerReference?.alarms[selectedrow!].todoItemStatus.remove(at: indexPath.row)
            self.preControllerReference?.alarmStorage.saveData((self.preControllerReference?.alarms)!)
            self.detailTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
