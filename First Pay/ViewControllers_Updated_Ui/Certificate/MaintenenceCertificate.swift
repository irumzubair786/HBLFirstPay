//
//  MaintenenceCertificate.swift
//  First Pay
//
//  Created by Irum Butt on 04/04/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit
import PDFKit
import WebKit
class MaintenenceCertificate: UIViewController {
    let pdfView = PDFView()
    public var documentData: Data?
    
//    @IBOutlet weak var pdfView = PDFView!()
    
    var pdfFile: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
    
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfViewContainer.addSubview(pdfView)
       
        pdfView.leadingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView.isUserInteractionEnabled = false
        pdfView.borderColor = UIColor.gray
        
        if let data = documentData {
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var pdfViewContainer: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func buttonDownload(_ sender: UIButton) {
        guard let pdfData = documentData else { return }
        
        let vc = UIActivityViewController(
          activityItems: [pdfData],
          applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
        print()
        
    }
    func savePdf(pdfData:Data?, fileName:String) {
            DispatchQueue.main.async {
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("pdf successfully saved!")
                    print(actualPath)
                } catch {
                    print("Pdf could not be saved")
                }
            }
        }
    
}
