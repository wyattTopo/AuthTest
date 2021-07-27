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
            let callbackURL = url
      else { return }
      print("successful login with callback URL: \(callbackURL)")
      self.doShowLoggedIn = true
    }
    authSession?.presentationContextProvider = self
    
    guard authSession != nil,
          authSession!.start() else {
      print("Failed to start")
      return
    }
  }
}

extension HomeViewModel: ASWebAuthenticationPresentationContextProviding {
  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    return window ?? ASPresentationAnchor()
  }
}
