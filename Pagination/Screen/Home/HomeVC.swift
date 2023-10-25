//
//  HomeVC.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class HomeVC: UIViewController {
    
    let homeView = HomeView()
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalize()
    }
    
    private func initalize() {
        homeView.collectionView.delegate = self
        homeView.searchBar.textfield.delegate = self
        
        initTarget()
    }
    
    private func initTarget() {
        homeView.searchBar.textfield.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                
                self.viewModel.clearPageInfo()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.requestApi(text: text)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.searchDatas
            .bind(to: homeView.collectionView.rx.items(cellIdentifier: HomeCVCell.identifier, cellType: HomeCVCell.self)) { index, item, cell in
                self.viewModel.isEnabledPaging = true
                
                DispatchQueue.main.async {
                    cell.imageView.setImage(urlString: item.imageURL)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func requestApi(text: String) {
        viewModel.requestSearchDataRx(query: homeView.searchBar.textfield.text ?? "")
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenItems: CGFloat = 10
        let totalSpacing = (numberOfItemsPerRow - 1) * spacingBetweenItems
        let availableWidth = homeView.collectionView.frame.width - totalSpacing
        let calculatedItemWidth = availableWidth / numberOfItemsPerRow
        
        return CGSize(width: calculatedItemWidth,
                      height: calculatedItemWidth)
    }
}

extension HomeVC : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        let isEndPosition = offsetY > (contentHeight - height)
        
        if isEndPosition && !viewModel.isEnd && viewModel.isEnabledPaging {
            let text = homeView.searchBar.textfield.text ?? ""
            viewModel.isEnabledPaging = false
            requestApi(text: text)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          view.endEditing(true)
    }
}
