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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadAllData()
        loadCompletedData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func addButtom(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "할 일 추가"
        
        //                vc.didAddHandler = { [weak self] in
        //                    self?.loadAllData()
        //                    self?.tableView.reloadData()
        //                }
        
        navigationController?.pushViewController(vc, animated: true)
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
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var taskToShow: TaskData
        
        if segmentedControl.selectedSegmentIndex == 0 {
            taskToShow = tasks[indexPath.row]
            
            let dialog = UIAlertController(title: "\(taskToShow.text)", message: "🎉 할 일을 완료했습니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            dialog.addAction(action)
            
            taskToShow.isDone = true
            
            if taskToShow.isDone {
                self.present(dialog, animated: true, completion: nil)
                doneTasks.append(taskToShow)
                tasks.remove(at: indexPath.row)
            }
        } else {
            taskToShow = doneTasks[indexPath.row]
            taskToShow.isDone = false
            
            tasks.append(taskToShow)
            doneTasks.remove(at: indexPath.row)
        }
        
        tableView.reloadData()
        saveAllData()
        saveCompletedData()
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segmentedControl.selectedSegmentIndex == 0 ? tasks.count : doneTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let taskToShow = segmentedControl.selectedSegmentIndex == 0 ? tasks[indexPath.row] : doneTasks[indexPath.row]
        
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
                
                saveAllData()
                saveCompletedData()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    }
    
}

extension TodoListViewController {
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
