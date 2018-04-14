//
//  Algorithms.swift
//  ChatSyncAlgorithmsPrototype
//
//  Created by Xavier Lian on 4/13/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import Foundation

func rearrangeAndObtainUnsyncedDict(from model: inout [DataThing]) -> [Int:DataThing]
{
    var dict = [Int:DataThing]()
    var collected = [DataThing]()
    
    //Go backwards so removals work without crashing
    for (x, data) in model.enumerated().reversed()
    {
        if data.color == .red
        {
            collected.append(data)
            dict[data.value] = data
            model.remove(at: x)
        }
    }
    //Append collected back into the model
    model.append(contentsOf: collected.reversed())  //Maintain original order
    return dict
}

func incorporate<X: Comparable>(sortedUpdate update: [X], intoSortedModel current: [X],
                                updateCondition: (_ lhs: X, _ rhs: X) -> (Bool)) -> [X]
{
    //Turn both into linked lists O(c + u)
    let currentLL = XLinkedList<X>(current)
    let updateLL = XLinkedList<X>(update)
    
    //Start at the top
    var currentCursor = currentLL.first
    
    //A pointer to help with node transfers
    var transferCursor: XLinkedListNode<X>?
    
    //Keep going until one of the cursors reaches its end (enables force unwrapping too) O(u)
    while updateLL.first != nil && currentCursor != nil
    {
        //Fire this conditional on every loop to decide how to merge update into current
        if updateLL.first!.value == currentCursor!.value
        {
            //If cursors have the same value, advance update
            updateLL.first = updateLL.first?.next
            
            //Snip off update's previous
            updateLL.first?.prev?.next = nil
            updateLL.first?.prev = nil
        }
        else
        {
            //If the cursors aren't equal, then fire off this conditional chain
            if updateLL.first!.value < currentCursor!.value
            {
                //If the value in update belongs above currentCursor's value, then insert above
                transferCursor = updateLL.first
                
                //Advance update's first
                updateLL.first = updateLL.first?.next
                
                //Detach from update
                transferCursor?.next?.prev = nil
                transferCursor?.next = nil
                
                //Attach to current
                transferCursor?.next = currentCursor
                transferCursor?.prev = currentCursor?.prev
                
                //Have current absorb the transfer
                currentCursor?.prev?.next = transferCursor
                currentCursor?.prev = transferCursor
                
                //Check to see if current's first got updated (if inserting at beginning)
                if currentCursor === currentLL.first
                {
                    currentLL.first = transferCursor
                }
                //Have transfer cursor let go AND DO NOT ADVANCE currentCursor
                transferCursor = nil
            }
            else if updateCondition(currentCursor!.value, updateLL.first!.value)
            {
                //If currentCursor's value needs updating, then update it by replacing
                transferCursor = updateLL.first
                
                //Advance update's first
                updateLL.first = updateLL.first?.next
                
                //Detach from update
                transferCursor?.next?.prev = nil
                transferCursor?.next = nil
                
                //Attach to current
                transferCursor?.next = currentCursor?.next
                transferCursor?.prev = currentCursor?.prev
                
                //Have current absorb the transfer
                currentCursor?.prev?.next = transferCursor
                currentCursor?.next?.prev = transferCursor
                
                //If inserting at the first location, update first
                if currentCursor! === currentLL.first!
                {
                    currentLL.first = transferCursor
                }
                //Expel the old value
                currentCursor?.next = nil
                currentCursor?.prev = nil
                currentCursor = nil
                
                //Have currentCursor now point to the refreshed value
                currentCursor = transferCursor
                
                //Have transfer cursor let go
                transferCursor = nil
            }
            else
            {
                //If update's first's value < currentCursor's value, only advance current
                currentCursor = currentCursor?.next
            }
        }
    }
    //If there are still remaining things in update, append them to current
    if updateLL.first != nil
    {
        currentLL.last?.next = updateLL.first
        updateLL.first?.prev = currentLL.last
        currentLL.last = updateLL.last
        
        //If current is empty, make its new first update's first
        if currentLL.first == nil
        {
            currentLL.first = updateLL.first
        }
    }
    //Return result - O(c + u)
    return currentLL.toArray()
}
