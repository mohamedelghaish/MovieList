//
//  MovieDetailViewController.swift
//  Day2Lab2MovieList
//
//  Created by Mohamed Kotb Saied Kotb on 24/04/2024.
//

import UIKit
import Cosmos
import SDWebImage
class MovieDetailViewController: UIViewController {
    

    lazy var cosmosView :CosmosView = {
        var view = CosmosView()
        view.settings.updateOnTouch = false
        view.settings.starSize = 40
        view.settings.fillMode = .precise
        return view
    }()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var movie: Movie?
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.addSubview(cosmosView)
        cosmosView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cosmosView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cosmosView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180)
        ])
        
        if let movie = movie {
                    titleLabel.text = movie.title
                    //imageView.image = UIImage(named: movie.image)
                    releaseYearLabel.text = "Release Year: \(movie.releaseYear)"
                    genreLabel.text = "Genre: \(movie.genre.joined(separator: ", "))"
//            imageView.sd_setImage(with: URL(string: movie.url), placeholderImage: UIImage(named: "man.png"))
            if let imageData = movie.image, let image = UIImage(data: imageData) {
                imageView.image = image
            } else {
                imageView.image = UIImage(named: "man") // Placeholder image if no image data is available
            }
            
                }
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
