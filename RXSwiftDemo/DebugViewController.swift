//
//  DebugViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/15.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        debug()
    }
    
    /**
     我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
     */
    func debug() {
        _ = Observable.of(1, 2).startWith(0).debug().subscribe {
            print($0)
        }
    }
}
