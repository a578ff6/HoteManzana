//
//  Registration.swift
//  HoteManzana
//
//  Created by 曹家瑋 on 2023/10/13.
//

import Foundation

/// 客人的資料
struct Registration {
    
    var firstName: String  // 客人的名字
     var lastName: String   // 客人的姓氏
     var emailAddress: String   // 客人的電子郵件
     
     var checkInDate: Date  // 入住日期
     var checkOutDate: Date // 退房日期
     
     var numberOfAdults: Int   // 房間內的成人數
     var numberOfChildren: Int // 房間內的兒童數
     
     var wifi: Bool   // 是否需要 Wi-Fi
     
     var roomType: RoomType    // 客人選擇的房型
}

