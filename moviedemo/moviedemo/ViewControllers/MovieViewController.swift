//
//  MovieViewController.swift
//  moviedemo
//
//  Created by Customer Support on 7/29/21.
//

import UIKit

class MovieViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    var searchedData: [SearchResult] = []
    var imageData: ImageConfig?
    var imagePathURL: String?
    var currentPage = 1
    var selectedMovieImagePath: String?
    var isInProgressRetrievingMore: Bool = false
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Popular Movies"

        activityIndicator.startAnimating()
    
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        ServiceAPI.shared.fetchConfiguration{ (result: Result<ConfigurationResponse, ServiceAPI.APIServiceError>) in
            switch result {
              case .success(let configResults):
                self.imageData = configResults.images
                if let baseUrl = self.imageData?.base_url, let logoSize = self.imageData?.logo_sizes[0] {
                    self.imagePathURL = baseUrl + logoSize
                }
                
              case .failure(let error):
                self.imageData = nil
                
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        ServiceAPI.shared.fetchPopular(for: 1) { (result: Result<SearchResponse, ServiceAPI.APIServiceError>) in
            switch result {
              case .success(let searchResults):
                self.searchedData.append(contentsOf: searchResults.results)// searchResults.results
                
              case .failure(let error):
                self.searchedData = []
                
                print(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.movieTableView.reloadData()
        }
        
        dispatchGroup.notify(queue: .main, work: requestWorkItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = movieTableView.indexPathForSelectedRow else { return }
        
        if segue.identifier == "ShowDetails" {
            if let detailViewController = segue.destination as? DetailsViewController {
                let movie = searchedData[indexPath.row]
                detailViewController.selectedMovie = movie
                
                if let imagePath = imagePathURL {
                    selectedMovieImagePath = imagePath + movie.poster_path
                }
                detailViewController.movieImagePathURL = selectedMovieImagePath
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let visibleRows = movieTableView.indexPathsForVisibleRows, visibleRows.count > 0 else { return }
        
        let lastrow = visibleRows[visibleRows.count - 1].row
        if lastrow == (searchedData.count - 1) && !isInProgressRetrievingMore {
            isInProgressRetrievingMore = true
            currentPage += 1
            activityIndicator.startAnimating()
            ServiceAPI.shared.fetchPopular(for: currentPage) { (result: Result<SearchResponse, ServiceAPI.APIServiceError>) in
                switch result {
                    case .success(let searchResults):
                      self.searchedData.append(contentsOf: searchResults.results)
                      
                    case .failure(let error):
                      print(error.localizedDescription)
                }
                DispatchQueue.main.async() {
                    self.activityIndicator.stopAnimating()
                    self.movieTableView.reloadData()
                    self.isInProgressRetrievingMore = false
                }
            }
        }
    }
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let isReachingEnd = scrollView.contentOffset.y >= 0
          && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        
        if isReachingEnd {
            currentPage += 1
            ServiceAPI.shared.fetchPopular(for: currentPage) { (result: Result<SearchResponse, ServiceAPI.APIServiceError>) in
                switch result {
                  case .success(let searchResults):
                    self.searchedData = searchResults.results
                    
                  case .failure(let error):
                    self.searchedData = []
                    
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async() {
                    self.activityIndicator.stopAnimating()
                    self.movieTableView.reloadData()
                }
            }
        }
    }*/
}

extension MovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedData.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie = searchedData[indexPath.row]
        cell.titleLabel.text = movie.title
        cell.scoreLabel.text = "\(movie.popularity)"
        cell.yearLabel.text = movie.release_date
        if let imagePath = imagePathURL {
            cell.iconView.loadThumbnail(urlSting: imagePath + movie.poster_path)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
