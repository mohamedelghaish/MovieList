//
//  AddMovieViewController.swift
//  Day2Lab2MovieList
//
//  Created by Mohamed Kotb Saied Kotb on 25/04/2024.
//

import UIKit

class AddMovieViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var genreTextField: UITextField!
    
    
    @IBOutlet weak var releaseYearTextField: UITextField!
    
    @IBOutlet weak var urlTextField: UITextField!
    
    
    @IBOutlet weak var ratingTextField: UITextField!
    
    weak var delegate: AddMovieDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func veiwGallary(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.image = pickedImage
            }
            dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func doneButton(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let genre = genreTextField.text, !genre.isEmpty,
              let releaseYearText = releaseYearTextField.text, !releaseYearText.isEmpty,
              let releaseYear = Int(releaseYearText),
              let ratingText = ratingTextField.text, !ratingText.isEmpty,
              let rating = Double(ratingText),
              let url = urlTextField.text, !url.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
              guard let image = imageView.image else {
                    // Show an alert to inform the user to fill all fields
                    return
                }
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                    // Show an alert for image conversion error
                    return
                }
        
        if !releaseYearText.trimmingCharacters(in: .whitespaces).isEmpty, releaseYear == nil {
            showAlert(message: "Release year must be a number.")
            return
        }
        
        if !ratingText.trimmingCharacters(in: .whitespaces).isEmpty, rating == nil {
            showAlert(message: "Rating must be a number.")
            return
        }
        
//        let movie = Movie(title: name, image: "", releaseYear: releaseYear, genre: [genre], rating: rating, url: url)
//        
//        delegate?.addMovie(movie)
        let success = DatabaseManager.shared.insertMovie(title: name,imageData: imageData, releaseYear: releaseYear, genre: genre, rating: rating, url: url)
            
            if success {
                navigationController?.popViewController(animated: true)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Failed to add movie to database", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        //navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
