//
//  RoomType.swift
//  HoteManzana
//
//  Created by 曹家瑋 on 2023/10/13.
//

import Foundation

/// 房型資料
struct RoomType: Equatable {
    /// 房型的識別ID
    var id: Int
    /// 房型的名稱
    var name: String
    /// 房型的縮寫名稱
    var shortName: String
    /// 房型的價格
    var price: Int
    
    /// 透過ID來比較兩個房型是否相同
    static func ==(lhs: RoomType, rhs: RoomType) -> Bool {
        return lhs.id == rhs.id
    }
    
    /// 房間類型數據
    static var all: [RoomType] {
        return [RoomType(id: 0, name: "Two Queens", shortName: "2Q", price: 179),
                RoomType(id: 1, name: "One King", shortName: "K", price: 209),
                RoomType(id: 2, name: "Penthouse Suite", shortName: "PHS", price: 309)
        ]
    }
}

