//
//  ContentView.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import SwiftUI

// We won't be able to pass this in a type for the variable in HomeView, as ObservableObjects
// require a concrete type for storing data. We can still use it to ensure required values exist
// and as a point of reference.
protocol HomeViewDelegate {
  var doShowLoggedIn: Bool { get }
  func handleSignInTap()
}

struct HomeView: View {
  @ObservedObject var viewModel = HomeViewModel()
  
  var signInLink: some View {
    NavigationLink(
      destination: LoggedInView($viewModel.doShowLoggedIn),
      isActive: $viewModel.doShowLoggedIn) {
      EmptyView()
    }
  }
  
  var buttonLabel: some View {
    Text("Sign In")
      .padding(.horizontal, 50)
      .padding(.vertical, 8)
      .foregroundColor(.white)
      .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray))
  }
  
  var bodyContent: some View {
    VStack {
      signInLink
      Button(action: viewModel.handleSignInTap,
           label: { buttonLabel })
    }
  }
  
  var body: some View {
    NavigationView {
      bodyContent
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
