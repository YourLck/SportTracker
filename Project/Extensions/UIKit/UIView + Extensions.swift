
import UIKit

extension UIView {
    
    func addShadowOnView() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSizeMake(0.0, 3.0)
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1.0
    }
}
