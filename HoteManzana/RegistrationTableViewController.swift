//
//  RegistrationTableViewController.swift
//  HoteManzana
//
//  Created by 曹家瑋 on 2023/10/14.
//

import UIKit

class RegistrationTableViewController: UITableViewController {

    // 用於識別reuse的cell
    struct PropertyKeys {
        static let registrationCell = "RegistrationCell"
    }
    
    // 用來儲存所有的 registrations 資料
    var registrations: [Registration] = []
    
    
    // 定義一個從AddRegistrationTableViewController回來的unwind segue
    @IBAction func unwindFromAddRegistration(_ unwindSegue: UIStoryboardSegue) {
        // 確認segue的來源視圖控制器並取得registration物件
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
                let registration = addRegistrationTableViewController.registration else { return }
        
        // 如果確定有獲得有效的registration物件，則添加至registrations陣列並刷新表格視圖
        registrations.append(registration)
        tableView.reloadData()
    }
    

    // MARK: - Table view data source

    // 定義表格視圖的section數量
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 定義每個區塊的行數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 每個區塊的行數就是所有註冊資料的數量
        return registrations.count
    }

    
    // 定義每行的單元格內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 從重用池中取得單元格或創建一個新的
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.registrationCell, for: indexPath)
        // 從registrations陣列中取得對應的registration物件
        let registration = registrations[indexPath.row]
        
        // 配置單元格的內容
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName + " " + registration.lastName
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ":" + registration.roomType.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    

}

