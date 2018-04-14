//
//  Extensions.swift
//  ChatSyncAlgorithmsPrototype
//
//  Created by Xavier Lian on 4/14/18.
//  Copyright © 2018 XavierLian. All rights reserved.
//

import UIKit

extension UIScrollView
{
    /// https://stackoverflow.com/a/14745900/8462094
    var isAtTop: Bool
    {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtOrPastBottom: Bool
    {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat
    {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat
    {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
