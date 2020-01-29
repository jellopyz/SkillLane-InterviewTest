//
//  DisplayScreenViewModel.swift
//  SkillLaneTest
//
//  Created by Thanakorn Amnajsatit on 29/1/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import Foundation
import Alamofire

class DisplayScreenViewModel {
    var photoBookList: [PhotoBook]?
    var downloadCount: Int = 0
    var progressValue: Float = 0
    var globalIndex: Int = 0
    var request: Alamofire.Request?
}
