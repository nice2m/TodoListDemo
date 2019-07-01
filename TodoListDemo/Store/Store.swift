//
//  Store.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/6/27.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import Foundation

/*
 
 func updateViews(state: State, previousState: State?)
 
 func reduce<Result>(_ initialResult: Result,
 _ nextPartialResult: (Result, Element) throws -> Result) rethrows -> Result
 
 func reducer(state: State, userAction: Action) -> (State, Command?)
 
 */

typealias TodoObserver = (_ odlState:ViewControllerState?,_ newState:ViewControllerState) -> Void

class TodoStore {
    
    public static var `default` = TodoStore()
    
    var state:ViewControllerState!
    var dispatchTable:[String:TodoObserver] = [:]
    
    var todos = [Todo]()
    
    init() {
        
        var tmpTodo = [Todo]()
        for i in 0..<3 {
            tmpTodo.append(Todo.init(id: "\(i)", versions: [], contents: "Initial-\(i)", state: 0, isEdit: false))
        }
        todos = tmpTodo
        self.state = ViewControllerState.init(todos: todos, isLoading: false, isEditing: false, title: "TodoList")

    }
    
    func dispatch(event:TodoEvent){
        let oldState = self.state
        self.state = ViewControllerState.reduce(state: oldState!, event: event)
        _publish(oldState: oldState!, state: self.state)
    }
    
    func subscribe(_ observer:@escaping TodoObserver) -> String {
        
        let uid = UUID.init().uuidString
        
        self.dispatchTable[uid] = observer;
        
        return uid
    }
    
    
    func _publish(oldState:ViewControllerState,state:ViewControllerState) {
        
        self.dispatchTable.values.forEach { (observer) in
            observer(oldState,state)
        }
    }
    
}
