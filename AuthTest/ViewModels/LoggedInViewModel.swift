//
//  LoggedInViewModel.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import SwiftUI

// I have decided that using these bound values is bad practice, as though they retain a sync across view states as to the proper values,
// it introduces risk in having undesired viewModels active.

class LoggedInViewModel: ObservableObject {
  // Object reference to originating value in HomeViewModel
  @Binding var doShowLoggedIn: Bool
  
  // Imperfect solution to logout -> redirects to Safari and blindy returns to sign in screen once the logout page is shown in safari. Requires re-nav to app. Also works to display in app using another ASWebAuthenticationSession, but the UI for that is very confusing to a user.
  func handleSignOutTap() {
    NetworkRequest.signOutSafari() { [weak self] success in
      if success {
        self?.doShowLoggedIn = false
      }
    }
  }
  
  init(_ doShowLoggedIn: Binding<Bool>) {
    // Use underscore to set actual Binding type rather than wrapped value
    self._doShowLoggedIn = doShowLoggedIn
  }
}
