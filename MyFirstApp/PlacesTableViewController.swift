//
//  PlacesTableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 15.07.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    @IBOutlet weak var placeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.imagePicker(source: .camera)            }
            
            let albomAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
                self.imagePicker(source: .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(cameraAction)
            alertController.addAction(albomAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: - Text Field Delegate
// Закрываем клавиатуру по нажатию на Done

extension PlacesTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Work with imagePicker
// Выбор способа добавления фото к профилю заведения при добавлении

extension PlacesTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        dismiss(animated: true)
    }
}
