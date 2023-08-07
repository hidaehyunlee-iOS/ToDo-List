//
//  ViewController.swift
//  TodoList
//
//  Created by daelee on 2023/08/02.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func DoneButton(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TodoCompleteViewController") {
            // 옵셔널 바인딩을 통해 Navi를 찾은 후 push
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

