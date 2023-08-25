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
    let manager: TaskDataManager = TaskDataManager()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func segmentValueChaned(_ sender: UISegmentedControl) {
        tableView.reloadData() // Segmented Control의 값 변경 시 데이터 다시 로드
    }
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .light)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfig)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = #colorLiteral(red: 0.6891200542, green: 0.6007182598, blue: 0.8024315238, alpha: 1)
        
        addButton.addTarget(self, action: #selector(self.addTasks(_:)), for: .touchUpInside)
        
        return addButton
    }()
    
    @objc internal func addTasks(_ sender: UIButton) {
        print("TodoListToEntry")
        let nextVc = storyboard?.instantiateViewController(identifier: "EntryViewController") as! EntryViewController
        nextVc.title = "✍🏻 할 일 추가"
        
        navigationController?.pushViewController(nextVc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
        manager.loadAllData()
        manager.loadCompletedData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.saveAllData()
        tableView.reloadData()
        
        configureAddButton()
        configureNavController()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40), // 오른쪽 여백 조절
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20), // 아래 여백 조절
            addButton.widthAnchor.constraint(equalToConstant: 60), // 버튼 크기 조절
            addButton.heightAnchor.constraint(equalToConstant: 60), // 버튼 크기 조절
        ])
    }
    
    private func configureNavController() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white // 뒤로가기, 저장 버튼 색 변경
        
        // 이전 뷰 컨트롤러가 UINavigationController의 최상위 뷰 컨트롤러인 경우
        if let previousViewController = navigationController?.viewControllers.last?.title {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: previousViewController, style: .plain, target: nil, action: nil)
        } else {
            // 이전 뷰 컨트롤러가 없거나 UINavigationController의 최상위 뷰 컨트롤러가 아닌 경우
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "🪶 내일배움캠프"
        } else if section == 1 {
            return "🖥️ 개인 프로젝트"
        } else if section == 2 {
            return "😸 일상"
        } else {
            return "🏝️ 여행"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var taskToShow: TaskData
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                taskToShow = tasks.filter { $0.category == "내일배움캠프" }[indexPath.row]
            } else if indexPath.section == 1 {
                taskToShow = tasks.filter { $0.category == "개인 프로젝트" }[indexPath.row]
            } else if indexPath.section == 2 {
                taskToShow = tasks.filter { $0.category == "일상" }[indexPath.row]
            } else {
                taskToShow = tasks.filter { $0.category == "여행" }[indexPath.row]
            }
        } else {
            if indexPath.section == 0 {
                taskToShow = doneTasks.filter { $0.category == "내일배움캠프" }[indexPath.row]
            } else if indexPath.section == 1 {
                taskToShow = doneTasks.filter { $0.category == "개인 프로젝트" }[indexPath.row]
            } else if indexPath.section == 2 {
                taskToShow = doneTasks.filter { $0.category == "일상" }[indexPath.row]
            } else {
                taskToShow = doneTasks.filter { $0.category == "여행" }[indexPath.row]
            }
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            taskToShow = tasks[indexPath.row]
            
            let dialog = UIAlertController(title: "\(taskToShow.text)", message: "🎉 할 일을 완료했습니다.", preferredStyle: .alert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dialog.dismiss(animated: true, completion: nil)
            }
            
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
        manager.saveAllData()
        manager.saveCompletedData()
    }
}

extension TodoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 // 4개의 카테고리
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            if section == 0 {
                return tasks.filter { $0.category == "내일배움캠프" }.count
            } else if section == 1 {
                return tasks.filter { $0.category == "개인 프로젝트" }.count
            } else if section == 2 {
                return tasks.filter { $0.category == "일상" }.count
            } else {
                return tasks.filter { $0.category == "여행" }.count
            }
        } else {
            if section == 0 {
                return doneTasks.filter { $0.category == "내일배움캠프" }.count
            } else if section == 1 {
                return doneTasks.filter { $0.category == "개인 프로젝트" }.count
            } else if section == 2 {
                return doneTasks.filter { $0.category == "일상" }.count
            } else {
                return doneTasks.filter { $0.category == "여행" }.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let taskToShow: TaskData
        
        if segmentedControl.selectedSegmentIndex == 0 {
            if indexPath.section == 0 {
                taskToShow = tasks.filter { $0.category == "내일배움캠프" }[indexPath.row]
            } else if indexPath.section == 1 {
                taskToShow = tasks.filter { $0.category == "개인 프로젝트" }[indexPath.row]
            } else if indexPath.section == 2 {
                taskToShow = tasks.filter { $0.category == "일상" }[indexPath.row]
            } else {
                taskToShow = tasks.filter { $0.category == "여행" }[indexPath.row]
            }
        } else {
            if indexPath.section == 0 {
                taskToShow = doneTasks.filter { $0.category == "내일배움캠프" }[indexPath.row]
            } else if indexPath.section == 1 {
                taskToShow = doneTasks.filter { $0.category == "개인 프로젝트" }[indexPath.row]
            } else if indexPath.section == 2 {
                taskToShow = doneTasks.filter { $0.category == "일상" }[indexPath.row]
            } else {
                taskToShow = doneTasks.filter { $0.category == "여행" }[indexPath.row]
            }
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
                
                manager.saveAllData()
                manager.saveCompletedData()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
        }
    }
}
