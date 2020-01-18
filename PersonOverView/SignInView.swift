//
//  SignInView.swift
//  PersonOverview
//
//  Created by Jan Hovland on 11/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

//  Block comment : Ctrl + Cmd + / (on number pad)
//  Indent        : Ctrl + Cmd + * (on number pad)


/// Ref: SwiftUICloudKit-master-3

import SwiftUI
import Combine

struct SignInView : View {
    
    @State private var show: Bool = false
    @State private var message: String = ""
    @State private var userItem = UserElement(name: "", email: "", password: "")
    @State private var showUserMaintenanceView: Bool = false
    @State private var showDeleteUserView: Bool = false
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView  {
            VStack {
                Spacer(minLength: 17)
                HStack {
                    Text(NSLocalizedString("Sign in CloudKit", comment: "SignInView"))
                        .font(Font.title.weight(.light))
                        .foregroundColor(.accentColor)
                }
                Spacer(minLength: 20)
                HStack  (alignment: .center, spacing: 80) {
                    ZStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .font(Font.title.weight(.ultraLight))
                        if self.user.image != nil {
                            Image(uiImage: self.user.image!)
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(color: .gray, radius: 3)
                        }
                    }
                    HStack {
                        Image(systemName: "info.circle")
                            .font(Font.system(.title).weight(.thin))
                            .foregroundColor(.accentColor)
                    }
                }
                .padding()
                .contextMenu {
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showUserMaintenanceView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.show.toggle()
                            }
                        }, label: {
                            Text(NSLocalizedString("User maintenance", comment: "SignInView"))
                            Image(systemName: "pencil.and.ellipsis.rectangle")
                                .font(Font.system(.headline).weight(.regular))
                        })
                    }
                    .sheet(isPresented: $showUserMaintenanceView) {
                        /// må kalles på denne måten for å kunne benytte flere environmentObject
                        UserMaintenanceView().environmentObject(self.user)
                    }
                    HStack {
                        Button(action: {
                            if self.user.name.count > 0, self.user.email.count > 0, self.user.password.count > 0 {
                                self.showDeleteUserView.toggle()
                            } else {
                                self.message = NSLocalizedString("Name, eMail and Password must have a value", comment: "SignInView")
                                self.show.toggle()
                            }
                        }, label: {
                            Text(NSLocalizedString("Delete user", comment: "SignInView"))
                            Image(systemName: "person")
                                .font(Font.system(.headline).weight(.thin))
                        })
                    }
                    .sheet(isPresented: $showDeleteUserView) {
                        /// må kalles på denne måten for å kunne benytte flere environmentObject
                        UserDeleteView().environmentObject(self.user)
                    }
                    /// Uten padding blir noe av visningen kuttet bort
                    .padding()
                    /// Brukes for å få med "Image(systemName: "chevron.down")"
                    .overlay(
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            HStack {
                                Text(NSLocalizedString("Exit", comment: "SignInView"))
                                Image(systemName: "chevron.down")
                                    .font(Font.system(.headline).weight(.ultraLight))
                                    .background(Color(.blue))
                                    .foregroundColor(.accentColor)
                            }
                        })
                    )
                }
                VStack (alignment: .leading) {
                    Spacer(minLength: 38)
                    OutputTextField(secure: false,
                                    heading: NSLocalizedString("Your name", comment: "SignInView"),
                                    value: $user.name)
                        .autocapitalization(.words)
                    Spacer(minLength: 23)
                    InputTextField(secure: false,
                                   heading: NSLocalizedString("eMail address", comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your email address", comment: "SignInView"),
                                   value: $user.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                    InputTextField(secure: true,
                                   heading: NSLocalizedString("Password",  comment: "SignInView"),
                                   placeHolder: NSLocalizedString("Enter your password", comment: "SignInView"),
                                   value: $user.password)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    Spacer(minLength: 20)
                }
                .padding(10)
                VStack {
                    Button(action: {
                        if self.user.email.count > 0, self.user.password.count > 0 {
                            let email = self.user.email
                            /// Check different predicates at :   https://nspredicate.xyz
                            /// %@ : an object (eg: String, date etc), whereas %i will be substituted with an integer.
                            let predicate = NSPredicate(format: "email == %@", email)
                            CloudKitUser.doesUserExist(email: self.user.email, password: self.user.password) { (result) in
                                if result == false {
                                    self.message = NSLocalizedString("Unknown email or password:", comment: "SignInView")
                                    self.show.toggle()
                                } else {
                                    CloudKitUser.fetchUser(predicate: predicate) { (result) in
                                        switch result {
                                        case .success(let userItem):
                                            self.user.email = userItem.email
                                            self.user.password = userItem.password
                                            self.user.name = userItem.name
                                            if userItem.image != nil {
                                                self.user.image = userItem.image!
                                            } else {
                                                self.user.image = nil
                                            }
                                            self.user.recordID = userItem.recordID
                                        case .failure(let err):
                                            self.message = err.localizedDescription
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            self.message = NSLocalizedString("Both email and Password must have a value", comment: "SignInView")
                            self.show.toggle()
                        }
                    }) {
                        Text(NSLocalizedString("Sign In", comment: "SignInView"))
                        // .padding(10)
                    }
                }
            }
            .alert(isPresented: $show) {
                return Alert(title: Text(self.message))
            }
        }
        /// Ta bort tastaturet når en klikker utenfor feltet
        .modifier(DismissingKeyboard())
        /// Flytte opp feltene slik at keyboard ikke skjuler aktuelt felt
        .modifier(AdaptsToSoftwareKeyboard())
    }
}
