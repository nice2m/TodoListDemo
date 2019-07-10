//
//  ViewController.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/6/27.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let localDataMgr = TodoLocalDataManager.shared
    
    var table:UITableView = UITableView.init(frame: .zero, style: .grouped)
    var rightBtn:UIBarButtonItem!
    var leftBtn:UIBarButtonItem!
    let cellReuseID = "TodoCell"
    
    var controllerState:ViewControllerState?{
        didSet(newVal){
            
            guard let aState = newVal else { return  }
            self.title = aState.title
            updateRightEnabled(enabled: !aState.isEditing)
            self.table .reloadData()
        }
    }
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configSubview()
        configObserver()
        //testLoalDataManager_userDefaultsFetchAndStore()
        
    }
//    func testLoalDataManager_userDefaultsFetchAndStore() {
//
//        let tmpData = generateTestData()
//        let storeRt = localDataMgr.storeData(type: .userDefaults, with: tmpData)
//        assert(storeRt, "userDefaults 写入 data 失败")
//        let fetchData = localDataMgr.fetchData(type: .userDefaults)
//
//        for i in 0..<tmpData.count
//        {
//            print("id1 \t\(tmpData[i].id)")
//            print("id2 \t\(fetchData[i].id)")
//
//        }
//    }
    
    func generateTestData()->[Todo]{
        var storeData = [Todo]()
        
        for i in 0..<5 {
            let id = UUID.init().uuidString
            let contents = String(format: "contents-%d", i)
            let state = 0
            let isEdit = false
            let version = [""]
            
            storeData.append(Todo.init(id: id, versions: version, contents: contents, state: state, isEdit: isEdit))
        }
        return storeData
    }

    //MARK: Private
    
    func configObserver(){
        
        let _ = TodoStore.default.subscribe { [weak self](oldState, newState) in
            self?.controllerState = newState
        }
        TodoStore.default.dispatch(action: .editingRowComplete(index: 0))
        
    }
    
    func configSubview() {
        
        title = "TodoList"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.kTheamColor]
        table.delegate = self
        table.dataSource = self
        
        view .addSubview(table)
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        table.contentInsetAdjustmentBehavior = .never
        table.frame = CGRect.init(x: 0, y: 0, width:TodoGlobal.screenWidth, height: TodoGlobal.screenHeight - TodoGlobal.barHeight)
        table.register(TodoCell.self, forCellReuseIdentifier: cellReuseID)
        
        let tmpBtn = UIButton.init(type: .custom)
        tmpBtn.setImage(UIImage.init(named: "add_icon"), for: .normal)
        tmpBtn .addTarget(self, action: #selector(leftButtonClick(sender:)), for: .touchUpInside)
        tmpBtn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        tmpBtn.imageEdgeInsets = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right:12)
        leftBtn = UIBarButtonItem.init(customView: tmpBtn)
        self.navigationItem.leftBarButtonItem = leftBtn;

        let tmpBtnRight = UIButton.init(type: .custom)
        tmpBtnRight.setImage(UIImage.init(named: "ok_icon"), for: .normal)
        tmpBtnRight .addTarget(self, action: #selector(rightBarbuttonClick(sender:)), for: .touchUpInside)
        tmpBtnRight.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        tmpBtnRight.imageEdgeInsets = UIEdgeInsets.init(top: 12, left: 12, bottom: 12, right: 12)
        rightBtn = UIBarButtonItem.init(customView: tmpBtnRight)
        self.navigationItem.rightBarButtonItem = rightBtn;

        
    }
    
    func configCell(cell:TodoCell,indexPath:IndexPath) {
        guard let aState = controllerState else { return  }
        let todo = aState.todos[indexPath.row]

        cell.isEdit = todo.isEdit
        cell.textLabel?.text = todo.contents ?? "noval"
        cell.textEdit?.text = ""
        
        cell.textDidChangeClosure = { (aCell:TodoCell,textField:UITextField) -> () in
            print("text:\(textField)")
            print("\n\n\(aCell)\n\n")
        }
        
        cell.actionBtnPressedClosure = { (aCell:TodoCell,sender:UIButton,isDone:Bool) -> () in
            //
            print("cell:\(aCell)")
            print("\n\(sender)\n")
            print("isEdit:\(isDone)")
            
            if (isDone)
            {
                let todo = Todo.init(id: UUID().uuidString, versions: [], contents: aCell.textEdit?.text ?? "空", state: 0, isEdit: false)
                TodoStore.default.dispatch(action: .replace(todo: todo, atIndex: 0))
                
            }
            else
            {
                TodoStore.default.dispatch(action: .delete(index: 0))
            }
            TodoStore.default.dispatch(action: .editingRowComplete(index: 0))
        }
        
    }
    
    func updateRightEnabled(enabled:Bool) {
        self.rightBtn.isEnabled = enabled
    }
    
    //MARK: event
    @objc func rightBarbuttonClick(sender:UIBarButtonItem) {
        
        
        print("right")
        let todos = controllerState?.todos
//        TodoStore.default.dispatch(action: .saveToStorage(type: .fileMgr, todos: todos!)) //tested succeed
        TodoStore.default.dispatch(action: .saveToStorage(type: .keychain, todos: todos!))
    }
    
    @objc func leftButtonClick(sender:UIBarButtonItem){
        print("yes?")
        
        let todo = Todo.init(id: UUID().uuidString, versions: [], contents: "", state: 0, isEdit: true)
        TodoStore.default.dispatch(action:.adding(todo: todo))
        TodoStore.default.dispatch(action: .editingRowComplete(index: 0))
    }
    
}


extension ViewController : UITableViewDelegate,UITableViewDataSource
{
 
    //MARK: Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select :\(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        let actionA = UITableViewRowAction.init(style: .default, title: "O") { (action, indexpath) in
            //
            TodoStore.default.dispatch(action: .editingRowComplete(index: 0))

        }
        actions.append(actionA)
        
        actions.append(UITableViewRowAction.init(style: .default, title: "X", handler: { (action, indexPath) in
            print("action:\(action)\n\nindexPath:\(indexPath)")
            TodoStore.default.dispatch(action: .delete(index: indexPath.row))
            TodoStore.default.dispatch(action: .editingRowComplete(index: 0))
        }))
        return actions;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("")
    }
    //MARK: Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var aCell:UITableViewCell? = nil
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseID) {
            aCell = cell
        }
        else
        {
            let tmpCell = TodoCell()
            aCell = tmpCell

        }
        
        configCell(cell: aCell! as! TodoCell,indexPath: indexPath)
        return aCell!
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let aState = self.controllerState else { return 0 }
        return aState.todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
}

