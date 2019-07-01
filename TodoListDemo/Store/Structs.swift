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
}

// viewController state

public struct ViewControllerState {
    
    var todos:[Todo] = [Todo]()
    var isLoading:Bool = false
    var isEditing:Bool = false
    var title:String = "TodoList"
    
    
    // 分发任务，操作，生成新的state,纯函数回调
    
    static func reduce(state:ViewControllerState,event:TodoEvent) -> ViewControllerState {
        var isEditing = false
        let isLoading = false
        
        switch event {
        case .delete(let index):
            TodoStore.default.todos.remove(at: index)
        case .replace(let todo, let atIndex):
            let aRange = Range.init(NSRange.init(location: atIndex, length: 1))
            TodoStore.default.todos.replaceSubrange(aRange!, with: [todo])
        case .adding(let todo):
            TodoStore.default.todos.insert(todo, at: 0)
            isEditing = true
        case .editingRowComplete(_):
            isEditing = false
        }
        
        return ViewControllerState.init(todos: TodoStore.default.todos, isLoading: isLoading, isEditing: isEditing, title: "TodoList-\(TodoStore.default.todos.count)")
    }
}

enum TodoEvent {
    case delete(index:Int)
    case replace(todo:Todo ,atIndex:Int)
    case adding(todo:Todo)
    case editingRowComplete(index:Int)
    
}



