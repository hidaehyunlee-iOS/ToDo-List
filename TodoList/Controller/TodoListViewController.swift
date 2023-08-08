//
//  TodoListViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/02.
//

import Foundation
import UIKit

var tasks = [TaskData]()

class TodoListViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButtom(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        
        vc.title = "할 일 추가"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Segmented Control의 값 변경 시 호출되는 메서드
    @IBAction func segmentValueChaned(_ sender: UISegmentedControl) {
        tableView.reloadData() // 선택한 Segment에 따라 테이블 뷰 데이터를 다시 로드
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadAllData()
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
        let dialog = UIAlertController(title: "🎉", message: "할 일을 완료했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        dialog.addAction(action)
        
        tasks[indexPath.row].isDone.toggle() // 체크마크 상태 토글
        
        if tasks[indexPath.row].isDone {
            self.present(dialog, animated: true, completion: nil)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            // 할 일 목록 Segment 선택 시, 전체 데이터 수 반환 x -> false이
            return tasks.count
        } else {
            // 완료 목록 Segment 선택 시, 체크마크가 된 데이터 수 반환
            return tasks.filter { $0.isDone }.count
        }
    }
    
    func tableView(_ tableView  : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var tasksToShow: TaskData

        if segmentedControl.selectedSegmentIndex == 0 {
            // 전체 데이터 사용
            tasksToShow = tasks[indexPath.row]
        } else {
            // 체크마크가 된 데이터만 사용
            tasksToShow = tasks.filter { $0.isDone }[indexPath.row]
        }
        
        cell.textLabel?.text = tasksToShow.text
        if tasksToShow.isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: "확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                tasks.remove(at: indexPath.row)
                
                // 변경 사항을 User Defaults에 반영
                self.saveAllData()
                
                // 테이블 뷰의 행 수를 업데이트
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {}
    }
}
