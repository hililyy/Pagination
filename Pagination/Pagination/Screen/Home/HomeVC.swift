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
        homeView.collectionView.dataSource = self
        homeView.searchBar.textfield.delegate = self
        
        initTarget()
    }
    
    private func initTarget() {
        homeView.searchBar.textfield.rx.text.orEmpty
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                
                viewModel.clearPageInfo()
                requestApiFirstStep(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestApiFirstStep(text: String) {
        viewModel.requestSearchData(query: text) { [weak self] result in
            guard let self else { return }
            
            viewModel.searchDatas = result.documents
            homeView.collectionView.reloadData()
        }
    }
    
    private func requestApiMoreStep(text: String) {
        viewModel.requestSearchData(query: text) { [weak self] result in
            guard let self else { return }
            
            viewModel.isEnabledPaging = false
            viewModel.count += 1

            self.viewModel.searchDatas.append(contentsOf: result.documents)
            DispatchQueue.main.async {
                self.homeView.collectionView.reloadData()
                self.viewModel.isEnabledPaging = !result.meta.isEnd
            }
        }
    }
}

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchDatas.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = homeView.collectionView.dequeueReusableCell(withReuseIdentifier: HomeCVCell.identifier, for: indexPath) as? HomeCVCell else { return UICollectionViewCell() }
        
        let urlString = viewModel.searchDatas[indexPath.row].imageURL
        DispatchQueue.main.async {
            cell.imageView.setImage(urlString: urlString)
        }
        
        return cell
    }
    
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
        
        if isEndPosition && viewModel.isEnabledPaging {
            let text = homeView.searchBar.textfield.text ?? ""
            requestApiMoreStep(text: text)
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          view.endEditing(true)
    }
}
