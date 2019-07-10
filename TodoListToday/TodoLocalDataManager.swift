//
//  TodoLocalDataManager.swift
//  TodoListDemo
//
//  Created by Ganjiuhui on 2019/7/8.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import UIKit
import SwiftyJSON
import KeychainAccess
                          
public let kAPPGroupID = "6F5SM484R5.group.TodoListDemo.com"
//public let kAPPGroupID = "TodoListDemo.com"

public let kAPPSyncDataPath = "Document/Cache"
public let kAPPSyncDataFileName = "cache.data"
public let kAPPSyncDataUserDefaultsKey = "kAPPSyncDataUserDefaultsKey"
public let kAPPSyncDataKeychainServiceKey = "kAPPSyncDataKeychainServiceKey"
public let kAPPSyncDataKeychainPasswordKey = "kAPPSyncDataKeychainPasswordKey"



public class TodoLocalDataManager: NSObject {
    static let shared:TodoLocalDataManager = TodoLocalDataManager()
    
    enum TodoLocalDataStoreType {
        case fileMgr
        case keychain
        case userDefaults
    }
    
    
    private override init() {
        
    }
    
    func configMgr() {
        
    }
    
    
    func fetchData(type:TodoLocalDataStoreType) -> [Todo] {
        var rt = [Todo]()
        switch type {
        case .fileMgr:
            //
            print("fetchData-fileMgr")
            guard let file = cacheDataFileURL() else { return rt}
            print("file:\t\(file)")
            var data = Data()
            do {
                try data = Data(contentsOf: file)
                let jsonObj = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                rt = parseData(data: jsonObj as? Data)
            }
            catch (let error){
                print("error:\t\(error)")
                return rt
            }
        case .userDefaults:
            print("fetchData-userDefaults")
            guard let jsonObj = cachedUserDefault().object(forKey: kAPPSyncDataUserDefaultsKey) else { return rt }
            rt = parseData(data: jsonObj as? Data)
        case .keychain:
            print("fetchData-keychain")
            let keychain = Keychain.init(service: kAPPSyncDataKeychainServiceKey, accessGroup: kAPPGroupID)
            do{
                let data = try keychain.getData(kAPPSyncDataKeychainPasswordKey)
                rt = parseData(data: data)
            }
            catch{
                print("error:\(error)")
            }
        }
        return rt
        
    }
    
    func storeData(type:TodoLocalDataStoreType,with data:[Todo]) -> Bool {
        var rt = false
    
        switch type {
        case .fileMgr:
            print("storeData-fileMgr")
            guard let file = cacheDataFileURL() else { return rt}
            let storeData = try! JSONSerialization.data(withJSONObject: dictArrayWithModelArray(data: data), options: JSONSerialization.WritingOptions.prettyPrinted)
            do {
                try storeData.write(to: file, options: Data.WritingOptions.atomic)
                rt = true
                
            }
            catch{
                rt = false
            }
        case .userDefaults:
            print("storeData-userDefaults")
            let storeData = try! JSONSerialization.data(withJSONObject: dictArrayWithModelArray(data: data), options: JSONSerialization.WritingOptions.prettyPrinted)
            
            cachedUserDefault().setValue(storeData, forKey: kAPPSyncDataUserDefaultsKey)
        case .keychain:
            print("storeData-keychain")
            let storeData = try! JSONSerialization.data(withJSONObject: dictArrayWithModelArray(data: data), options: JSONSerialization.WritingOptions.prettyPrinted)
            let storage = Keychain.init(service: kAPPSyncDataKeychainServiceKey, accessGroup: kAPPGroupID)
            do{
                try storage.set(storeData, key: kAPPSyncDataKeychainPasswordKey)
            }
            catch{
                print("err:%@",error)
            }

        }
        
        return rt
    }
    
    
    //MARK: - util
    
    func parseData(data:Data?) -> [Todo] {
        var rt = [Todo]()
        
        guard let rawData = data else {
            return rt
        }
        let rowData = try! JSONSerialization.jsonObject(with: rawData, options: .mutableContainers)
        let tmpArray = rowData as! [[String:Any]]
        for obj in tmpArray{
            let tmpTodo = Todo.init(id: obj["id"] as? String, versions: [], contents: obj["contents"] as? String, state: 0, isEdit: false)
            rt.append(tmpTodo)
        }
        return rt
    }
    
    func dictArrayWithModelArray(data:[Todo]) -> [[String: Any]] {
        var rt = [[String: Any]]()
        
        data.forEach { (aTodo) in
            
            rt.append(aTodo.toDictionary())
        }
        return rt
    }
    
    func cachedUserDefault() -> UserDefaults {
        let ud = UserDefaults.init(suiteName: kAPPGroupID)
        return ud!
    }
    
    private func cacheDataFileURL() -> URL?{
        let fm = FileManager.default
        guard var file = fm.containerURL(forSecurityApplicationGroupIdentifier: kAPPGroupID) else {
            print("No valid file url")
            return nil
            
        }
        file.appendPathComponent(kAPPSyncDataPath)
        file.appendPathComponent(kAPPSyncDataFileName)
        print("file:\t\(file)")
        return file
    }
    
    
    // 1.fileMgr
    
    
    
    
    
}
