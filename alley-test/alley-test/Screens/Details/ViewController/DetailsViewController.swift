//
//  DetailsViewController.swift
//  alley-test
//
//  Created by abdul karim on 04/10/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var cvCollectionView: UICollectionView! {
        didSet {
            cvCollectionView.dataSource = self
            cvCollectionView.delegate = self
            PhotoCollectionViewCell.registerCellForCollectionView(cvCollectionView)
        }
    }
    @IBOutlet weak var bDeleteButton: UIButton!
    @IBOutlet weak var bInfoButton: UIButton!
    @IBOutlet weak var bShareButton: UIButton!
    @IBOutlet weak var ivDetailImage: UIImageView!
    
    var viewModel:DetailViewModel!
    weak var mainCoordinator :MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        setupView()
        cvCollectionView.reloadData()
        addGesture()
    }

}

extension DetailsViewController {
    fileprivate func addGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            viewModel.index += 1
            if viewModel.index > viewModel.photos.count {
                viewModel.index = viewModel.photos.count 
            }
        } else if gesture.direction == .right {
            viewModel.index -= 1
            if viewModel.index < 0 {
                viewModel.index = 0
            }
        }
        
        setupView()
    }
    
    
    fileprivate func addTargets() {
        bDeleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        bInfoButton.addTarget(self, action: #selector(handleInfo), for: .touchUpInside)
        bShareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }
    
    @objc func handleDelete() {
        
    }
    
    @objc func handleInfo() {
        guard let img = viewModel.getSelectedPhoto() else {
            return
        }
        
        Task { @MainActor in
            let ocrText = try await viewModel.recognizeText(in: img) ?? "--"
            let imageLabel = try await viewModel.recognizeImage(in: img) ?? "--"
            mainCoordinator?.openInfoDetails(labelText: imageLabel, ocrStr: ocrText)
        }

    }
    
    @objc func handleShare() {
        if let sharingImage = viewModel.getSelectedPhoto() {
            shareImage(image: sharingImage, viewController: self)
        }
    }
    
    fileprivate func setupView() {
        ivDetailImage.image = viewModel.getSelectedPhoto()
    }
    
    fileprivate func shareImage(image: UIImage, viewController: UIViewController) {
        // Create an array of items to share, in this case, an image
        let items: [Any] = [image]

        // Create an instance of UIActivityViewController with the items to share
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        // Exclude some activities from the list (optional)
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList,
            .openInIBooks,
            .markupAsPDF
        ]

        // Present the UIActivityViewController
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}

extension DetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.nibName, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        let img = viewModel.photos[indexPath.row]
        photoCell.ivPhoto.image = img
        
        return photoCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth:CGFloat = 54
        let cellHeight: CGFloat = 54
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.index = indexPath.row
        setupView()
    }
}
