//
//  qwerty.swift
//  PersonOverView
//
//  Created by Jan Hovland on 11/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import SwiftUI
import CloudKit

struct qwerty: View {

    @State private var item = UserElement(name: "", email: "", password: "")

    var body: some View {
        VStack {
            Text("CloudKit")
                .font(.largeTitle)
                .padding()

            TextField("Navn", text: $item.name)

            Button(
                action: {
                    // self.item.name = self.item.name
                    self.item.email = "a@b.com"
                    self.item.password = "qwerty"

                    let msg = CloudKitRecord.saveUser(item: self.item)
                    if msg.count > 0 {
                        print("msg = \(msg)")
                    }

                },
                label: { Text("Test save function for CloudKit") }
            )
        }
    }
}
