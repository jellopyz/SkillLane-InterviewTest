//
//  PhotoBookModel.swift
//  SkillLaneTest
//
//  Created by Thanakorn Amnajsatit on 28/1/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import Foundation
import SwiftyJSON

class PhotoBook {
    let author: String?
    let photo_url: String?
    var image: UIImage?
    
    init(_ dictionary: JSON) {
        author = dictionary["author"].string
        photo_url = dictionary["download_url"].string
        image = nil
    }
}
