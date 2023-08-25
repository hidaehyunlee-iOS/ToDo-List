//
//  TaskDataManager.swift
//  TodoList
//
//  Created by daelee on 2023/08/25.
//

import Foundation

class TaskDataManager {
    // 할 일 목록(tasks)에 대한 UserDefaults 인터페이스
    func saveAllData() {
        let data = tasks.map {
            [
                "text": $0.text,
                "isDone": $0.isDone,
                "category": $0.category
            ] as [String : Any]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        
        tasks = data.map {
            let text = $0["text"] as? String
            let isDone = $0["isDone"] as? Bool
            let category = $0["category"] as? String
            
            return TaskData(text: text!, isDone: isDone!, category: category!)
        }
    }
    
    // 완료 목록(doneTasks)에 대한 UserDefaults 인터페이스
    func saveCompletedData() {
        let data = doneTasks.map {
            [
                "text": $0.text,
                "isDone": $0.isDone,
                "category": $0.category
            ] as [String : Any]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "completedItems")
        userDefaults.synchronize()
    }
    
    func loadCompletedData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "completedItems") as? [[String: AnyObject]] else {
            return
        }
                
        doneTasks = data.map {
            let text = $0["text"] as? String
            let isDone = $0["isDone"] as? Bool
            let category = $0["category"] as? String

            return TaskData(text: text!, isDone: isDone!, category: category!)
        }
    }
}
