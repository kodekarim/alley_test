//
//  HomeViewController.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import UIKit
import Photos

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cvCollectionView: UICollectionView! {
        didSet {
            cvCollectionView.delegate = self
            cvCollectionView.dataSource = self
            cvCollectionView.prefetchDataSource = self
            PhotoCollectionViewCell.registerCellForCollectionView(cvCollectionView)
        }
    }
    @IBOutlet weak var bGetAccessButton: UIButton!
    
    weak var mainCoordinator :MainCoordinator?
    var viewModel :HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        manageUI()
        checkPhotoLibraryPermission()
    }
}

extension HomeViewController {
    fileprivate func addTargets() {
        bGetAccessButton.addTarget(self, action: #selector(handleAccessTap), for: .touchUpInside)
    }
    
    @objc func handleAccessTap() {
        viewModel.setupPhotos()
        loadFirstBatch(startIndex: 0, batchSize: 30)
    }
}

extension HomeViewController {
    fileprivate func manageUI() {
        if viewModel.imagesArray.count == 0 {
            self.cvCollectionView.isHidden = true
        }else {
            self.cvCollectionView.isHidden = false
        }
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.nibName, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        photoCell.photo = viewModel.getImage(index: indexPath.item)
        return photoCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            getPhotosAndReload(index: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        /*
         for future optimisation and improvemnts
         
         implement id based hash map for each image
         and cancel the id based on indexpath.item
        
        for indexPath in indexPaths {
            if let requestID = imageRequestIDs[indexPath] {
                PHImageManager.default().cancelImageRequest(requestID)
                imageRequestIDs.removeValue(forKey: indexPath)
            }
        }
        */
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let spacingBetweenCells: CGFloat = 2 // Adjust as needed
        
        // Calculating the cell width based on the device's width and the desired spacing
        let cellWidth = (collectionViewWidth - (spacingBetweenCells * 4)) / 3 // 3 cells with 2 spacing in between
        let cellHeight: CGFloat = 100
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = viewModel.imagesArray[indexPath.item]
        if image != nil {
            mainCoordinator?.navigateToPhotoDetails(photo: viewModel.imagesArray , index: indexPath.item)
        }
    }
}


extension HomeViewController {
    
    fileprivate  func loadFirstBatch(startIndex: Int, batchSize: Int) {
        cvCollectionView.reloadData()
        
        for index in startIndex..<(startIndex + batchSize) {
            getPhotosAndReload(index: index)
        }
        manageUI()
    }
    
    fileprivate func getPhotosAndReload(index:Int) {
        let imageArray = viewModel.imagesArray
        guard index < imageArray.count && imageArray[index] == nil else {
            return
        }
        
        if let asset = viewModel.assets?[index] {
            let imageManager = viewModel.imageManager
            let requestOptions = viewModel.imageRequestOptions
            
            imageManager.requestImage(for: asset, targetSize: .zero, contentMode: .aspectFill, options: requestOptions) { image, _ in
                if let image = image {
                    // Update the imagesArray with the loaded image
                    self.viewModel.imagesArray[index] = image
                    
                    // Reload the corresponding cell on the main thread
                    DispatchQueue.main.async {
                        self.cvCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    }
                }
            }
        }
    }
    
    fileprivate func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            print("Permission granted")
            loadFirstBatch(startIndex: 0, batchSize: 30)
        case .notDetermined:
            print("Not Determined")
            requestPermission()
        case .denied, .restricted:
            print("Permission denied")
        case .limited:
            print("Limited Access")
        @unknown default:
            break
        }
    }
    
    fileprivate func requestPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // Permission granted; load photos here
                DispatchQueue.main.async {
                    self.bGetAccessButton.setTitle(LOAD_PHOTOS, for: .normal)
                }
            } else {
                // Permission denied; handle accordingly
                print("Permission denied to access photo library.")
            }
        }
    }
}
