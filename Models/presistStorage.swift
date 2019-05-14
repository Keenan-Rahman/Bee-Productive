//
//  presistStorage.swift
//  HCI Project
//
//  Created by Muhammad Shahzaib Vohra on 07/11/2017.
//  Copyright © 2017 Muhammad Shahzaib Vohra. All rights reserved.
//

import Foundation

protocol presistantStorage {
    var key : String {get}
    func saveData(_ lable : [AnyObject])
    func loadData() -> [AnyObject]
}
