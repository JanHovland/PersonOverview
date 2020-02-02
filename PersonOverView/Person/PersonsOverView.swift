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

    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?
    @State private var persons = [Person]()
    @State private var newPerson = false
    @State private var personsOverview = NSLocalizedString("Persons overview", comment: "PersonsOverView")

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
                    /// Sletter den valgte person 
                    .onDelete { (indexSet) in
                        self.persons.remove(atOffsets: indexSet)
                    }

                }
            }
            .navigationBarTitle(personsOverview)
            .navigationBarItems(leading:
                Button(action: {
                    /// Rutine for å friske opp personoversikten
                    self.refresh()
                }, label: {
                    Text("Refresh")
                        .foregroundColor(.none)
                })
                , trailing:
                Button(action: {
                    /// Rutine for å legge til en person
                    self.newPerson.toggle()
                }, label: {
                    Text("Add")
                })
            )
        }
        .sheet(isPresented: $newPerson) {
            NewPersonView()
        }
        .onAppear {
            self.refresh()
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            }
        }
        .overlay(
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.none)
                    })
                        .padding(.trailing, 20)
                        .padding(.top, 70)
                    Spacer()
                }
            }
        )
    }

    /// Rutine for å friske opp bildet
    func refresh() {
        /// Sletter alt tidligere innhold i person
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
}

/*

 .onDelete { (indexSet) in self.restaurants.remove(atOffsets: indexSet)
 }


                       .onLongPressGesture {
                            if !self.showEditTextField {
                                guard let recordID = item.recordID else { return }
                                // MARK: - delete from CloudKit
                                CloudKitHelper.delete(recordID: recordID) { (result) in
                                    switch result {
                                    case .success(let recordID):
                                        self.listElements.items.removeAll { (listElement) -> Bool in
                                            return listElement.recordID == recordID
                                        }
                                        print("Successfully deleted item")
                                    case .failure(let err):
                                        print(err.localizedDescription)
                                    }
                                }

                            }
                    }


 */

