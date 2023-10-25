//
//  HomeView.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit
import SnapKit

class HomeView: BaseView {
    let searchBar = SearchBar()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
                
                layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCVCell.self, forCellWithReuseIdentifier: HomeCVCell.identifier)
        return collectionView
    }()
    
    override func initUI() {
        backgroundColor = .white
    }
    
    override func initSubviews() {
        addSubviews([searchBar, collectionView])
        
    }
    
    override func initConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.equalTo(snp.left).offset(10)
            make.right.equalTo(snp.right).offset(-10)
            make.bottom.equalTo(snp.bottom)
        }
    }
}
