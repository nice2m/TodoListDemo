//
//  Structs.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/6/27.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import Foundation

enum TodoState: Int {
    case notInitialized
    case quit
    case delayed
}

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
    
    
    static func saveToLocal(data:[Todo],type:TodoLocalDataManager.TodoLocalDataStoreType) -> Bool {
        return TodoLocalDataManager.shared.storeData(type: type, with: data)
    }
    
}

// viewController state

public struct ViewControllerState {
    
    var todos:[Todo] = [Todo]()
    var isLoading:Bool = false
    var isEditing:Bool = false
    var title:String = "TodoList"
    
    
    // 分发任务，操作，生成新的state,纯函数回调
    
    static func reduce(state:ViewControllerState,action:ViewControllerAction) -> ViewControllerState {
        var isEditing = false
        let isLoading = false
        
        switch action {
        case .delete(let index):
            TodoStore.default.todos.remove(at: index)
        case .replace(let todo, let atIndex):
            let aRange = Range.init(NSRange.init(location: atIndex, length: 1))
            TodoStore.default.todos.replaceSubrange(aRange!, with: [todo])
        case .adding(let todo):
            TodoStore.default.todos.insert(todo, at: 0)
            isEditing = true
        case .editingRowComplete(_):
            print("")
        case .saveToStorage(let type, let todos):
            let rt = Todo.saveToLocal(data: todos, type: type)
            print("type:saveToStorage result:\(rt)")
        }
        
        return ViewControllerState.init(todos: TodoStore.default.todos, isLoading: isLoading, isEditing: isEditing, title: "TodoList-\(TodoStore.default.todos.count)")
    }
    
}

enum ViewControllerAction {
    case delete(index:Int)
    case replace(todo:Todo ,atIndex:Int)
    case adding(todo:Todo)
    case editingRowComplete(index:Int)
    case saveToStorage(type:TodoLocalDataManager.TodoLocalDataStoreType,todos:[Todo])
    
}



