//
//  ApiTypeConfiguration.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import Foundation
import Alamofire

extension ApiTypeConfiguration: APIEndPointType {

    // MARK: - Vars & Lets

    var baseURL: String {
        return Constant.API.baseURL
    }
    
    var apiUrlStr: String {
        return "\(baseURL)\(path)"
    }
    
    var version: String {
        ""
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        case .getInspection:
            return "/inspections/start"
        case .submitInspection:
            return "/inspections/submit"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getInspection:
            return .get
        case .submitInspection:
            return .post
        case .register:
            return .post
        case .login:
            return .post
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var encoding: ParameterEncoding {
        switch self {
        case .getInspection:
            return JSONEncoding.default
        case .submitInspection:
            return JSONEncoding.default
        case .login:
            return JSONEncoding.default
        case .register:
            return JSONEncoding.default
//        default:
//            return URLEncoding.default
        }
    }
}

