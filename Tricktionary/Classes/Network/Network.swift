//
//  Network.swift
//  Tricktionary
//
//  Created by Marek Štovíček on 29.07.2021.
//  Copyright © 2021 Marek Šťovíček. All rights reserved.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.the-tricktionary.com/")!)
}
