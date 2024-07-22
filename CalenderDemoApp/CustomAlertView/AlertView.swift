//  AlertView.swift

//

import UIKit
extension String {
    func localize() -> String {
      return NSLocalizedString(self, comment: "")
    }
}
enum Alert: String {
    case Ok     = "Ok"
    case Cancel = "Cancel"
    case retry = "Retry"
    
    func localize() -> String {
        return self.rawValue.localize()
    }
}

protocol AlertViewLocalize {
  func localize() -> String
}

extension String: AlertViewLocalize {
   
    
  
}

class AlertView: UIView {
  // MARK: - IBOutlets
  @IBOutlet weak var imgSuccess: UIImageView!
  @IBOutlet weak var constImgHeight: NSLayoutConstraint! // 35
  
  //MARK:- Properties
  @IBOutlet weak var lblTitle: UILabel!
  @IBOutlet weak var lblMessage: UILabel!
  @IBOutlet weak var btnOk: UIButton!
  @IBOutlet weak var btnCancel: UIButton!
  @IBOutlet weak var fitnessAlertBgView: UIView!
  @IBOutlet weak var dialogView: UIView!
  var callBack: ((Int) -> ())?
  
  @discardableResult static func show(message: AlertViewLocalize,  isSuccess: Bool) -> Bool {
    AlertView.show(title: nil, isSuccess: isSuccess,  message: message.localize(), okTitle: NSLocalizedString("OK", comment: ""), cancelTitle: nil)
    return false
  }
    
//    Utility.showAlertWithMessage(LocalizedKey.Validation.validPassword.rawValue.localize(), title: "")
  
//  static func showNetworkError(_ completion: ((Int?) -> ())? = nil) {
//    AlertView.show(title: nil, isSuccess: false, message: LocalizedKey.Validation.internetError.localize(), okTitle: LocalizedKey.Alert.retry.localize(), cancelTitle: nil, callBack: completion)
//  }
//  
  //MARK: - Show
  static func show(title: String?, isSuccess: Bool, message: String?, okTitle: String?, cancelTitle: String?, callBack: ((Int?) -> ())? = nil) {
    DispatchQueue.main.async {
      getAddedView()
      let nib = UINib(nibName: "AlertView", bundle: nil)
      let alertView = nib.instantiate(withOwner: nil, options: nil)[0] as! AlertView
      alertView.frame = UIScreen.main.bounds
      let visibleController = self.topViewController()
      visibleController?.view.addSubview(alertView)
      alertView.lblTitle.text = title ?? ""
      alertView.lblMessage.text = message ?? ""
      alertView.callBack = callBack
      alertView.btnOk.setTitle(okTitle ?? "Ok", for: .normal)
      alertView.btnCancel.setTitle(cancelTitle ?? "Cancel", for: .normal)
      alertView.animate()
      alertView.constImgHeight.constant = isSuccess ? 35.0 : 0.0
      if let cancel = cancelTitle, cancel.count > 0 { return }
      alertView.btnCancel.removeFromSuperview()
    }
  }
  
  //MARK:- Animate
  func animate() {
    self.dialogView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
      self.dialogView.transform = .identity
    }, completion: nil)
  }
  
  // MARK: - remove
  func remove() {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
      self.dialogView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
      self.dialogView.alpha = 0
      self.fitnessAlertBgView.alpha = 0
    }, completion: { isFinished in
      self.removeFromSuperview()
    })
  }
  
  // MARK: - getAddedView
  static func getAddedView() {
    let viewcontroller = AlertView.topViewController()
    if let views = viewcontroller?.view.subviews.filter({$0 is AlertView}) {
      let view = views.first
      view?.removeFromSuperview()
    }
  }
  
  static func topViewController()->UIViewController? {
    var topController : UIViewController?
    topController = UIApplication.shared.keyWindow?.rootViewController
    while let presentedController = topController?.presentedViewController {
      topController = presentedController
    }
    return topController
  }
  
  //MARK:- btnAction_Ok Action
  @IBAction func btnAction_Ok(_ sender: UIButton) {
    remove()
    callBack?(sender.tag)
  }
  
  // MARK: - btnAction_Ok
  @IBAction func btnAction_Cancel(_ sender: UIButton) {
    remove()
    callBack?(sender.tag)
  }
}

/*
 func isTextFieldsValid(phoneNumber: String) -> Bool {
     guard !(phoneNumber.isEmpty) else {
         if phoneNumber.count < 9 {
             return AlertView.show(message:"The phone number must be 9 to 12 digits.", isSuccess: false)
         }
         return AlertView.show(message: "Please enter phone number", isSuccess: false)
     }
     guard phoneNumber.isValid(type: .phone) else  {
         return AlertView.show(message: "Please enter valid phone number", isSuccess: false)
     }
     if phoneNumber.count < 9 {
         return AlertView.show(message:"The phone number must be 9 to 12 digits.", isSuccess: false)
     }
     return true
 }
 */


/*
 
 import UIKit

 public extension UIApplication {
     
     // Returns current Top Most ViewController in hierarchy of Window.
     class func topMostWindowController() -> UIViewController? {
         var topController = UIApplication.shared.keyWindow?.rootViewController
         while let presentedController = topController?.presentedViewController {
             topController = presentedController
         }
         return topController
     }
     
     // Returns the topViewController from stack of topMostWindowController (if in navigation).
     class func currentViewController() -> UIViewController? {
         var currentViewController = UIApplication.topMostWindowController()
         while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
             currentViewController = (currentViewController as! UINavigationController).topViewController
         }
         return currentViewController
     }
 }
 */
