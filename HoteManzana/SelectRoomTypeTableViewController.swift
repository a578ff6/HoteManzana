//
//  SelectRoomTypeTableViewController.swift
//  HoteManzana
//
//  Created by 曹家瑋 on 2023/10/13.
//

import UIKit

// 定義一個協定(protocol)，這個協定定義了一個方法，用於通知其他類別（例如代理）當一個房間類型被選中時該如何回應。
protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    // 當一個房間類型被選中時，這個方法會被呼叫，並將相關的控制器和被選中的房間類型作為參數傳入。
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {

    // id
    struct PropertyKeys {
        static let roomTypeCell = "RoomTypeCell"
    }
    
    // 保存實現協定的實例的引用。
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    /// 存放當前選擇的房間類型
    var roomType : RoomType?
    

    // MARK: - Table view data source

    // 表格視圖的 row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }

    // 為每一 row 配置它要顯示的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.roomTypeCell, for: indexPath)
        
        // 從RoomType.all陣列中取得當前行應該顯示的RoomType
        let roomType = RoomType.all[indexPath.row]
        
        // 使用cell的默認內容配置對象來設置文字
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "$ \(roomType.price)"
        cell.contentConfiguration = content

        // 使用checkmark（打勾）作為選中行的標示。
        // 該行的房間類型等於已選擇的房間類型，則附加視圖類型設定為.checkmark。否則，將它設定為.none。
        if roomType == self.roomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    // MARK: - Table view Delegate
    
    // 當用戶選擇一個（cell）時，這個方法會被調用。
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 取消選擇該行（移除灰色高亮顯示）。
        tableView.deselectRow(at: indexPath, animated: true)
        // 將 roomType 屬性設定為對應的房間類型。
        let roomType = RoomType.all[indexPath.row]
        // 將剛取出的roomType存儲到當前控制器的roomType屬性中。
        self.roomType = roomType
        // 通知delegate：「用戶選中了一個房間類型」，並將當前控制器（self）和選中的房間類型（roomType）傳給delegate。
        delegate?.selectRoomTypeTableViewController(self, didSelect: roomType)
        // 刷新表格視圖
        tableView.reloadData()
    }


}
