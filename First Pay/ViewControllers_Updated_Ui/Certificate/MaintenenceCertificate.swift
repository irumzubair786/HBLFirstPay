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
class MaintenenceCertificate: BaseClassVC {
    let pdfView = PDFView()
    public var documentData: Data?
    
//    @IBOutlet weak var pdfView = PDFView!()
    
    var pdfFile: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonBack.setTitle("", for: .normal)
        
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfViewContainer.addSubview(pdfView)
        pdfView.frame = pdfViewContainer.frame
        pdfView.frame.origin.x = 0
        pdfView.frame.origin.y = 0

        
        pdfView.scaleFactor = pdfView.maxScaleFactor
        pdfView.leadingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: pdfViewContainer.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pdfView.isUserInteractionEnabled = true
        pdfView.borderColor = UIColor.gray
        
        if let data = documentData {
//            textView.text = "\(data)"
          pdfView.document = PDFDocument(data: data)
          pdfView.autoScales = true
        }
        // Do any additional setup after loading the view.
    }
    func setZoomLevel(scale: CGFloat) {
           pdfView.scaleFactor = scale
       }
    
    @IBOutlet weak var pdfViewContainer: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBAction func buttonBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func buttonDownload(_ sender: UIButton) {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
                let screenshot = renderer.image { ctx in
                    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
                }
                
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        showToast(title: "Certificate Download Successfully!")
        // Save the screenshot to the camera roll
            
//        guard let pdfData = documentData else { return }
//
//        let vc = UIActivityViewController(
//          activityItems: [pdfData],
//          applicationActivities: []
//        )
//        present(vc, animated: true, completion: nil)
//        print()
        
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

    static func getThumbnailForPDF(_ urlString:String, pageNumber:Int) -> UIImage? {
        let bundle = Bundle.main
        let path = bundle.path(forResource: urlString, ofType: "pdf")
        let pdfURL = URL(fileURLWithPath: path!)

        let pdf = CGPDFDocument(pdfURL as CFURL )!
        let page = pdf.page(at: pageNumber)!
        let rect = CGRect(x: 0, y: 0, width: 100.0, height: 70.0) //Image size here

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setFillColor(gray: 1.0, alpha: 1.0)
        context.fill(rect)


        let pdfTransform = page.getDrawingTransform(CGPDFBox.mediaBox, rect: rect, rotate: 0, preserveAspectRatio: true)
        context.concatenate(pdfTransform)
        context.drawPDFPage(page)

        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        context.restoreGState()

        UIGraphicsEndImageContext()

        return thumbImage
    }
}
