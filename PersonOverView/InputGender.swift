//
//  InputGender.swift
//  PersonOverView
//
//  Created by Jan Hovland on 16/11/2019.
//  Copyright © 2019 Jan Hovland. All rights reserved.
//

import SwiftUI

struct InputGender: View {
    var heading: String
    var genders: [String]
    @Binding var value: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(heading)
                    .font(.footnote)
                    .padding(-5)
                Picker(selection: $value, label: Text("")) {
                    ForEach(0..<genders.count) { index in
                        Text(self.genders[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}


