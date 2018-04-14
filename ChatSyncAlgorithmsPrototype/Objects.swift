//
//  Objects.swift
//  ChatSyncAlgorithmsPrototype
//
//  Created by Xavier Lian on 4/14/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import UIKit

struct DataThing: Hashable, Comparable, Equatable
{
    let value: Int
    var color: UIColor
    var isSynced: Bool {return color != .red}
    var hashValue: Int {return value}
    static func < (lhs: DataThing, rhs: DataThing) -> Bool {return lhs.value < rhs.value}
    static func ==(lhs: DataThing, rhs: DataThing) -> Bool
    {
        return lhs.value == rhs.value && lhs.color == rhs.color
    }
}

struct DataDude: Comparable, Hashable
{
    let key: String
    let order: Int?
    var hashValue: Int {return key.hashValue}
    
    static func < (lhs: DataDude, rhs: DataDude) -> Bool
    {
        if lhs.order == nil
        {
            return false
        }
        if rhs.order == nil
        {
            return true
        }
        return lhs.order! < rhs.order!
    }
    static func ==(lhs: DataDude, rhs: DataDude) -> Bool
    {
        return lhs.key == rhs.key && lhs.order == rhs.order
    }
    
    init(upperBound: Int, manualKey: String? = nil)
    {
        key = manualKey ?? UUID().uuidString
        if Int(arc4random_uniform(2)) == 0
        {
            order = Int(arc4random_uniform(UInt32(upperBound)))
        }
        else
        {
            order = nil
        }
    }
    init(key: String, order: Int?)
    {
        self.key = key
        self.order = order
    }
}
