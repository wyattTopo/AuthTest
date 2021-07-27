//
//  NetworkRequest.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import Foundation
import AuthenticationServices

struct NetworkRequest {
  // MARK: Private Constants
  static let callbackURLScheme = "authhub"
  static let clientID = "Iv1.0a4e211ef4ed245b"
  static let clientSecret = "186b1751cb41bccc7f9d8fbcf50ca07f6485e6e7"
  
  static var signInURL: URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "github.com"
    urlComponents.path = "/login/oauth/authorize"
    urlComponents.queryItems = [URLQueryItem(name: "client_id", value: NetworkRequest.clientID)]
    return urlComponents.url
  }
  
  static var signOutURL: URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "github.com"
    urlComponents.path = "/logout"
//    urlComponents.queryItems = [URLQueryItem(name: "client_id", value: NetworkRequest.clientID)]
    return urlComponents.url
  }
  
  static func signInSession(completion: @escaping ASWebAuthenticationSession.CompletionHandler) -> ASWebAuthenticationSession? {
    guard let signInURL = signInURL else { return nil }
    return ASWebAuthenticationSession(url: signInURL,
                                      callbackURLScheme: callbackURLScheme,
                                      completionHandler: completion)
  }
  
  static func signOutSafari(completion: @escaping (Bool) -> Void) {
    guard let signOutURL = signOutURL else { return }
    UIApplication.shared.open(signOutURL, options: [:], completionHandler: completion)
  }
}
