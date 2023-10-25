//
//  HomeViewModel.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import Foundation
import Moya
import RxSwift
import RxRelay

final class HomeViewModel {
    var searchDatas = BehaviorRelay<[Document]>(value: [])
    var count = 1
    var isEnabledPaging = true {
        didSet {
            print("바뀌이이잉ㅁ \(isEnabledPaging)")
        }
    }
    var isEnd = false
    let disposeBag = DisposeBag()
    
    func requestSearchDataRx(query: String) {
        requestSearchData(query: query)
            .map { response in
                
                let result = try? response.map(SearchModel.self)
                if let isEnd = result?.meta.isEnd {
                    self.isEnd = isEnd
                }
                
                return result?.documents ?? []
            }
            .map { documents in
                var newData: [Document] = self.isEnabledPaging ? [] : self.searchDatas.value
                newData.append(contentsOf: documents)
                return newData
            }
            .take(1)
            .bind(to: searchDatas)
            .disposed(by: disposeBag)
    }
    
    func clearPageInfo() {
        print("clear..")
        self.count = 1
        self.isEnabledPaging = true
        self.isEnd = false
    }
    
    private func requestSearchData(query: String) -> Observable<Response> {
        return Observable.create() { emitter in
            let provider = MoyaProvider<SearchAPI>()
            
            provider.request(.searchImage(query: query,
                                          page: self.count,
                                          size: 20)) { result in
                switch result {
                case let .success(response):
                    emitter.onNext(response)
                    emitter.onCompleted()
                    
                case let .failure(error):
                    emitter.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
