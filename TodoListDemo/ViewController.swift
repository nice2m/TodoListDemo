//
//  ViewController.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/6/27.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    lazy var table:UITableView = UITableView.init(frame: .zero, style: .grouped)
    lazy var rightBtn:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightBarbuttonClick(sender:)))
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
    }

    //MARK: Private
    
    func configObserver(){
        
        let _ = TodoStore.default.subscribe { [weak self](oldState, newState) in
            self?.controllerState = newState
        }
        TodoStore.default.dispatch(event: .editingRowComplete(index: 0))
        
    }
    
    func configSubview() {
        
        title = "TodoList"
        table.delegate = self
        table.dataSource = self
        
        view .addSubview(table)
        edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.navigationItem.rightBarButtonItem = rightBtn;
        
        table.contentInsetAdjustmentBehavior = .never
        table.frame = CGRect.init(x: 0, y: 0, width:TodoGlobal.screenWidth, height: TodoGlobal.screenHeight - TodoGlobal.barHeight)
        table.register(TodoCell.self, forCellReuseIdentifier: cellReuseID)
        
    }
    
    /*
     
     func updateViews(state: State, previousState: State?)
     
     
     func reduce<Result>(_ initialResult: Result,
     _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
     
     
     
     func reducer(state: State, userAction: Action) -> (State, Command?)
     
     */
    
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
                TodoStore.default.dispatch(event: .replace(todo: todo, atIndex: 0))
                
            }
            else
            {
                TodoStore.default.dispatch(event: .delete(index: 0))
            }
            TodoStore.default.dispatch(event: .editingRowComplete(index: 0))
        }
        
    }
    
    func updateRightEnabled(enabled:Bool) {
        self.rightBtn.isEnabled = enabled
    }
    
    //MARK: event
    @objc func rightBarbuttonClick(sender:UIBarButtonItem) {
        print("yes?")
        
        let todo = Todo.init(id: UUID().uuidString, versions: [], contents: "", state: 0, isEdit: true)
        TodoStore.default.dispatch(event:.adding(todo: todo))
        TodoStore.default.dispatch(event: .editingRowComplete(index: 0))
        
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
            TodoStore.default.dispatch(event: .editingRowComplete(index: 0))

        }
        actions.append(actionA)
        
        actions.append(UITableViewRowAction.init(style: .default, title: "X", handler: { (action, indexPath) in
            print("action:\(action)\n\nindexPath:\(indexPath)")
            TodoStore.default.dispatch(event: .delete(index: indexPath.row))
            TodoStore.default.dispatch(event: .editingRowComplete(index: 0))
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

