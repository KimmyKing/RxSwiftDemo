//
//  Model.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/14.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import Foundation

class Model:NSObject {
    
    @objc var title: String = ""
    @objc var targetController = ""
    
    init(dic:[String : Any]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        return ""
    }
    
}
