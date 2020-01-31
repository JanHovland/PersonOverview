//
//  PersonsOverView.swift
//  PersonOverView
//
//  Created by Jan Hovland on 29/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct PersonsOverView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var showPersonView: Bool = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(persons) {
                        person in
                        NavigationLink(destination: PersonView(person: person)) {
                            HStack(spacing: 5) {
                                Group {
                                    if person.image != nil {
                                        Image(uiImage: person.image!)
                                            .resizable()
                                            .frame(width: 30, height: 30, alignment: .center)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    }
                                    Text(person.firstName)
                                    Text(person.lastName)
                                    Text(person.address)
                                    Text(person.cityNumber)
                                    Text(person.city)
                                }
                            }}
                    }
                }
                .navigationBarTitle(NSLocalizedString("Persons overview", comment: "PersonsOverView"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text(NSLocalizedString("Cancel", comment: "PersonsOverView"))
                            .foregroundColor(.none)
                    }))
            }
        }
        .onAppear {
            /// Sletter alt tidligere innhold i personElements.persons
            self.persons.removeAll()
            /// Fetch all persons from CloudKit
            let predicate = NSPredicate(value: true)
            CloudKitPerson.fetchPerson(predicate: predicate)  { (result) in
                switch result {
                case .success(let person):
                    self.persons.append(person)
                case .failure(let err):
                    self.message = err.localizedDescription
                    self.alertIdentifier = AlertID(id: .first)
                }
            }
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            }
        }

    }
}
