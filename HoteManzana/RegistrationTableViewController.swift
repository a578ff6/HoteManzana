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
    
    
    // MARK: - Navigation
    // 當使用者在 AddRegistrationTableViewController 完成編輯或新增註冊資料後，該方法將被調用。
    @IBAction func unwindFromAddRegistration(_ unwindSegue: UIStoryboardSegue) {
        // 確認segue的來源視圖控制器並取得registration物件
        guard let addRegistrationTableViewController = unwindSegue.source as? AddRegistrationTableViewController,
                let registration = addRegistrationTableViewController.registration else { 
            // print("Cannot retrieve registration data")  // 測試用
            return
        }
        
        // 檢查是否存在一個有效的 editingIndex。如果有，則更新對應索引的註冊資料，否則將新的註冊資料添加到陣列中。
        if let index = addRegistrationTableViewController.editingIndex {
            // print("Updating existing registration at index \(index)")    // 測試用
            registrations[index] = registration
        } else {
            // print("Adding new registration")         // 測試用
            // 如果確定有獲得有效的registration物件，則添加至registrations陣列並刷新表格視圖
            registrations.append(registration)
        }
        
        tableView.reloadData()
    }
    
    // 當點擊 cell 以編輯訂房註冊資料時將如何運作
    @IBSegueAction func showRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
        // 創建視圖控制器對象
        let addRegistrationTableViewController = AddRegistrationTableViewController(coder: coder)
        
        // 檢查發送者是否為 UITableViewCell 並嘗試找到其在表格視圖中的索引
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) 
        else {
            return addRegistrationTableViewController
        }
        
        // 獲取與被點擊 cell 對應的訂房資料
        let registration = registrations[indexPath.row]
        // 將 訂房資料 和 其在 registrations 陣列中的索引傳遞給下一個控制器
        addRegistrationTableViewController?.existingRegistration = registration
        addRegistrationTableViewController?.editingIndex = indexPath.row
              
        return addRegistrationTableViewController
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



// MARK: - 先前版本

/*
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
     
     // 顯示訂房資料
     @IBSegueAction func showRegistration(_ coder: NSCoder, sender: Any?) -> AddRegistrationTableViewController? {
         
         // 創建視圖控制器對象
         let addRegistrationTableViewController = AddRegistrationTableViewController(coder: coder)
         
         // 檢查發送者並獲取數據（確認 sender 是否為 UITableViewCell 並獲取其在表格視圖中的位置（indexPath）
         guard let cell = sender as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell)
         else {
             return addRegistrationTableViewController
         }
         
         // 獲取選中的註冊數據
         let registration = registrations[indexPath.row]
         
         // 傳遞數據到新的視圖控制器
         // 在AddRegistrationTableViewController中有一 個existingRegistration 的變數來接收數據
         addRegistrationTableViewController?.existingRegistration = registration
               
         return addRegistrationTableViewController
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
 */
