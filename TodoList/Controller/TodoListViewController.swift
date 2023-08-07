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
        
        //let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskController
        
        //vc.title = "할 일 추가"
        //vc.task = tasks[indexPath.row].text
        
        // 이미 체크되있는 경우 return
        guard !tasks[indexPath.row].isDone else {
            return
        }
        
        // 리스트 click 시 완료된 할일 표시(checkmark)
        tasks[indexPath.row].isDone = true

        let dialog = UIAlertController(title: "Todo List", message: "할 일을 완료했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        dialog.addAction(action)
        
        self.present(dialog, animated: true, completion: nil)
        
        tableView.reloadData()

       // navigationController?.pushViewController(vc, animated: true)
    }
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView  : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].text
        if tasks[indexPath.row].isDone {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {}
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//           let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
//                   tableView.deleteRows(at: [indexPath], with: .automatic)
//                completion(true)
//            }
//
//            action.backgroundColor = .white
//            action.image = #imageLiteral(resourceName: "swiftLogo.JPG")
//
//            let configuration = UISwipeActionsConfiguration(actions: [action])
//            configuration.performsFirstActionWithFullSwipe = false
//            return configuration
//       }
//
}
