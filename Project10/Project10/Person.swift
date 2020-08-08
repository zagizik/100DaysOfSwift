//
//  Person.swift
//  Project10
//
//  Created by Александр Банников on 07.08.2020.
//  Copyright © 2020 AlexBanana. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
