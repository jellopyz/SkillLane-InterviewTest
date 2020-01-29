//
//  DisplayScreenViewController.swift
//  SkillLaneTest
//
//  Created by Thanakorn Amnajsatit on 28/1/2563 BE.
//  Copyright © 2563 GAS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHash

class DisplayScreenViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var downloadAuthorLabel: UILabel!
    @IBOutlet weak var downloadQuantityLabel: UILabel!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var viewModel: DisplayScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadImages(self.viewModel!.photoBookList, self.viewModel!.globalIndex)
        self.addApplicationNotification()
    }
    
    private func addApplicationNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        self.viewModel!.request?.resume()
    }
    
    @objc func applicationDidEnterBackground(notification: NSNotification) {
        self.viewModel!.request?.suspend()
    }
    
    func downloadImages(_ photoBookList: [PhotoBook]?, _ index: Int) {
        guard let photoBookList = photoBookList else { return }
        // When final image downloaded
        guard index < photoBookList.count else {
            self.authorLabel.text = self.viewModel!.photoBookList![0].author
            self.downloadAuthorLabel.text = "Download Completed"
            self.downloadQuantityLabel.text = "Total file size: \(self.viewModel!.downloadCount) KB"
            self.progressBar.isHidden = true
            self.previousBtn.isHidden = false
            self.nextBtn.isHidden = false
            self.imageView.image = self.viewModel!.photoBookList![0].image
            return
        }
        guard !isImageExisting(imageName: MD5(photoBookList[index].photo_url!) + ".png") else {
            let imagePath = getImagePath(imageName: MD5(photoBookList[index].photo_url!) + ".png")
            self.viewModel!.photoBookList![index].image = UIImage(contentsOfFile: imagePath)
            let index = index + 1
            self.downloadImages(photoBookList, index)
            return
        }
        self.downloadAuthorLabel.text = "Download Author\(photoBookList[index].author ?? "xxxx") =>"
    
        // Download Image
        let url = photoBookList[index].photo_url ?? ""
        self.viewModel!.request = Alamofire.request(url).downloadProgress { [unowned self] (progress) in
            // Update total file size and progress bar
            self.downloadQuantityLabel.text = "\(self.viewModel!.downloadCount + Int(progress.completedUnitCount) / 1000) KB downloading"
            self.progressBar.progress = self.viewModel!.progressValue + (Float(progress.fractionCompleted) / Float(photoBookList.count))
        }.responseData { [unowned self] (response) in
            guard response.result.value != nil else { return }
            
            self.viewModel!.downloadCount += response.result.value!.count / 1000
            self.viewModel!.progressValue += 1 / Float(photoBookList.count)
            
            if let data = response.result.value {
                self.viewModel!.photoBookList![index].image = UIImage(data: data)
                self.saveImage(imageName: MD5(self.viewModel!.photoBookList![index].photo_url!) + ".png", image: UIImage(data: data)!)
            }
            
            
            // Do the recursive function to download next image
            let index = index + 1
            self.downloadImages(photoBookList, index)
        }
    }
    
    func saveImage(imageName: String, image: UIImage) {
        let fileManager = FileManager.default
        let imagePath = getImagePath(imageName: imageName)
        let data = image.pngData()
        
        fileManager.createFile(atPath: imagePath, contents: data, attributes: nil)
    }
    
    func getImagePath(imageName: String) -> String {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let imagePath = (NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        return imagePath
    }
    
    func isImageExisting(imageName: String) -> Bool {
        let fileManager = FileManager.default
        let imagePath = getImagePath(imageName: imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            return true
        } else {
            return false
        }
    }
    
    fileprivate func updateDisplaying(_ photoBookList: [PhotoBook], increase increaseNumber: Int) {
        self.viewModel!.globalIndex += increaseNumber
        self.imageView.image = photoBookList[self.viewModel!.globalIndex].image
        self.authorLabel.text = photoBookList[self.viewModel!.globalIndex].author
    }
    
    @IBAction func previousBtnTapped(_ sender: Any) {
        guard let photoBookList = self.viewModel!.photoBookList else { return }
        guard self.viewModel!.globalIndex > 0 else { return }
        
        updateDisplaying(photoBookList, increase: -1)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        guard let photoBookList = self.viewModel!.photoBookList else { return }
        guard self.viewModel!.globalIndex < photoBookList.count-1 else { return }
        
        updateDisplaying(photoBookList, increase: 1)
    }
}
