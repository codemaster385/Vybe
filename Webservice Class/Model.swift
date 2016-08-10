//
//  Model.swift
//  Vybe
//
//  Created by Arun Kumar on 08/08/16.
//  Copyright © 2016 paramvir singh. All rights reserved.
//

import UIKit

class Model: NSObject {

}

class Registration {
    let status : String
    let message : String
    init(response : JSON)
    {
        self.status = response["status"].stringValue
        self.message = response["message"].stringValue
    }
}