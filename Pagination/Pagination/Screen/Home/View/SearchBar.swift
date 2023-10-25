//
//  SearchBar.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit
import SnapKit

final class SearchBar: BaseView {
    
    let textfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "검색어를 입력하세요"
        textField.backgroundColor = UIColor(named: "EEEEEE")
        textField.textColor = UIColor(named: "999999")
        textField.layer.cornerRadius = 16
        return textField
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_search"), for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_back"), for: .normal)
        return button
    }()
    
    
    override func initSubviews() {
        addSubviews([textfield, 
                     searchButton,
                     backButton])
    }
    
    override func initConstraints() {
        backButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.left.equalTo(24)
            make.centerY.equalTo(snp.centerY)
        }
        
        textfield.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(searchButton.snp.left).offset(-10)
            make.height.equalTo(40)
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.right.equalTo(-24)
            make.centerY.equalTo(snp.centerY)
        }
    }
    
}

