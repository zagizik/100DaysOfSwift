//
//  Petition.swift
//  Project7
//
//  Created by Александр Банников on 30.07.2020.
//  Copyright © 2020 Александр Банников. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
