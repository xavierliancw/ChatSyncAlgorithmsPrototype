//
//  Data Structures.swift
//  ChatSyncAlgorithmsPrototype
//
//  Created by Xavier Lian on 4/13/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import Foundation

class XLinkedListNode<X>
{
    var next: XLinkedListNode<X>? = nil
    weak var prev: XLinkedListNode<X>? = nil
    var value: X
    
    init(_ value: X)
    {
        self.value = value
    }
}

class XLinkedList<X>
{
    //MARK: Properties
    
    var count: Int {
        var returnVal: Int = 0
        var cursor = first
        while cursor != nil
        {
            returnVal += 1
            cursor = cursor?.next
        }
        return returnVal
    }
    var first: XLinkedListNode<X>?
    var last: XLinkedListNode<X>?
    var isEmpty: Bool {return first == nil}
    
    //MARK:- Functions
    //MARK: Accessors
    
    func at(_ index: Int) -> X?
    {
        guard index > -1 else {return nil}
        
        var counter: Int = 0
        var cursor = first
        
        //Loop until the desired index is attained or if a nil is attained
        while counter != index && cursor != nil
        {
            cursor = cursor?.next
            counter += 1
        }
        return cursor?.value
    }
    
    func toArray(reversed: Bool = false) -> [X]
    {
        var daArray = [X]()
        
        if !reversed
        {
            var cursor = first
            while cursor != nil
            {
                daArray.append(cursor!.value)
                cursor = cursor?.next
            }
        }
        else
        {
            var cursor = last
            while cursor != nil
            {
                daArray.append(cursor!.value)
                cursor = cursor?.prev
            }
        }
        return daArray
    }
    
    //MARK: Modifiers
    
    /// Adds an element to the end of the linked list such that the new element is the new last.
    func append(_ element: X)
    {
        let cursor = last
        
        //If list is empty
        if cursor == nil
        {
            first = XLinkedListNode(element)
            last = first
        }
        else
        {
            cursor?.next = XLinkedListNode(element)
            last = cursor?.next
            last?.prev = cursor
        }
    }
    
    static func insert(list: XLinkedList<X>?, between node1: XLinkedListNode<X>?,
                       and node2: XLinkedListNode<X>?)
    {
        //Inserting an empty list doesn't count as inserting, so don't do it
        guard let list = list, !list.isEmpty else {return}
        
        //Also make sure node 1 isn't the same as 2
        guard node1 !== node2 else {return}
        
        //When inserting at beginning or end, don't worry about leaks
        if !(node1 == nil || node2 == nil)
        {
            //Also, avoid memory leaks and retain cycles
            guard node1 !== list.first, list.first?.prev !== node1,
                node2?.prev !== list.last, list.last?.next !== node2,
                node2 !== list.first, node1 !== list.last else {return}
        }
        //Kill nodes between nodes 1 and 2
        node1?.next?.prev = nil
        node2?.prev?.next = nil
        
        //Join
        node1?.next = list.first
        list.first?.prev = node1
        node2?.prev = list.last
        list.last?.next = node2
    }
    
    //MARK: Initialization
    
    init() {}
    
    init(_ array: [X])
    {
        var cursor: XLinkedListNode<X>?
        var lastNode: XLinkedListNode<X>?
        
        for thing in array
        {
            //Create new node
            cursor = XLinkedListNode(thing)
            
            if isEmpty
            {
                //If empty, assign first
                first = cursor
            }
            else
            {
                //Otherwise join
                lastNode?.next = cursor
                cursor?.prev = lastNode
            }
            lastNode = cursor
        }
        last = lastNode
    }
}
