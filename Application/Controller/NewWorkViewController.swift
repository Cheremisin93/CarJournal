//
//  NewWorkViewController.swift
//  CarJournal
//
//  Created by Cheremisin Andrey on 06.04.2022.
//

import UIKit
import RealmSwift

class NewWorkViewController: UITableViewController {

//    var newWork: Details?
    var date: String = ""
    var currentWork: Work?
    var imageIsChanged = false
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var workTitle: UITextField!
    @IBOutlet weak var workPrice: UITextField!
    @IBOutlet weak var workDate: UIDatePicker!
    @IBOutlet weak var workMileage: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() //убираем разлинеивание пустых ячеек
        saveButton.isEnabled = false
        
        workTitle.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged) //отслеживание кнопки сохр.
        setupEditScreen()

    }
    private func setupEditScreen() {
        if currentWork != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentWork?.imageData,
                  let image = UIImage(data: data) else { return }
            
            workImage.image = image
            workImage.contentMode = .scaleAspectFill
            workPrice.text = currentWork?.price
            workTitle.text = currentWork?.title
            workMileage.text = currentWork?.milage
//            Date???
            
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = nil
        title = currentWork?.title
        saveButton.isEnabled = true
        
    }
    
    //MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Камера", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            let photo = UIAlertAction(title: "Фото", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(cancel)
            actionSheet.addAction(photo)
            
            present(actionSheet, animated: true)
            
        } else {
            self.view.endEditing(true)
        }
    }
    
    func saveWork() {
        
        var image: UIImage?
        if imageIsChanged {
            image = workImage.image
        } else {
            image = UIImage(named: "details")
        }
        let imageData = image?.pngData()
        
//        guard let dateForm = date else { return }
        
        let newWork = Work(title: workTitle.text!, price: workPrice.text, date: date, milage: workMileage.text, imageData: imageData)
        
        if currentWork != nil {
            try! realm.write({
                currentWork?.title = newWork.title
                currentWork?.price = newWork.price
                currentWork?.milage = newWork.milage
                currentWork?.imageData = newWork.imageData
                currentWork?.date = newWork.date
            })
        } else {
            StorageManager.saveObject(newWork)
        }
        
        
    }
    
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let dateValue = dateFormatter.string(from: sender.date)
        date = dateValue
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

// MARK: Text field delegate
extension NewWorkViewController: UITextFieldDelegate {
    
    // Cкрываем клавиатуру по нажатию done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
     // Отслеживание кнопки сохранения
    @objc private func textFieldChanged() {
        if workTitle.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: Работа с изображением
extension NewWorkViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
         
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
// Сохраняем выбранное фото
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        workImage.image = info[.editedImage] as? UIImage
        workImage.contentMode = .scaleAspectFill
        workImage.clipsToBounds = true
        
        imageIsChanged = true
         
        dismiss(animated: true)
    }
}
