
//
//  Queue.swift
//

import UIKit

struct MessagesDataSource{
    var list = NSMutableArray()
    
    mutating func enqueue(_ element: NSDictionary) {
        list.add(element)
    }
    
    mutating func dequeue(){
        if list.count > 0 {
            list.removeObject(at: 0)
        }
    }
    
    func peek() -> NSDictionary? {
        if list.count > 0 {
            return list.object(at: 0) as? NSDictionary
            
        }else{
            return nil
        }
    }
    
    var isEmpty: Bool {
        if list.count > 0{
            return false
        }
        return true
    }
}


