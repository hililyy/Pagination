//
//  SearchAPI.swift
//  Pagination
//
//  Created by 강조은 on 2023/10/23.
//

import Foundation
import Moya

enum SearchAPI {
    case searchImage(query: String, page: Int, size: Int)
}

extension SearchAPI: TargetType {
    var baseURL: URL {
        URL(string: "https://dapi.kakao.com")!
    }
    
    var path: String {
        switch self {
        case .searchImage(_, _, _):
            return "/v2/search/image"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchImage(_, _, _):
            return .get
        }
    }
    
    var task: Moya.Task {
            switch self {
            case .searchImage(let query, let page, let size):
                let params: [String: Any] = [
                    "query": query,
                    "page": page,
                    "size": size
                ]
                return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            }
        }
    
    var headers: [String : String]? {
        return ["Authorization": "KakaoAK 42639d338c45ec5c55f2166674361974"]
    }
}
