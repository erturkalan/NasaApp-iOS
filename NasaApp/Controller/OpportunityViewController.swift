//
//  OpportunityViewController.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import UIKit

class OpportunityViewController: CuriosityViewController {

    @IBOutlet weak var opportunityFilterButton: UIButton!
    private var opportunityPageNumber: Int = 1
    private var opportunityPhotoArray: [PhotoModel] = []
    private var isFilterEmpty: Bool = true
    private var totalPhotos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -  Override Get Photo Method from the Super View
    
    override func getPhoto(roverName: String, page: Int = 1, completion: (() -> Void)? = nil) {
        NetworkService.sharedInstance.fetchData(rover: roverName, pageNumber: page) { result in
            if self.opportunityFilterButton.titleLabel?.text != "Filter" {
                var totalPhotos: [PhotoModel] = []
                for photo in result {
                    if photo.camera.name == self.opportunityFilterButton.titleLabel?.text {
                        totalPhotos.append(photo)
                        self.opportunityPhotoArray.append(photo)
                    }
                }
                self.totalPhotos = totalPhotos.count
            }else{
                self.opportunityPhotoArray.append(contentsOf: result)
                self.totalPhotos = result.count
            }
            DispatchQueue.main.async {
                self.curiosityCollectionView.reloadData()
                completion?()
            }
        }
    }
    
    @IBAction func opportunityFilterPressed(_ sender: UIButton) {
        
        if isFilterEmpty {
            let vc = FilterViewController()
            if let vc = vc.sheetPresentationController {
                vc.detents = [.medium()]
            }
            vc.callback = { result in
                self.isFilterEmpty = false
                var filteredPhotoArray: [PhotoModel] = []
                for photo in self.opportunityPhotoArray{
                    if photo.camera.name == result {
                        filteredPhotoArray.append(photo)
                    }
                }
                DispatchQueue.main.async {
                    self.opportunityFilterButton.setTitle(result, for: .normal)
                    self.opportunityPhotoArray = filteredPhotoArray
                    self.curiosityCollectionView.reloadData()
                    if !self.opportunityPhotoArray.isEmpty {
                        self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    }
                }
            }
            self.present(vc, animated: true)
        }else{
            opportunityPageNumber = 1
            opportunityPhotoArray.removeAll()
            opportunityFilterButton.setTitle("Filter", for: .normal)
            isFilterEmpty = true
            getPhoto(roverName: ServiceConstant.opportunity.rawValue, page: opportunityPageNumber) {
                if !self.opportunityPhotoArray.isEmpty {
                    self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
    }
    
    
    //MARK: -  Override Data Source Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return opportunityPhotoArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.setup(with: opportunityPhotoArray[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == opportunityPhotoArray.count - 1 && self.totalPhotos != 0 {
            opportunityPageNumber += 1
            getPhoto(roverName: ServiceConstant.opportunity.rawValue, page: opportunityPageNumber)
        }
    }
    
    //MARK: - Override Delegate Method
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let data = opportunityPhotoArray[indexPath.row]
        
        popUpView = PopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), image: data.img_src, roverName: data.rover.name, photoDate: data.earth_date, cameraName: data.camera.name, status: data.rover.status, launchDate: data.rover.launch_date, landingDate: data.rover.landing_date)
        
        self.view.addSubview(popUpView ?? UIView())
    }
    
}




