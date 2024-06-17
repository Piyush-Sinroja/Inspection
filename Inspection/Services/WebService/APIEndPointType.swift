//
//  APIEndPointType.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation
import Alamofire

protocol APIEndPointType {
    
    // MARK: - Variables

    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var apiUrlStr: String { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
}

enum ApiTypeConfiguration {
    case login
    case register
    case getInspection
    case submitInspection
}
