//
//  EntryViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/07.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet var field: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var selectedCategory = "내일배움캠프"
    var imgUrl = "https://github.com/hidaehyunlee-iOS/ToDo-List/assets/37580034/c9f9b452-aa54-4ee3-baa3-5dbcc45c3c76"
    // var didAddHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configPopUpButton()
        downloadImage()
    }
    
    private func configureViews() {
        field.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(entryItemToTasks))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryItemToTasks()
        return true
    }
    
    private func configPopUpButton() {
        let categoryButtonClosure = { (action: UIAction) in
            self.selectedCategory = action.title // 선택된 카테고리 저장
            print("Selected menu: \(action.title)")
        }
        
        categoryButton.menu = UIMenu(title: "카테고리", children: [
            UIAction(title: "내일배움캠프", handler: categoryButtonClosure),
            UIAction(title: "개인 프로젝트", handler: categoryButtonClosure),
            UIAction(title: "일상", handler: categoryButtonClosure),
            UIAction(title: "여행", handler: categoryButtonClosure),
        ])
        
        categoryButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func entryItemToTasks() {
        let text = field.text!
        let newTask: TaskData = TaskData(text: text, isDone: false, category: selectedCategory)
        
        print("Add Tasks title: \(newTask.text), categoty: \(newTask.category)")
        
        // TodoListViewController에 생성한 tasks 전역변수에 append
        tasks.append(newTask)
        
        // didAddHandler?()
        navigationController?.popViewController(animated: true)
    }
    
    func downloadImage() {
            guard let imageURL = URL(string: imgUrl) else {
                print("url 유효하지 않음")
                return
            }

            // URLSession 생성
            let session = URLSession.shared

            let task = session.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print(error)
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    return
                }

                // Main Thread에서 이미지 설정
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }

            // 다운로드 시작
            task.resume()
        }
}
