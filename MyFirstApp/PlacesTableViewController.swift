//
//  PlacesTableViewController.swift
//  MyFirstApp
//
//  Created by Павел Афанасьев on 15.07.2022.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var currentPlace: Place?
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var typeName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector (textFiledChanged), for: .editingChanged)
        setupEditScreen()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraImage = UIImage(named: "camera")
            let albumImage = UIImage(named: "photo")
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.imagePicker(source: .camera)
            }
            
            cameraAction.setValue(cameraImage, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            
            let albumAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
                self.imagePicker(source: .photoLibrary)
            }
            
            albumAction.setValue(albumImage, forKey: "image")
            albumAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(cameraAction)
            alertController.addAction(albumAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    func saveNewPlace() {
        
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!, location: locationName.text, type: typeName.text, imageData: imageData)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            locationName.text = currentPlace?.location
            typeName.text = currentPlace?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
}

//  MARK: - Text Field Delegate

//  Закрываем клавиатуру по нажатию на Done
extension PlacesTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFiledChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//  MARK: - Work with imagePicker

//  Выбор способа добавления фото к профилю заведения при добавлении
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
        
        imageIsChanged = true
        dismiss(animated: true)
    }
}
