

import UIKit

class myPickerClass: UIImagePickerController, UINavigationBarDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
    }
}
