//
//  ChatSyncAlgorithmsPrototypeTests.swift
//  ChatSyncAlgorithmsPrototypeTests
//
//  Created by Xavier Lian on 4/13/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import XCTest
@testable import ChatSyncAlgorithmsPrototype

class ChatSyncAlgorithmsPrototypeTests: XCTestCase
{
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
    
    /// This tests if syncing the first value breaks the algorithm.
    /// Originally solved by updating current's linked list's first pointer after replacing it.
    func testIncorporatedOnSpecificCase1()
    {
        var current = [DataThing]()
        current.append(DataThing(value: 1, color: .red))
        current.append(DataThing(value: 2, color: .red))
        current.append(DataThing(value: 3, color: .red))
        current.append(DataThing(value: 6, color: .white))
        current.append(DataThing(value: 7, color: .white))
        current.append(DataThing(value: 8, color: .white))
        
        var incoming = [DataThing]()
        incoming.append(DataThing(value: 1, color: .white))
        incoming.append(DataThing(value: 2, color: .white))
        incoming.append(DataThing(value: 8, color: .white))
        incoming.append(DataThing(value: 9, color: .white))
        
        var expectedResult = [DataThing]()
        expectedResult.append(DataThing(value: 1, color: .white))
        expectedResult.append(DataThing(value: 2, color: .white))
        expectedResult.append(DataThing(value: 3, color: .red))
        expectedResult.append(DataThing(value: 6, color: .white))
        expectedResult.append(DataThing(value: 7, color: .white))
        expectedResult.append(DataThing(value: 8, color: .white))
        expectedResult.append(DataThing(value: 9, color: .white))
        
        let result = incorporate(sortedUpdate: incoming, intoSortedModel: current,
                                 updateCondition: {$0.value == $1.value && $0.color != $1.color})
        
        if result.count != expectedResult.count
        {
            XCTFail()
        }
        else
        {
            for x in 0 ..< expectedResult.count
            {
                XCTAssertEqual(result[x], expectedResult[x])
            }
        }
    }
    
    func testIncorporatedAlgorithmOnSameDataSets()
    {
        for _ in 0 ..< 50
        {
            var commonSyncedData = [DataDude]()
            for _ in 0 ..< 30
            {
                commonSyncedData.append(DataDude(key: UUID().uuidString,
                                                 order: Int(arc4random_uniform(500))))
            }
            commonSyncedData = commonSyncedData.sorted()
            
            var theOtherData = [DataDude]()
            theOtherData.append(contentsOf: commonSyncedData)
            
            let result = incorporate(sortedUpdate: commonSyncedData, intoSortedModel: theOtherData,
                                     updateCondition: {$0.key == $1.key})
            
            if commonSyncedData.count != result.count
            {
                XCTFail()
            }
            for x in 0 ..< commonSyncedData.count
            {
                XCTAssertEqual(result[x], commonSyncedData[x])
            }
        }
    }
}
