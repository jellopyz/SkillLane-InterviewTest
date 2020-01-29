//
//  MainViewModel.swift
//  SkillLaneTest
//
//  Created by Thanakorn Amnajsatit on 28/1/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MainViewModel {
    // MARK: - Properties
    var photoBookList = [PhotoBook]()
    
    var onSuccessFetchData: (() -> Void)?
    
    // MARK: - Functions
    func mapListOfData(_ jsonArray: [JSON]?) {
        for jsonObject in jsonArray ?? [] {
            photoBookList.append(PhotoBook(jsonObject))
        }
    }
    
    func fetchData() {
        let url = "https://picsum.photos/v2/list?page=1&limit=3"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON { [unowned self] (response) in
            guard response.result.isSuccess,
                let value = response.result.value else {
                    print("Error occured when fetching: \(response.result.error)")
                    return
            }
            
            let json = JSON(value)
            self.mapListOfData(json.array)
            self.onSuccessFetchData?()
        }
    }
}
