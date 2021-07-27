//
//  HomeViewModel.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import SwiftUI
import AuthenticationServices

class HomeViewModel: NSObject, ObservableObject, HomeViewDelegate {
  @Published var doShowLoggedIn = false
  
  func handleSignInTap() {
    let authSession = NetworkRequest.signInSession { [weak self] (url, error) in
      guard let self = self,
            error == nil,
            let callbackURL = url,
            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems,
            let code = queryItems.first(where: { $0.name == "code" })?.value
      else { return }
      NetworkRequest
        .codeExchange(code: code)
        .startGet(responseType: CodeResponse.self) { result in
          switch result {
          case .success((_, let codeResponse)):
            NetworkRequest.accessToken = codeResponse.accessToken
            NetworkRequest.refreshToken = codeResponse.refreshToken
            self.getUser()
          case .failure(let error):
            print(error)
          }
        }
    }
    authSession?.presentationContextProvider = self
    
    guard authSession != nil,
          authSession!.start() else {
      print("Failed to start")
      return
    }
  }
  
  private func getUser() {
    NetworkRequest
      .getUser
      .startGet(responseType: User.self) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success((_, let user)):
          NetworkRequest.username = user.login
          DispatchQueue.main.async {
            self.doShowLoggedIn = true
          }
        case .failure(let error):
          print(error)
        }
      }
  }

}

extension HomeViewModel: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    return window ?? ASPresentationAnchor()
  }
}
