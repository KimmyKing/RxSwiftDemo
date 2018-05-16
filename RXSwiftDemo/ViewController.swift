//
//  ViewController.swift
//  RXSwiftDemo
//
//  Created by Cain on 2018/5/8.
//  Copyright © 2018年 Yeapoo. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        for dic in sourceArray {
            let model = Model(dic: dic as! [String : Any])
            dataArray.add(model)
        }
        
    }

    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 40
        return tableView
        
    }()
    
    var sourceArray:NSArray {
        
        return [
            ["title" : "基础使用方法", "targetController" : "BasicUsageViewController"],
            ["title" : "订阅处理", "targetController" : "HandleSubscribeViewController"],
            ["title" : "观察UI属性", "targetController" : "BindUIPropertyViewController"],
            ["title" : "订阅者使用", "targetController" : "SubjectsViewController"],
            ["title" : "变换操作", "targetController" : "TransformingViewController"],
            ["title" : "错误处理", "targetController" : "CatchErrorViewController"],
            ["title" : "调试", "targetController" : "DebugViewController"],
            ["title" : "特征序列", "targetController" : "TraitsViewController"],
            ["title" : "UI扩展控件", "targetController" : "RxUIControlViewController"],
            ["title" : "双向绑定", "targetController" : "TwoWayDataViewController"],
            ["title" : "UITableView的使用", "targetController" : "RxTableViewViewController"],
        ]
        
    }
    
    lazy var dataArray:NSMutableArray = {
        let marr = NSMutableArray()
        return marr
    }()
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.row] as! Model
        //动态获取命名空间(CFBundleExecutable这个键对应的值就是项目名称,也就是命名空间)
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let Class = NSClassFromString(nameSpace + "." + model.targetController) as! UIViewController.Type
        let controller = Class.init()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.selectionStyle = .none
        let model = dataArray[indexPath.row] as! Model
        cell.textLabel?.text = model.title
        return cell
    }
    
}


