//
//  AlamofireApiService.swift
//  Inspection
//
//  Created by Piyush Sinroja on 14/06/24.
//

import UIKit
import Reachability
import Alamofire

//typealias AFResultSuccess<T> = (_ response: T) -> Void
//typealias AFResultFail = (_ failResponseDic: [String: Any], _ error: Error?) -> Void
typealias AFResultHandler<T> = (Result<T?, Error>) -> Void

enum ApiResponseErrorEnum {
    ///
    static let errorRequestTimeout = NSError(domain: "", code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: Constant.Common.strReqTimeOut])
    ///
    static let errorNoInternet = NSError(domain: "", code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: Constant.Common.internetAlertMsg])
    ///
    static let errorSomethingwentwrong = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: Constant.Common.somethingWrong])
}

/// Alamofire api service class to call webservices
final class AlamofireApiService: NSObject {

    // MARK: - Variables

    //
    var isInternetAvailable: Bool = true
    ///
    fileprivate var reachability: Reachability?
    ///
    private let session: Session
    /// request time out seconds
    private static let timeoutIntervalForRequest = 30.0
    /// Time Interval in second for resource time out
    private static let timeoutIntervalForResource = 30.0
    ///
    private static let sharedApiService: AlamofireApiService = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AlamofireApiService.timeoutIntervalForResource
        configuration.timeoutIntervalForResource = AlamofireApiService.timeoutIntervalForResource
        let session = Alamofire.Session(configuration: configuration)
        return AlamofireApiService(session: session)
    }()

    class func shared() -> AlamofireApiService {
        return sharedApiService
    }

    // MARK: - Init
    private init(session: Session) {
        self.session = session
        super.init()
        do {
            reachability = try Reachability.init()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability?.startNotifier()
        } catch let error {
            Logger.log("Unable to start reachability notifier: \(error.localizedDescription)")
        }
    }

    // MARK: - Request Methods

    /// requestFor API Calling methods. We can call any rest API With this common API calling method.
    /// - Parameters:
    ///   - modelType: model type
    ///   - apiType: ApiTypeConfiguration
    ///   - param: parameter dictionary
    ///   - completion: generic success or fail completion handler
    func requestFor<T: Codable>(modelType: T.Type, apiType: ApiTypeConfiguration, param: Parameters? = nil, completion: @escaping AFResultHandler<T>) {
        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200]))
        AlamofireApiService.sharedApiService.session.request(apiType.apiUrlStr, method: apiType.httpMethod, parameters: param, encoding: apiType.encoding, headers: apiType.headers)
            .validate()
            .response(responseSerializer: serializer) { response in
                switch response.result {
                case .success(let data):
                    if data.isEmpty {
                        let decodable = EmptyEntity.emptyValue()
                        completion(.success(decodable as? T))
                    } else {
                        do {
                            let userResponse = try JSONDecoder().decode(modelType, from: data)
                            completion(.success(userResponse))
                        } catch {
                            let resError = self.getError(encodingError: nil)
                            completion(.failure(resError))
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print(error._code)
                    self.alamofireApiResponseErrorPrint(error: error)
                    let resError = self.getError(encodingError: error.underlyingError) // underlyingError convert AFError to Error
                    completion(.failure(resError))
                }
            }
    }
    
    /// async request API Calling methods. We can call any rest API With this common API calling method.
    /// - Parameters:
    ///   - modelType: model type
    ///   - apiType: ApiTypeConfiguration
    ///   - param: parameter dictionary
    /// - Returns: generic success or fail
    func asyncRequestFor<T: Codable>(modelType: T.Type, apiType: ApiTypeConfiguration, param: Parameters? = nil) async throws -> T {
        try await withUnsafeThrowingContinuation { continuation in
            AlamofireApiService.sharedApiService.session.request(apiType.apiUrlStr, method: apiType.httpMethod, parameters: param, encoding: JSONEncoding.default, headers: apiType.headers).validate().responseData { response in
                switch response.result {
                    case .success(let data):
                        do {
                            let userResponse = try JSONDecoder().decode(modelType, from: data)
                            continuation.resume(returning: userResponse)
                        } catch {
                            let resError = self.getError(encodingError: nil)
                            continuation.resume(throwing: resError)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        print(error._code)
                        self.alamofireApiResponseErrorPrint(error: error)
                        let resError = self.getError(encodingError: error.underlyingError) // underlyingError convert AFError to Error
                        continuation.resume(throwing: resError)
                }
            }
        }
    }

   
    // MARK: - Helper Methods

    ///
    private func createBodyWithParameters(parameters: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return jsonData
        } catch let error as NSError {
            print(error)
            return nil
        }
    }

    // MARK: - Cancel All Task
    func cancelAllTask() {
      AlamofireApiService.sharedApiService.session.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
        dataTasks.forEach { $0.cancel() }
        uploadTasks.forEach { $0.cancel() }
        downloadTasks.forEach { $0.cancel() }
      })
    }

    // MARK: - Fail Response

    /// get Error
    /// - Parameter encodingError: A type representing an error value that can be thrown.
    /// - Returns: A type representing an error value that can be thrown.
    func getError(encodingError: Error?) -> Error {
        if encodingError?.errorCode == NSURLErrorTimedOut {
            return ApiResponseErrorEnum.errorRequestTimeout
        } else if encodingError?.errorCode == NSURLErrorNotConnectedToInternet || encodingError?.errorCode == 404 {
            return ApiResponseErrorEnum.errorNoInternet
        } else if let encodingError {
            return encodingError
        } else {
            return ApiResponseErrorEnum.errorSomethingwentwrong
        }
    }

    /// alamofire api response error
    /// - Parameter error: AFError is the error type returned by Alamofire. It encompasses a few different types of errors, each with their own associated reasons.
    func alamofireApiResponseErrorPrint(error: AFError) {
        switch error {
            case .createUploadableFailed(let error):
                debugPrint("Create Uploadable Failed, description: \(error.localizedDescription)")
            case .createURLRequestFailed(let error):
                debugPrint("Create URL Request Failed, description: \(error.localizedDescription)")
            case .downloadedFileMoveFailed(let error, let source, let destination):
                debugPrint("Downloaded File Move Failed, description: \(error.localizedDescription)")
                debugPrint("Source: \(source), Destination: \(destination)")
            case .explicitlyCancelled:
                debugPrint("Explicitly Cancelled - \(error.localizedDescription)")
            case .invalidURL(let url):
                debugPrint("Invalid URL: \(url) - \(error.localizedDescription)")
            case .multipartEncodingFailed(let reason):
                debugPrint("Multipart encoding failed, description: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
            case .parameterEncodingFailed(let reason):
                debugPrint("Parameter encoding failed, description: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
            case .parameterEncoderFailed(let reason):
                debugPrint("Parameter Encoder Failed, description: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
            case .requestAdaptationFailed(let error):
                debugPrint("Request Adaptation Failed, description: \(error.localizedDescription)")
            case .requestRetryFailed(let retryError, let originalError):
                debugPrint("Request Retry Failed")
                debugPrint("Original error description: \(originalError.localizedDescription)")
                debugPrint("Retry error description: \(retryError.localizedDescription)")
            case .responseValidationFailed(let reason):
                debugPrint("Response validation failed, description: \(error.localizedDescription)")
                switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        debugPrint("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        debugPrint("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        debugPrint("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        debugPrint("Response status code was unacceptable: \(code)")
                    default: break
                }
            case .responseSerializationFailed(let reason):
                debugPrint("Response serialization failed: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
            case .serverTrustEvaluationFailed(let reason):
                debugPrint("Server Trust Evaluation Failed, description: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
            case .sessionDeinitialized:
                debugPrint("Session Deinitialized, description: \(error.localizedDescription)")
            case .sessionInvalidated(let error):
                debugPrint("Session Invalidated, description: \(error?.localizedDescription ?? "")")
            case .sessionTaskFailed(let error):
                debugPrint("Session Task Failed, description: \(error.localizedDescription)")
            case .urlRequestValidationFailed(let reason):
                debugPrint("Url Request Validation Failed, description: \(error.localizedDescription)")
                debugPrint("Failure Reason: \(reason)")
        }
    }
}

// MARK: - Rechability
extension AlamofireApiService {
    /// reachabilityChanged
    @objc func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
                case .wifi, .cellular:
                    Logger.log(".wifi, .cellular")
                    AlamofireApiService.sharedApiService.isInternetAvailable = true
                    Logger.log("Reachable via WiFi or Cellular")
                case .none:
                    Logger.log("none")
                    AlamofireApiService.sharedApiService.isInternetAvailable = false
                    Logger.log("Network not reachable")
                case .unavailable:
                    Logger.log("unavailable")
                    AlamofireApiService.sharedApiService.isInternetAvailable = false
            }
        } else {
            Logger.log("no reachability")
            AlamofireApiService.sharedApiService.isInternetAvailable = false
        }
    }
}

extension Error {
    var errorCode: Int? {
        return (self as NSError).code
    }
}

struct EmptyEntity: Codable, EmptyResponse {
    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}
