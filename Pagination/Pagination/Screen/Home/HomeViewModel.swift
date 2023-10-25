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
    var searchDatas: [Document] = []
    var count = 1
    var isEnabledPaging = true
    
    func requestSearchData(query: String, 
                           completion: @escaping (SearchModel) -> ()) {
        let provider = MoyaProvider<SearchAPI>()
        
        provider.request(.searchImage(query: query, 
                                      page: count,
                                      size: 20)) { result in
            switch result {
            case let .success(response):
                let result = try? response.map(SearchModel.self)
                if let result {
                    completion(result)
                }
                
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func clearPageInfo() {
        self.count = 1
        self.isEnabledPaging = true
    }
}
