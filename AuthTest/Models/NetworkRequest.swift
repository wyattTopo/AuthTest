//
//  NetworkRequest.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import Foundation
import AuthenticationServices

enum NetworkRequest {
  case signIn
  case signOut
  case codeExchange(code: String)
  case getUser
  case getRepos
  
  // MARK: Private Constants
  static let callbackURLScheme = "authhub"
  static let clientID = "Iv1.0a4e211ef4ed245b"
  static let clientSecret = "186b1751cb41bccc7f9d8fbcf50ca07f6485e6e7"
  
  static var accessToken: String?
  static var refreshToken: String?
  static var username: String?

  var requestHttpMethod: String? {
    switch self {
    case .codeExchange, .getUser, .getRepos:
      return "GET"
    case .signIn, .signOut:
      return nil
    }
  }
  
  var host: String {
    switch self {
    case .signIn, .signOut, .codeExchange:
      return "github.com"
    case .getUser, .getRepos:
      return "api.github.com"
    }
  }
  
  var path: String? {
    switch self {
    case .signIn:
      return "/login/oauth/authorize"
    case .signOut:
      return "/logout"
    case .codeExchange:
      return  "/login/oauth/access_token"
    case .getUser:
      return "/user"
    case .getRepos:
      guard let username = NetworkRequest.username else { return nil }
      return "/users/\(username)/repos"
    }
  }
  
  var queryItems: [URLQueryItem] {
    switch self {
    case .signIn:
      return [URLQueryItem(name: "client_id", value: NetworkRequest.clientID)]
    case .codeExchange(let code):
      return [URLQueryItem(name: "client_id", value: NetworkRequest.clientID),
              URLQueryItem(name: "client_secret", value: NetworkRequest.clientSecret),
              URLQueryItem(name: "code", value: code)]
    case .signOut, .getUser, .getRepos:
      return []
    }
  }
  
  var url: URL? {
    guard let path = path else { return nil }
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = path
    urlComponents.queryItems = queryItems
    return urlComponents.url
  }
  
  static func signInSession(completion: @escaping ASWebAuthenticationSession.CompletionHandler) -> ASWebAuthenticationSession? {
    guard let signInURL = signIn.url else { return nil }
    return ASWebAuthenticationSession(url: signInURL,
                                      callbackURLScheme: callbackURLScheme,
                                      completionHandler: completion)
  }
  
  static func signOutSafari(completion: @escaping (Bool) -> Void) {
    guard let signOutURL = signOut.url else { return }
    UIApplication.shared.open(signOutURL, options: [:], completionHandler: completion)
  }
  
  enum NetworkError: Error {
    case genericError
    case invalidRequest
    case invalidResponse
  }
  
  func startGet<T: Decodable>(responseType: T.Type,
                              completionHandler: @escaping ((Result<(response: HTTPURLResponse, object: T), Error>) -> Void)) {
    guard let url = url,
          let requestHttpMethod = requestHttpMethod else {
      completionHandler(.failure(NetworkError.invalidRequest))
      return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = requestHttpMethod
    
    if let accessToken = NetworkRequest.accessToken {
      request.setValue("token \(accessToken)",
                       forHTTPHeaderField: "Authorization")
    }
    
    let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completionHandler(.failure(error!))
        return
      }
      
      guard let response = response as? HTTPURLResponse,
            let data = data else {
        completionHandler(.failure(NetworkError.invalidResponse))
        return
      }
      
      if T.self == CodeResponse.self,
         let codeResponse = NetworkRequest.parseCodeResponse(data) {
        completionHandler(.success((response, codeResponse as! T)))
      } else if let object = try? JSONDecoder().decode(responseType, from: data) {
        completionHandler(.success((response, object)))
      } else {
        completionHandler(.failure(NetworkError.genericError))
      }
    }
    
    dataTask.resume()
  }
  
  // Non-JSON parse required for GitHub auth code response
  static func parseCodeResponse(_ data: Data) -> CodeResponse? {
    guard let responseString = String(data: data, encoding: .utf8) else { return nil }
    var responseDict = [String:String]()
    let responseComponents = responseString.components(separatedBy: "&")
    let responseKeyValue = responseComponents.map{ $0.components(separatedBy: "=") }
    for pair in responseKeyValue {
      if let key = pair.first,
         let value = pair.last {
        responseDict[key] = value
      }
    }
    return CodeResponse(dict: responseDict)
  }
}
