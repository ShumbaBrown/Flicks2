//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Shumba Brown on 1/7/17.
//  Copyright © 2017 Shumba Brown. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var TableView: UITableView!
    @IBOutlet weak var NetworkErrorView: UIView!
    
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    var refreshControl: UIRefreshControl!
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkErrorView.isHidden = true
        
        refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl: )), for: UIControlEvents.valueChanged)
        TableView.insertSubview(refreshControl, at: 0)
        
        
        TableView.dataSource = self
        TableView.delegate = self
        searchBar.delegate = self
        
        
        networkRequest()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MoviesCell
        
        let movie = filteredMovies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        if let posterPath =  movie["poster_path"] as? String {
            
            let imageURL = NSURL(string: baseURL + posterPath)
            cell.moviePoster.alpha = 0.0
            cell.moviePoster.setImageWith(imageURL as! URL)
            
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                cell.moviePoster.alpha = 1.0
            })
        }
        else {
            NetworkErrorView.isHidden = false
            // code to reveal the network error message
        }
        
        
    
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest()
        
    }
    
    func networkRequest() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let apiKey = "5efd3f2351521121601ddf0b9a208d2e"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredMovies = self.movies
                    
                    self.refreshControl.endRefreshing()
                    self.TableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
        
        
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies?.filter({ (movie: NSDictionary) -> Bool in
                if let title = movie["title"] as? String {
                    if title.range(of: searchText, options: .caseInsensitive) != nil {
                        
                        return  true
                    } else {
                        return false
                    }
                }
                return false
            })
        }
        self.TableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredMovies = movies
        self.TableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = TableView.indexPath(for: cell)
        let movie = filteredMovies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
