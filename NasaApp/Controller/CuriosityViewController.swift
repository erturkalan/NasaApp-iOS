//
//  CuriosityViewController.swift
//  NasaApp
//
//  Created by Ertürk Alan on 7.02.2023.
//

import UIKit

class CuriosityViewController: UIViewController {
    
    @IBOutlet weak var curiosityCollectionView: UICollectionView!
    
    @IBOutlet weak var curiosityFilterButton: UIButton!
    
    private var curiosityPageNumber: Int = 1
    private var curiosityPhotoArray: [PhotoModel] = []
    private var isFilterEmpty: Bool = true
    private var totalPhotos = 0
    
    var popUpView: PopUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch self {
        case is OpportunityViewController:
            getPhoto(roverName: ServiceConstant.opportunity.rawValue)
        case is SpiritViewController:
            getPhoto(roverName: ServiceConstant.spirit.rawValue)
        default:
            getPhoto(roverName: ServiceConstant.curiosity.rawValue)
        }
        
        configureCollectionView()
    }
    
    func getPhoto(roverName: String, page: Int = 1, completion: (() -> Void)? = nil) {
        NetworkService.sharedInstance.fetchData(rover: roverName, pageNumber: page) { result in
            if self.curiosityFilterButton.titleLabel?.text != "Filter" {
                var totalPhotos: [PhotoModel] = []
                for photo in result {
                    if photo.camera.name == self.curiosityFilterButton.titleLabel?.text {
                        totalPhotos.append(photo)
                        self.curiosityPhotoArray.append(photo)
                    }
                }
                self.totalPhotos = totalPhotos.count
            }else{
                self.curiosityPhotoArray.append(contentsOf: result)
                self.totalPhotos = result.count
            }
            
            DispatchQueue.main.async {
                self.curiosityCollectionView.reloadData()
                completion?()
            }
        }
    }
    
    func configureCollectionView() {
        curiosityCollectionView.dataSource = self
        curiosityCollectionView.delegate = self
        let layOut = UICollectionViewFlowLayout()
        curiosityCollectionView.collectionViewLayout = layOut
        layOut.scrollDirection = .horizontal
        
    }
    
    
    @IBAction func curiosityFilterPressed(_ sender: UIButton) {
        if isFilterEmpty {
            let vc = FilterViewController()
            if let vc = vc.sheetPresentationController {
                vc.detents = [.medium()]
            }
            vc.callback = { result in
                self.isFilterEmpty = false
                var filteredPhotoArray: [PhotoModel] = []
                for photo in self.curiosityPhotoArray{
                    if photo.camera.name == result {
                        filteredPhotoArray.append(photo)
                    }
                }
                DispatchQueue.main.async {
                    self.curiosityFilterButton.setTitle(result, for: .normal)
                    self.curiosityPhotoArray = filteredPhotoArray
                    self.curiosityCollectionView.reloadData()
                    if !self.curiosityPhotoArray.isEmpty {
                        self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                    }
                }
            }
            self.present(vc, animated: true)
        }else{
            curiosityPageNumber = 1
            curiosityPhotoArray.removeAll()
            curiosityFilterButton.setTitle("Filter", for: .normal)
            isFilterEmpty = true
            getPhoto(roverName: ServiceConstant.curiosity.rawValue, page: curiosityPageNumber) {
                if !self.curiosityPhotoArray.isEmpty {
                    self.curiosityCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
                }
            }
        }
        
    }
    
}

//MARK: - UICollectionViewDataSource

extension CuriosityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curiosityPhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.setup(with: curiosityPhotoArray[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        if indexPath.row == curiosityPhotoArray.count - 1 && self.totalPhotos != 0 {
            curiosityPageNumber += 1
            getPhoto(roverName: ServiceConstant.curiosity.rawValue, page: curiosityPageNumber)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CuriosityViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: - UICollectionViewDelegate
extension CuriosityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let data = curiosityPhotoArray[indexPath.row]
        
        popUpView = PopUpView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), image: data.img_src, roverName: data.rover.name, photoDate: data.earth_date, cameraName: data.camera.name, status: data.rover.status, launchDate: data.rover.launch_date, landingDate: data.rover.landing_date)
        
        self.view.addSubview(popUpView ?? UIView())
    }
}


