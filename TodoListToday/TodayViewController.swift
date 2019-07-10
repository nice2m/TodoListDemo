//
//  TodayViewController.swift
//  TodoListToday
//
//  Created by Ganjiuhui on 2019/7/8.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import UIKit
import NotificationCenter

// sync data ways:

    // 1.Userdefault

    // 2.fileManager

    // 3.keychain

struct Todo: Codable {
    var id: String?
    var versions:[String]?
    var contents:String?
    var state:Int
    var isEdit:Bool = false
    
    
    func toDictionary() -> [String:Any] {
        var tmpRt = [String:Any]()
        
        tmpRt["id"] = self.id
        tmpRt["versions"] = []
        tmpRt["contents"] = self.contents
        tmpRt["state"] = self.state
        tmpRt["isEdit"] = self.isEdit
        
        return tmpRt
    }
    
    
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var table:UITableView!
    var data:[Todo] = []
    let kCellReuseId = "kCellReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func configSubView() {
        table = UITableView.init(frame: .zero, style: .plain)
        view .addSubview(table)
        table.delegate = self
        table.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        print("mode:%d\tmaxSize:%@",activeDisplayMode,maxSize)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController:UITableViewDelegate,UITableViewDataSource
{
    //MARK: - Data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    //MARK: - Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let aCell = tableView.dequeueReusableCell(withIdentifier: kCellReuseId) else {
            let tmpCell = UITableViewCell.init()
            tmpCell.textLabel?.text = data[indexPath.row].contents ?? "Nal"
            tmpCell.accessoryType = .none
            tmpCell.selectionStyle = .none
            return tmpCell
            
        }
        aCell.textLabel?.text = data[indexPath.row].contents ?? "Nal"
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath)")
    }
    
}
