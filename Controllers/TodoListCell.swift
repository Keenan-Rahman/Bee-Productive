//
//  TodoListCell.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 06/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import UIKit

class TodoListCell: UITableViewCell {
    
    
    let checkboxImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    
    let textfield: UITextView = {
        let textView = UITextView()
        
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
  let ImageViewContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
      
        addSubview(ImageViewContainer)
        ImageViewContainer.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        ImageViewContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ImageViewContainer.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        ImageViewContainer.widthAnchor.constraint(equalToConstant: 40).isActive = true
      
        ImageViewContainer.addSubview(checkboxImage)
        
        checkboxImage.centerXAnchor.constraint(equalTo: ImageViewContainer.centerXAnchor).isActive = true
        checkboxImage.centerYAnchor.constraint(equalTo: ImageViewContainer.centerYAnchor).isActive = true
        checkboxImage.widthAnchor.constraint(equalTo: ImageViewContainer.heightAnchor, multiplier: 0.40 ).isActive = true
        checkboxImage.heightAnchor.constraint(equalTo: ImageViewContainer.widthAnchor, multiplier: 0.50).isActive = true
        
        addSubview(textfield)
        
        textfield.leftAnchor.constraint(equalTo: ImageViewContainer.rightAnchor, constant: 2).isActive = true
        textfield.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textfield.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func changeStatusOfTodoItem(_ index:Int){
        //  appData.Status[index] = self.appData.Status[index] == 1 ? 0:1
        //saveAppData()
    }

    
    

}
