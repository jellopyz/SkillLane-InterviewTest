//
//  MainViewController.swift
//  SkillLaneTest
//
//  Created by Thanakorn Amnajsatit on 28/1/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.viewModel.fetchData()
    }
}

extension MainViewController {
    func bindViewModel() {
        self.viewModel.onSuccessFetchData = { [unowned self] in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let displayScreenVC = storyboard.instantiateViewController(identifier: "DisplayScreenVC") as! DisplayScreenViewController
            displayScreenVC.modalPresentationStyle = .fullScreen
            displayScreenVC.viewModel = DisplayScreenViewModel()
            displayScreenVC.viewModel!.photoBookList = self.viewModel.photoBookList
            
            self.present(displayScreenVC, animated: true, completion: nil)
        }
    }
}
