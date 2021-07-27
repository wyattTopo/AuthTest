//
//  HomeViewModel.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import SwiftUI

class HomeViewModel: ObservableObject, HomeViewDelegate {
  @Published var doShowLoggedIn = false
  
  func handleSignInTap() {
    doShowLoggedIn = true
  }
}
