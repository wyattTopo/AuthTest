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
  
  func handleSignOutTap() {
    doShowLoggedIn = false
  }
  
  init(_ doShowLoggedIn: Binding<Bool>) {
    // Use underscore to set actual Binding type rather than wrapped value
    self._doShowLoggedIn = doShowLoggedIn
  }
}
