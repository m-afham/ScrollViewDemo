//
//  ViewController.swift
//  ScrollApp
//
//  Created by M Afham on 27/07/2022.
//

import UIKit

class ExampleViewController: UIViewController {
    
    
    lazy var imageScrollView: UIScrollView = {
        let sv = UIScrollView.init()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.frame = self.view.bounds.insetBy(dx: 20, dy: 150)
        sv.center = self.view.center
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 5
        sv.layer.cornerRadius = 10
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .init(named: "Lifetime")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var backgroundBlurredImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .init(named: "Lifetime")
        iv.frame = self.view.bounds
        iv.contentMode = .scaleAspectFill
        iv.applyBlurEffect()
        return iv
    }()
    
    @IBAction func handleSave(_ sender: Any) {
        saveState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBlurBackgroundImageView()
        addScrollView()
        restoreState()
    }
    
    func addScrollView() {
        imageScrollView.addSubview(imageView)
        imageView.frame = imageScrollView.bounds
        self.view.addSubview(imageScrollView)
    }

    
    func addBlurBackgroundImageView() {
        self.view.addSubview(backgroundBlurredImageView)
        backgroundBlurredImageView.layer.zPosition = -1
    }

    
    
    func restoreState() {
        guard let zoomScale = UserDefaults.zoomScale,
              let contentOffset = UserDefaults.contentOffset else {
            return
        }
        imageScrollView.setZoomScale(zoomScale, animated: false)
        imageScrollView.setContentOffset(contentOffset, animated: false)
    }
    
    func saveState() {
        UserDefaults.zoomScale = imageScrollView.zoomScale
        UserDefaults.contentOffset = imageScrollView.contentOffset
    }
}

extension ExampleViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
}

extension UserDefaults {
    static var zoomScale: CGFloat? {
        get {
            CGFloat(UserDefaults.standard.value(forKey: "zoom") as? Float ?? 1.0)
        }set{
            guard let newVal = newValue else { return }
            UserDefaults.standard.set(Float(newVal), forKey: "zoom")
        }
    }
    
    static var contentOffset: CGPoint? {
        get {
            if let offsetStr = standard.value(forKey: "contentOffset") as? String{
                return NSCoder.cgPoint(for: offsetStr)
            }
            return .zero
        }set{
            guard let newVal = newValue else { return }
            let pointAsString = NSCoder.string(for: newVal)
            UserDefaults.standard.set(pointAsString,forKey: "contentOffset")
        }
    }
}

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
