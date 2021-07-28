//
//  LoggedInView.swift
//  AuthTest
//
//  Created by Wyatt Eberspacher on 7/27/21.
//

import SwiftUI

protocol LoggedInViewDelegate {
  var doShowLoggedIn: Bool { get }
  func handleSignOutTap()
}

struct LoggedInView: View {
  // Access presentation mode to allow for programmatic dismissal
  @Environment(\.presentationMode) var presentationMode
  
  @ObservedObject private var viewModel: LoggedInViewModel
  
  init(_ doShowLoggedIn: Binding<Bool>) {
    self.viewModel = LoggedInViewModel(doShowLoggedIn)
  }
  var successLabel: some View {
    VStack {
      Text("Hello \(viewModel.username),")
        .padding(.bottom, 12)
        .font(.system(size: 36, weight: .semibold, design: .default))
      Text("you have \(viewModel.repoCount) repos")
        .font(.system(size: 24, weight: .regular, design: .default))
    }
    .padding(.bottom, 40)
  }
  
  var buttonLabel: some View {
    Text("Sign Out")
      .padding(.horizontal, 50)
      .padding(.vertical, 8)
      .foregroundColor(.white)
      .background(RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray))
  }
  
  var body: some View {
    VStack {
      successLabel
      Button(action: {
        viewModel.handleSignOutTap()
      }) {
        buttonLabel
      }
      Button(action: { presentationMode.wrappedValue.dismiss() }) {
        EmptyView()
      }
    }
    .navigationBarBackButtonHidden(true)
    .onAppear {
      viewModel.load()
    }
    .onChange(of: viewModel.doShowLoggedIn) { doShowLoggedIn in
      if !doShowLoggedIn {
        presentationMode.wrappedValue.dismiss()
      }
    }
  }
}

struct LoggedInView_Previews: PreviewProvider {
  static var previews: some View {
    LoggedInView(.constant(true))
  }
}
