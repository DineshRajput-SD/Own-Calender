
//  Loader.swift
//  CalenderDemoApp
//
//  Created by Dinesh Rajput on 29/03/24.
import UIKit

class Loader: UIView {
    
    static var loaderView : Loader!
    
    @IBOutlet weak var imgView : UIImageView?
    @IBOutlet weak var viewBg : UIView?
    @IBOutlet weak var viewContainer : UIView?
    @IBOutlet weak var lblLoaderTitle: UILabel!
    
    class func show() {
        if loaderView != nil {
            return
        }
        
        if Thread.isMainThread {
            Loader.start()
        } else {
            DispatchQueue.main.sync {
                Loader.start()
            }
        }
    }
    
    class private func start(){
        loaderView = UINib(nibName: "Loader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? Loader
        UIApplication.shared.keyWindow?.addSubview(loaderView!)
        loaderView.frame = UIScreen.main.bounds
        loaderView.setupLoaderUI()
        loaderView.showWithAnimation()
    }
    
    func setupLoaderUI() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * Double.pi
        rotation.duration = 0.8
        rotation.repeatCount = Float.infinity
        self.imgView!.layer.add(rotation, forKey: "Spin")
    }
    
    func showWithAnimation() {
        //viewBg?.alpha=0.0
        viewContainer?.transform = CGAffineTransform(scaleX: 0.70, y: 0.70)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            self.viewContainer?.transform = .identity
            //self.viewBg?.alpha=0.2
        }, completion: nil)
    }
    
    class func hide() {
        if Thread.isMainThread {
            loaderView?.removeFromSuperview()
            loaderView = nil
        } else {
            DispatchQueue.main.sync {
                loaderView?.removeFromSuperview()
                loaderView = nil
            }
        }
    }
}


