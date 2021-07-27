//
//  CodeResponse.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import Foundation

struct CodeResponse: Decodable {
  var accessToken: String
  var refreshToken: String
  
  enum Namespace: String {
    case access = "access_token"
    case refresh = "refresh_token"
  }
  
  init?(dict: [String:String]) {
    guard let access = dict[Namespace.access.rawValue],
          let refresh = dict[Namespace.refresh.rawValue]
    else { return nil }
    self.accessToken = access
    self.refreshToken = refresh
  }
}
