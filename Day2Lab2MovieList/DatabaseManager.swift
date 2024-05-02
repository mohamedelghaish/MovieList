//
//  DatabaseManager.swift
//  Day2Lab2MovieList
//
//  Created by Mohamed Kotb Saied Kotb on 28/04/2024.
//

import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let dbPath: String
    private var db: OpaquePointer?

    private init() {
        
        let fileManager = FileManager.default
        guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not access documents directory.")
        }
        self.dbPath = documentsUrl.appendingPathComponent("movies.sqlite").path
        
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            fatalError("Error opening database.")
        }
        
        // Create the movies table if it doesn't exist
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS movies (
                title char(255) PRIMARY KEY ,
                imageData BLOB,
                releaseYear INTEGER,
                genre char(255),
                rating double,
                url TEXT
            );
            """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            fatalError("Error creating table: \(errorMessage)")
        }
    }
    
    deinit {
        
        sqlite3_close(db)
    }

    
    func insertMovie(title: String, imageData:Data,  releaseYear: Int, genre: String, rating: Double, url: String) -> Bool {
           
            let insertStatementString = "INSERT INTO movies (title,imageData,  releaseYear, genre, rating, url) VALUES (?,?, ?, ?, ?, ?);"
        
            var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK{
                        sqlite3_bind_text(insertStatement, 1, ((title as NSString)).utf8String, -1, nil)
                        
                        sqlite3_bind_blob(insertStatement, 2, (imageData as NSData).bytes, Int32(imageData.count), nil)
                        
                        sqlite3_bind_int(insertStatement, 3, Int32(releaseYear))
            
                        sqlite3_bind_text(insertStatement, 4, ((genre as NSString)).utf8String, -1, nil)
            
                        sqlite3_bind_double(insertStatement, 5, rating)
            
                        sqlite3_bind_text(insertStatement, 6, url, -1, nil)
        } else {
                print("Error preparing insert statement")
                return false
            }
            
            
            
            // Execute the statement
            if sqlite3_step(insertStatement) != SQLITE_DONE {
                print("Error inserting movie into database")
                return false
            }
            
            // Finalize the statement and return success
            sqlite3_finalize(insertStatement)
            return true
        }
    func getAllMovies() -> [Movie] {
           var movies = [Movie]()
           
           // Prepare the SELECT statement
           let queryStatementString = "SELECT * FROM movies;"
           var queryStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let title = String(cString: sqlite3_column_text(queryStatement, 0))
                guard let imageDataBlob = sqlite3_column_blob(queryStatement, 1) else {
                                    continue
                                }
                let imageDataBytes = sqlite3_column_bytes(queryStatement, 1)
                let imageData = Data(bytes: imageDataBlob, count: Int(imageDataBytes))
                let releaseYear = Int(sqlite3_column_int(queryStatement, 2))
                let genre = String(cString: sqlite3_column_text(queryStatement, 3))
                let rating = Double(sqlite3_column_double(queryStatement, 4))
                // Inside your database retrieval logic
                    guard let urlCString = sqlite3_column_text(queryStatement, 5) else {
                        // Handle the case when the value is nil
                        print("URL is nil")
                        // You need to return an empty array or handle this case appropriately
                        return [] // Return an empty array of Movie
                    }

                    let url = String(cString: urlCString)
                
                // Create a movie object and add it to the array
                let movie = Movie( title: title,image: imageData, releaseYear: releaseYear, genre: genre, rating: rating, url: url)
                movies.append(movie)
            }

        } else {
               print("Error preparing select statement")
               return []
           }
           
           
           sqlite3_finalize(queryStatement)
           return movies
       }
    func deleteMovie(title: String) {
        let deleteStatementString = "DELETE FROM movies WHERE title = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (title as NSString).utf8String, -1, nil)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted movie: \(title)")
            } else {
                print("Failed to delete movie: \(title)")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
    }
}
