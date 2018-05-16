//
//  RxTableViewViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/16.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxTableViewViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

      
        self.view.addSubview(tableView)
        
        //初始化数据
        let items = Observable.just([
            ["title" : "文本输入框的用法"],
            ["title" : "开关按钮的用法"],
            ["title" : "进度条的用法"],
            ["title" : "文本标签的用法"],
            ])
        
        //设置单元格数据（其实就是对 cellForRowAt 的封装）
        _ = items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(row)：\(String(describing: element["title"]))"
            return cell
        }
        
        //单元格选中事件响应
        _ = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(NSDictionary.self)).bind { (indexPath, item) in
            print("第\(indexPath.row)行: \(String(describing: item["title"]))")
        }
    }
    
    
    lazy var tableView:UITableView = {
        
        let tableView = UITableView(frame: self.view.frame, style:.plain)
        //创建一个重用的单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
        
    }()

}
