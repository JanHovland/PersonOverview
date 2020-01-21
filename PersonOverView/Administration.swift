//
//  Administration.swift
//  PersonOverView
//
//  Created by Jan Hovland on 21/01/2020.
//  Copyright © 2020 Jan Hovland. All rights reserved.
//

import Combine
import SwiftUI
import CloudKit

class Administration: ObservableObject {
    @Published var showPassword: Bool = false
}
