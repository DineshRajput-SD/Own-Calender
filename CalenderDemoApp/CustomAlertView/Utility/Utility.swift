//
//  Util.swift

//

import UIKit
import AVFoundation

class Utility: NSObject {
    
    // MARK: - *******Alert Methods*******
    class func showNetWorkAlert() {
        showAlertWithMessage(NSLocalizedString("CHECK_CONNECTION_ALERT", comment: ""), title:NSLocalizedString("NO_NETWORK_ALERT", comment: ""))
    }
    
    class func showAlertWithMessage(_ message: String, title: String, handler:(() -> ())? = nil) {
        DispatchQueue.main.async {
            //** If any Alert view is alrady presented then do not show another alert
            var viewController : UIViewController!
//            if let vc  = UIApplication.currentViewController() {
//                if (vc.isKind(of: UIAlertController.self)) {
//                    return
//                } else {
//                    viewController = vc
//                }
//            } else {
//                viewController = appDelegate.window?.rootViewController!
//            }
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.fonts(message: message, title: title)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (_) in
                handler?()
            }))
            viewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    class func showAlertWithMessage(_ message: String, title: String, cancelBtn: String, okBtn: String, handler: @escaping(Int) -> Void) {
        DispatchQueue.main.async {
            // ** If any Alert view is already presented then do not show another alert
            var viewController : UIViewController!
//            if let vc  = UIApplication.currentViewController() {
//                if (vc.isKind(of: UIAlertController.self)) {
//                    return
//                } else {
//                    viewController = vc
//                }
//            } else {
//                viewController = appDelegate.window?.rootViewController!
//            }
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alert.fonts(message: message, title: title)
            if cancelBtn != ""{
                alert.addAction(UIAlertAction(title: cancelBtn, style: .default, handler: { (action) in
                    handler(1)
                }))
            }
            if okBtn != "" {
                alert.addAction(UIAlertAction(title: okBtn, style: .default, handler: { (action) in
                    handler(2)
                }))
            }
            viewController!.present(alert, animated: true, completion: nil)
        }
    }
    
//    class func showDebugVersionAlert() {
//        if
//            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
//            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
//            let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
//            
//            let title = "\(displayName)"
//            #if CLIENT
//            let buildType = "Client"
//            #else
//            let buildType = "Enterprise"
//            #endif
//            let baseUrl = AppHostURL.base
//            let message = "Version:\(version)(\(build))\nBuildType:\(buildType)\nBaseURL:\(baseUrl)"
//            Utility.showAlertWithMessage(message, title: title)
//        }
//    }
}

extension UIAlertController {
    func fonts(message: String, title: String) {
        self.title = title
        self.message = message
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
