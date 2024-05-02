//
//  MovieTableViewController.swift
//  Day2Lab2MovieList
//
//  Created by Mohamed Kotb Saied Kotb on 24/04/2024.
//

import UIKit

class MovieTableViewController: UITableViewController, AddMovieDelegate {
    
    
    
    
    var movies: [Movie] = [
//        Movie(title: "The Shawshank Redemption", image: "shawshank_redemption.jpeg", releaseYear: 1994, genre: ["Drama"], rating: 5.0,url: ""),
//        Movie(title: "The Godfather", image: "godfather.jpeg", releaseYear: 1972, genre: ["Crime", "Drama"], rating: 4.9,url: ""),
//        Movie(title: "The Dark Knight", image: "dark_knight.jpeg", releaseYear: 2008, genre: ["Action", "Crime", "Drama"],rating: 4.5,url: ""),
//        Movie(title: "Pulp Fiction", image: "pulp_fiction.jpeg", releaseYear: 1994, genre: ["Crime", "Drama"],rating: 4.0,url: ""),
//        Movie(title: "Forrest Gump", image: "forrest_gump.jpeg", releaseYear: 1994, genre: ["Drama", "Romance"],rating: 4.5,url: "")
        ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        setupNavigationBar()
        fetchMoviesFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMoviesFromDatabase()
    }
    
    func fetchMoviesFromDatabase() {
            // Fetch movies from database
            movies = DatabaseManager.shared.getAllMovies()
            tableView.reloadData()
        }
    private func setupNavigationBar() {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
            navigationItem.rightBarButtonItem = addButton
        }
    
    
    @objc private func addButton() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let addMovieViewController = storyboard.instantiateViewController(withIdentifier: "AddMovieViewController") as? AddMovieViewController {
                addMovieViewController.delegate = self
                navigationController?.pushViewController(addMovieViewController, animated: true)
            }
        }
    
    func addMovie(_ movie: Movie) {
        print("Adding movie: \(movie)")
        movies.append(movie)
        tableView.reloadData()
        print("Movies array after adding: \(movies)")
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)

        // Configure the cell...
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
//        cell.imageView?.sd_setImage(with: URL(string: movie.url), placeholderImage: UIImage(named: "man.png"))
//        print(movie.title)
        
        if let imageData = movie.image, let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = UIImage(named: "man") // Placeholder image if no image data is available
        }
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movieToDelete = movies[indexPath.row]
            DatabaseManager.shared.deleteMovie(title: movieToDelete.title)
            
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let movieDetailViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            movieDetailViewController.movie = selectedMovie
            movieDetailViewController.cosmosView.rating = movies[indexPath.row].rating
            present(movieDetailViewController, animated: true, completion: nil)
        }

        }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
