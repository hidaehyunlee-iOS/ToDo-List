//
//  TodoListViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/02.
//

import Foundation
import UIKit

var tasks = [TaskData]()
var doneTasks = [TaskData]()

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtom(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        
        vc.title = "할 일 추가"
        navigationController?.pushViewController(vc, animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadAllData()
        loadCompletedData()
    }
    
    // Segmented Control의 값 변경 시 호출되는 메서드
    @IBAction func segmentValueChaned(_ sender: UISegmentedControl) {
        tableView.reloadData() // 선택한 Segment에 따라 테이블 뷰 데이터를 다시 로드
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveAllData()
        tableView.reloadData()
    }
    
    // userdefault 저장
    func saveAllData() {
        let data = tasks.map {
            [
                "text": $0.text,
                "isDone": $0.isDone
            ] as [String : Any]
        }
        
        print(type(of: data))
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    // userDefault 데이터 불러오기
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        
        print(data.description)
        
        // tasks 배열에 저장하기
        print(type(of: data))
        tasks = data.map {
            let text = $0["text"] as? String
            let isDone = $0["isDone"] as? Bool
            
            return TaskData(text: text!, isDone: isDone!)
        }
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var taskToShow: TaskData
        
        if segmentedControl.selectedSegmentIndex == 0 {
            taskToShow = tasks[indexPath.row]
            
            let dialog = UIAlertController(title: "🎉", message: "할 일을 완료했습니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            dialog.addAction(action)
            
            taskToShow.isDone = true
            
            if taskToShow.isDone {
                self.present(dialog, animated: true, completion: nil)
                doneTasks.append(taskToShow) // Move to doneTasks
                tasks.remove(at: indexPath.row) // Remove from tasks
            }
        } else {
            taskToShow = doneTasks[indexPath.row]
            taskToShow.isDone = false
            
            tasks.append(taskToShow) // Move back to tasks
            doneTasks.remove(at: indexPath.row) // Remove from doneTasks
        }
        
        tableView.reloadData() // Reload the entire table view
        saveAllData() // Save changes to User Defaults
    }

}

extension TodoListViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                if segmentedControl.selectedSegmentIndex == 0 {
                    return tasks.count
                } else {
                    return doneTasks.count
                }
    }
    
    func tableView(_ tableView  : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
                var taskToShow: TaskData
                
                if segmentedControl.selectedSegmentIndex == 0 {
                    taskToShow = tasks[indexPath.row]
                } else {
                    taskToShow = doneTasks[indexPath.row]
                }
                
                cell.textLabel?.text = taskToShow.text
                cell.accessoryType = taskToShow.isDone ? .checkmark : .none
                
                return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [self] _ in
                if segmentedControl.selectedSegmentIndex == 0 {
                    tasks.remove(at: indexPath.row)
                } else {
                    doneTasks.remove(at: indexPath.row)
                }
                
                // 변경 사항을 User Defaults에 반영
                self.saveAllData()
                
                // 테이블 뷰의 행 수를 업데이트
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        } else if editingStyle == .insert {
            // Insertion logic, if needed
        }
    }

}

extension TodoListViewController {
    func loadCompletedData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "completedItems") as? [[String: AnyObject]] else {
            return
        }
        
        doneTasks = data.map {
            let text = $0["text"] as? String
            let isDone = $0["isDone"] as? Bool
            return TaskData(text: text!, isDone: isDone!)
        }
    }
    
    func saveCompletedData() {
        let data = doneTasks.map {
            [
                "text": $0.text,
                "isDone": $0.isDone
            ] as [String : Any]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "completedItems")
        userDefaults.synchronize()
    }
}
