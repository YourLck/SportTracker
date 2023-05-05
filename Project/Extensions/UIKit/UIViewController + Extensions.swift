
import UIKit

extension UIViewController {
    
    func presentSimpleAlert(title: String, massage: String?) {
        
        let alertController = UIAlertController(title: title,
                                                message: massage,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }


    func presentAlertWithActions(title: String, massage: String?, completionHandler: @escaping() -> Void) {
    
        let alertController = UIAlertController(title: title,
                                                message: massage,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default){_ in
            completionHandler()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    
    }
    
    func alertPhotoOrCamera(copletionHandler: @escaping (UIImagePickerController.SourceType) -> Void) {
        
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default){_ in
            let camera = UIImagePickerController.SourceType.camera
            copletionHandler(camera)
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default){_ in
            let photoLibrary = UIImagePickerController.SourceType.photoLibrary
            copletionHandler(photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
