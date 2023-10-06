//
//  InfoViewController.swift
//  alley-test
//
//  Created by abdul karim on 05/10/23.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var tvImageOCR: UITextView!
    @IBOutlet weak var lImageLabel: UILabel!
    
    var imageLabel:String?
    var imageOCR:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lImageLabel.text = imageLabel
        tvImageOCR.text = imageOCR
    }


    func setupData(label:String?, ocrText:String?) {
        imageLabel = label ?? ""
        imageOCR = ocrText ?? ""
    }

}
