//
//  BaseView.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        initTarget()
        initSubviews()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {}
    func initTarget() {}
    func initSubviews() {}
    func initConstraints() {}
}
