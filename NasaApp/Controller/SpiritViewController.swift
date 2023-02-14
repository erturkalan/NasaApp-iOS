//
//  SpiritViewController.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import UIKit

class SpiritViewController: CuriosityViewController {
    
    
    @IBOutlet weak var spiritFilterButton: UIButton!
    private var spiritPageNumber: Int = 1
    private var spiritPhotoArray: [PhotoModel] = []
    private var isFilterEmpty: Bool = true
    private var totalPhotos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    //MARK: - Override Get Photo Method from the Super View
    override func getPhoto(roverName: String, page: Int = 1, completion: (() -> Void)? = nil) {
        NetworkService.sharedInstance.fetchData(rover: roverName, pageNumber: page) { result in
            if self.spiritFilterButton.titleLabel?.text != "Filter" {
                var totalPhotos: [PhotoModel] = []
                for photo in result {
                    if photo.camera.name == self.spiritFilterButton.titleLabel?.text {
                        totalPhotos.append(photo)
                        self.spiritPhotoArray.append(photo)
                    }
                }
                self.totalPhotos = totalPhotos.count
            }else{
                self.spiritPhotoArray.append(contentsOf: result)
                self.totalPhotos = result.count
            }
            DispatchQueue.main.async {
                self.curiosityCollectionView.reloadData()
                completion?()
            }
        }
    }
    
    @IBAction func spiritFilterPressed(_ sender: UIButton) {
        
        if isFilterEmpty {
            let vc = FilterViewController()
            if let vc = vc.sheetPresentationController {
                vc.detents = [.medium()]
            }
            vc.callback = { result in
                self.isFilterEmpty = false
                var filteredPhotoArray: [PhotoModel] = []
                for photo in self.spiritPhotoArray{
                    if photo.camera.name == result {
                        filteredPhotoArray.append(photo)
                    }
                }
                DispatchQueue.main.async {
                    self.spiritFilterButton.titleLabel?.text = result
                    self.spiritPhotoArray = filteredPhotoArray
                    self.curiosityCollectionView.reloadData()
                    if !self.spiritPhotoArray.isEmpty {
                        self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    }
                }
            }
            self.present(vc, animated: true)
        }else{
            spiritPageNumber = 1
            spiritPhotoArray.removeAll()
            spiritFilterButton.titleLabel?.text = "Filter"
            isFilterEmpty = true
            getPhoto(roverName: ServiceConstant.spirit.rawValue, page: spiritPageNumber) {
                if !self.spiritPhotoArray.isEmpty {
                    self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    //MARK: - Override Data Source Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spiritPhotoArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.setup(with: spiritPhotoArray[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == spiritPhotoArray.count - 1 && self.totalPhotos != 0 {
            spiritPageNumber += 1
            getPhoto(roverName: ServiceConstant.spirit.rawValue, page: spiritPageNumber)
        }
    }
    
    
    //MARK: - Override Delegate Method
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let data = spiritPhotoArray[indexPath.row]
        
        popUpView = PopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), image: data.img_src, roverName: data.rover.name, photoDate: data.earth_date, cameraName: data.camera.name, status: data.rover.status, launchDate: data.rover.launch_date, landingDate: data.rover.landing_date)
        
        self.view.addSubview(popUpView ?? UIView())
    }
    
}



