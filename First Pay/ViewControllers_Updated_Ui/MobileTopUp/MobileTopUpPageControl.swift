//
//  MobileTopUpPageControl.swift
//  First Pay
//
//  Created by Apple on 23/05/2023.
//  Copyright © 2023 FMFB Pakistan. All rights reserved.
//

import UIKit

class MobileTopUpPageControl: UIViewController , UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    @IBOutlet weak var imgPostpaid: UIImageView!
    @IBOutlet weak var imgPrepaid: UIImageView!
    
    @IBOutlet weak var vcontainer: UIView!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var buttonPrepaid: UIButton!
    @IBAction func buttonPrepaid(_ sender: Any) {
        currentIndex = currentIndex! - 1
        if currentIndex! < 0 {
            currentIndex = 0
            return
        }
        let arr : [UIViewController] = [arrvc[currentIndex!]]
        pagecontaner.setViewControllers(arr,
                                        direction: UIPageViewController.NavigationDirection.reverse,
                                        animated: true,
                                        completion: nil)
        pagecontrol.currentPage = currentIndex!
        
        imgPostpaid.isHidden = true
        imgPrepaid.isHidden = false
    }
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    @IBOutlet weak var buttonPostpaid: UIButton!
    @IBAction func buttonPostpaid(_ sender: Any) {
        currentIndex = currentIndex! + 1
        if currentIndex! > 1 {
            currentIndex = 1
            return
        }
        let arr : [UIViewController] = [arrvc[currentIndex!]]
        pagecontaner.setViewControllers(arr,
                                        direction: UIPageViewController.NavigationDirection.forward,
                                        animated: true,
                                        completion: nil)
        pagecontrol.currentPage = currentIndex!
        imgPostpaid.isHidden = false
        imgPrepaid.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        obj.addNavShadow(viewController: self)

        // Do any additional setup after loading the view.
        pagecontrlfunc()
        
        imgPostpaid.isHidden = true
        imgPrepaid.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    ////Start PC
    var pagecontaner : UIPageViewController!
    var arrvc = [UIViewController]()
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    func pagecontrlfunc()
    {
        
        
        
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//
//            case 1136:
//                print("iPhone 5 or 5S or 5C")
//                bgv.image = UIImage.init(named: "SE")
//            case 1334:
//                print("iPhone 6/6S/7/8")
//                bgv.image = UIImage.init(named: "6")
//            case 1920, 2208:
//                bgv.image = UIImage.init(named: "6Plus")
//                print("iPhone 6+/6S+/7+/8+")
//
//            case 2436:
//                print("iPhone X, XS")
//
//            case 2688:
//                print("iPhone XS Max")
//
//            case 1792:
//                print("iPhone XR")
//
//            default:
//                print("Unknown")
//            }
//        }
        //Title
       
        let page: UIViewController! = UIStoryboard.init(name: "TopUp", bundle: nil).instantiateViewController(withIdentifier: "MobileTopUpVC")
        let page1: UIViewController! = UIStoryboard.init(name: "TopUp", bundle: nil).instantiateViewController(withIdentifier: "MobileTopUpVC")
        
        
        arrvc.append(page)
        arrvc.append(page1)
//        arrvc.append(page2)
//        arrvc.append(page3)
        currentIndex = 0
        // Create the page container
        pagecontaner = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pagecontaner.delegate = self
        pagecontaner.dataSource = self
        pagecontaner.setViewControllers([arrvc[currentIndex!]], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        
        pagecontaner.view.frame = vcontainer.frame
       
        // Add it to the view
        vcontainer.addSubview(pagecontaner.view)
        pagecontaner.view.frame.origin.x = 0
        pagecontaner.view.frame.origin.y = 0

        pagecontrol.numberOfPages = arrvc.count
        pagecontrol.currentPage = 0
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let currentIndex = arrvc.firstIndex(of: viewController)!
        //Left to Right
        //For title of the page in the navigation bar
        if currentIndex == 0
        {
            //self.title = "Featured"
            
        }
        if currentIndex == 1
        {
            //self.title = "Follow"
            
        }
        if currentIndex == 2
        {
            //self.title = "Rank"
           
        }
        imgPostpaid.isHidden = true
        imgPrepaid.isHidden = false
        if currentIndex == 0
        {
            pagecontrol.currentPage = currentIndex
            return nil
        }
        pagecontrol.currentPage = currentIndex
        let previousIndex = abs((currentIndex - 1) % arrvc.count)
        
        
        return arrvc[previousIndex]
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let currentIndex = arrvc.firstIndex(of: viewController)!
        //Right to left swipe
        //For title of the page in the navigation bar
        if currentIndex == 0
        {
            //self.title = "Featured"
            
        }
        if currentIndex == 1
        {
            //self.title = "Follow"
            
        }
        if currentIndex == 2
        {
            //self.title = "Friends"
           
        }
        imgPostpaid.isHidden = false
        imgPrepaid.isHidden = true
        if currentIndex == arrvc.count-1
        {
            pagecontrol.currentPage = currentIndex
            return nil
        }
        
        pagecontrol.currentPage = currentIndex
        let nextIndex = abs((currentIndex + 1) % arrvc.count)
        
       
        return arrvc[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        pendingIndex = arrvc.firstIndex(of:pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed
        {
            currentIndex = pendingIndex
            //                if let index = currentIndex
            //                {
            //                    //pageControl.currentPage = index
            //                }
        }
    }

}
