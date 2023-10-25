//
//  HomeCVCell.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit

final class HomeCVCell: UICollectionViewCell {
    
    static let identifier = "HomeCVCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        addSubview(imageView)
    }
    
    func initConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(10)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right).offset(-10)
            make.bottom.equalTo(snp.bottom)
        }
    }
}
