//
//  HomeNC.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit

final class HomeNC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isHidden = true
        self.setViewControllers([HomeVC()], animated: true)
    }
    
}
