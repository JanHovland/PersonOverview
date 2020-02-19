//
//  FindPostalCode.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/02/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct FindPostalCode: View {

    var city: String
    var firstName: String
    var lastName: String

    @State private var postalCode = PostalCode()
    @State private var postalCodes = [PostalCode]()
    @State private var findPostalCode: Bool = false
    @State private var selection = 0
    @State private var pickerVisible = false
    @State private var message: String = ""
    @State private var alertIdentifier: AlertID?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    HStack {
                        Text("Poststed")
                        Spacer()
                        if self.postalCodes.count > 0 {
                            Button(self.postalCodes[selection].postalNumber + " " + self.postalCodes[selection].postalName) {
                               self.pickerVisible.toggle()
                            }
                            .foregroundColor(self.pickerVisible ? .red : .blue)
                        }
                    }
                    if pickerVisible {
                        Picker(selection: $selection, label: EmptyView()) {
                            ForEach((0..<postalCodes.count), id: \.self) { ix in
                                Text(self.postalCodes[ix].postalNumber + " " + self.postalCodes[ix].postalName).tag(ix)
                            }
                        }
                        /// Denne sørger for å vise det riktige "valget" pålinje 2
                        .id(UUID().uuidString)
                        .onTapGesture {
                            self.pickerVisible.toggle()
                            self.selection = 0
                        }
                    }
                }
            }
            .navigationBarTitle("PostalCode", displayMode: .inline)
        }
        .onAppear {
            self.zoomPostalCode(value: self.city)
        }
        .alert(item: $alertIdentifier) { alert in
            switch alert.id {
            case .first:
                return Alert(title: Text(self.message))
            case .second:
                return Alert(title: Text(self.message))
            case .third:
                return Alert(title: Text(self.message))
            }
        }
    }

    /// Rutine for å finne postnummert
    func zoomPostalCode(value: String) {
        /// Sletter alt tidligere innhold
        self.postalCodes.removeAll()
        /// Dette predicate gir følgende feilmelding: Your request contains 4186 items which is more than the maximum number of items in a single request (400)
        /// Dersom operation.resultsLimit i CloudKitPostalCode er for høy verdi 500 er OK
        /// let predicate = NSPredicate(value: true)
        /// Dette predicate gir ikke noen feilmelding
        let predicate = NSPredicate(format: "postalName == %@", value.uppercased())
        /// Dette predicate gir ikke noen feilmelding
        /// let predicate = NSPredicate(format:"postalName BEGINSWITH %@", value.uppercased())
        CloudKitPostalCode.fetchPostalCode(predicate: predicate) { (result) in
            switch result {
            case .success(let postalCode):
                self.postalCodes.append(postalCode)
                /// Sortering
                self.postalCodes.sort(by: {$0.postalName < $1.postalName})
                self.postalCodes.sort(by: {$0.postalNumber < $1.postalNumber})
            case .failure(let err):
                self.message = err.localizedDescription
                self.alertIdentifier = AlertID(id: .first)
            }
        }
    }

}

/// Funksjon for å sette første bokstav til uppercase
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
