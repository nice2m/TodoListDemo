//
//  TodayLocalDataManagerTest.swift
//  TodoListDemoTests
//
//  Created by Ganjiuhui on 2019/7/9.
//  Copyright © 2019 Ganjiuhui. All rights reserved.
//

import XCTest
@testable import TodoListDemo

class TodayLocalDataManagerTest: XCTestCase {
    let localDataMgr = TodoLocalDataManager.shared
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: save & fetch

    func testLocalDataManager_singleInstance() {
        
//        describe("the 'Documentation' directory") {
//            it("has everything you need to get started") {
//                let sections = Directory("Documentation").sections
//                expect(sections).to(contain("Organized Tests with Quick Examples and Example Groups"))
//                expect(sections).to(contain("Installing Quick"))
//            }
//
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//                    let you = You(awesome: true)
//                    expect{you.submittedAnIssue}.toEventually(beTruthy())
//                }
//            }
//        }
    }
    
    func testLocalDataManager_keyChainFetchAndStore() {
        let tmpData = generateTestData()
        let storeRt = localDataMgr.storeData(type: .keychain, with: tmpData)
        assert(storeRt, "keychain 写入 data 失败")
        
        let fetchData = localDataMgr.fetchData(type: .keychain)
        
        for i in 0..<tmpData.count
        {
            describe("比对存入数据是否与写入数据一致") {
                expect(tmpData[i].id).to(equal(fetchData[i].id))
            }
        }
    }
    
    func testLocalDataManager_fileManagerFetchAndStore() {
        
        let tmpData = generateTestData()
        let storeRt = localDataMgr.storeData(type: .fileMgr, with: tmpData)
        assert(storeRt, "fileMgr 写入 data 失败")
        let fetchData = localDataMgr.fetchData(type: .fileMgr)

        for i in 0..<tmpData.count
        {
            describe("比对存入数据是否与写入数据一致") {
                expect(tmpData[i].id).to(equal(fetchData[i].id))
            }
        }
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
//            describe("比对存入数据是否与写入数据一致") {
//                expect(tmpData[i].id).to(equal(fetchData[i].id))
//            }
//        }
//    }

    
    //MARK: - singleInstanceTest
    
    //MARK: - helper
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

}
import Quick
import Nimble

class TableOfContentsSpec: QuickSpec {
    
    override func spec() {
        
        
//        describe("the 'Documentation' directory") {
//            it("has everything you need to get started") {
//                let sections = Directory("Documentation").sections
//                expect(sections).to(contain("Organized Tests with Quick Examples and Example Groups"))
//                expect(sections).to(contain("Installing Quick"))
//            }
//
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//                    let you = You(awesome: true)
//                    expect{you.submittedAnIssue}.toEventually(beTruthy())
//                }
//            }
//        }
    }
}
