//
//  PreviewViewController.swift
//  First Pay
//
//  Created by Arsalan Amjad on 21/01/2022.
//  Copyright © 2022 FMFB Pakistan. All rights reserved.
//

import UIKit
import WebKit
class PreviewViewController: UIViewController {
    public var documentData: Data?
    private var webView: WKWebView!
    private var printButton: UIBarButtonItem!
   
    @IBOutlet weak var webviewk: WKWebView!
    var pdfFile: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        Swift.print("data is ", DataManager.instance.accountTitle)
        self.printButton = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(print))
        self.navigationItem.rightBarButtonItem = self.printButton
        
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        webviewk.addSubview(webView)
//
//        webView.leadingAnchor.constraint(equalTo: webviewk.safeAreaLayoutGuide.leadingAnchor).isActive = true
//        webView.trailingAnchor.constraint(equalTo: webviewk.safeAreaLayoutGuide.trailingAnchor).isActive = true
//        webView.topAnchor.constraint(equalTo: webviewk.safeAreaLayoutGuide.topAnchor).isActive = true
//        webView.bottomAnchor.constraint(equalTo: webviewk.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.webView = WKWebView()
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        //
        
        let viewDict: [String: AnyObject] = [
            "webView": self.webView,
            "top": self.topLayoutGuide
        ]
        let layouts = [
            "H:|[webView]|",
            "V:[top][webView]|"
        ]
        for layout in layouts {
            let constraints = NSLayoutConstraint.constraints(withVisualFormat: layout, options: [], metrics: nil, views: viewDict)
            self.view.addConstraints(constraints)
        }
//        if let data = documentData {
//            webview.document = PDFDocument(data: data)
//            webview.autoScales = true
//        }
        // Do any additional setup after loading the view.
    }
    
    func savePdf(pdfData:Data?, fileName:String) {
            DispatchQueue.main.async {
                let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                let pdfNameFromUrl = "\(fileName).pdf"
                let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                do {
                    try pdfData?.write(to: actualPath, options: .atomic)
//                    Swift.print("pdf successfully saved!")
//                    print(actualPath)
                } catch {
//                    print("Pdf could not be saved")
                }
            }
        }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NSLog("didFinishNavigation")

        // Sometimes, this delegate is called before the image is loaded. Thus we give it a bit more time.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let path = self.createPDF(formatter: webView.viewPrintFormatter(), filename: "MyPDFDocument")
//            print("PDF location: \(path)")
            self.pdfFile = path
//            self.previewButton.isEnabled = true
        }
    }
    @IBAction func download(_ sender: UIButton) {
    
        
        guard let pdfData = documentData else { return }
        
        let vc = UIActivityViewController(
          activityItems: [pdfData],
          applicationActivities: []
        )
//        present(vc, animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }

//        savePdf(pdfData: documentData, fileName: "test")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // If this gives a sandbox error, check:
        // http://stackoverflow.com/a/25973953/1085556
//
        let path =  Bundle.main.path(forResource: "test", ofType: "html")
        let url = URL(fileURLWithPath: path!)
        self.webView.load(URLRequest(url: url))
    }

    @objc func print() {
        let printController = UIPrintInteractionController.shared
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = (self.webView.url?.absoluteString)!
        printInfo.duplex = .none
        printInfo.orientation = .portrait
        
        printController.printPageRenderer = nil
        printController.printingItems = nil
        printController.printingItem = webView.url!
        
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true
        
        printController.present(from: self.printButton, animated: true, completionHandler: nil)
    }
    func createPDF(formatter: UIViewPrintFormatter, filename: String) -> String {
        // From: https://gist.github.com/nyg/b8cd742250826cb1471f
        let html = getHTML()
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        // 2. Assign print formatter to UIPrintPageRenderer
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext()
        
        // 5. Save PDF file
        let path = "\(NSTemporaryDirectory())\(filename).pdf"
        pdfData.write(toFile: path, atomically: true)
//        print("open \(path)")
        
        return path
    }
  
func getHTML() -> String {
    return """
            <p style='margin: 0cm 0cm 0cm 72pt;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-size:24px;line-height: 36px;font-family: Arial, sans-serif;">
            <img src="app_logo-1.png" width="100" height="100">
            The HBL MicroFinanceBank Ltd</span></p>
            <div style="border-style: none none solid;border-bottom-width: 1pt;border-bottom-color: windowtext;padding: 0cm 0cm 1pt;">
                <p style='margin: 0cm;font-size:16px;font-family: "Times New Roman", serif;border: none;padding: 0cm;'>&nbsp; &nbsp;&nbsp;</p>
            </div>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: right;'><span style="font-size:13px;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Date: Date:\(dateString! ?? "")</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;">ACCOUNT MAINTENANCE CERTIFICATE&nbsp;</span></u></strong></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><strong><u><span style="font-family: Calibri, sans-serif;"><span style="text-decoration: none;">&nbsp;</span></span></u></strong></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;line-height: 24px;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-size:15px;font-family: Calibri, sans-serif;">This is to certify that&nbsp;</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> "\(DataManager.instance.accountTitle)" &nbsp; &nbsp;</span></strong><span style="font-size:13px;font-family: Calibri, sans-serif;">having <strong>CNIC   "\(DataManager.instance.userCnic)"  </strong>&nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">is maintaining &nbsp;</span><span style="font-size:15px;font-family: Calibri, sans-serif;">account &nbsp;A/C#</span><strong><span style="font-size:13px;font-family: Calibri, sans-serif;"> "\(DataManager.instance.accountNo)"    &nbsp;</span></strong><span style="font-size:15px;font-family: Calibri, sans-serif;"> <strong></strong></span><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;from <strong></strong></span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;'><span style="font-size:15px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">This certificate is issued on request of the customer without taking any risk and responsibility&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">on undersigned and part of the bank.</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;text-align: justify;line-height: 24px;'><span style="font-size:15px;line-height: 22px;font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">The First MicroFinance Bank Ltd</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">16<sup>th</sup> &amp; 17<sup>th</sup> Floor HBL Tower,</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Blue Area, Islamabad</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">Toll Free 0800-42563</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><span style="font-family: Calibri, sans-serif;">&nbsp;</span></p>
            <p style='margin: 0cm;font-family: "Times New Roman", serif;'><em><span style="font-family: Calibri, sans-serif;">This is a computer generated certificate &amp; don&rsquo;t require any signatures</span></em></p>
    """
}
}
    
    
    
    
    
    
    


