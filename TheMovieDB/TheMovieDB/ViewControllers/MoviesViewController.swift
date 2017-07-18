//
//  MoviesViewController.swift
//  TheMovieDB
//
//  Created by altaibayar tseveenbayar on 18/07/2017.
//  Copyright © 2017 tsevealt. All rights reserved.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var refreshControl: UIRefreshControl = {
        let result = UIRefreshControl();
        result.tintColor = UIColor.tintColor;
        result.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: [ NSForegroundColorAttributeName: UIColor.tintColor ]);
        result.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged);

        return result;
    }();

    var content: [MovieModel] = [];
    let movieDataSource: MoviesDataSource = TheMovieDBMoviesDataSource();
    var currentPage: Int = 0;

    override func viewDidLoad() {
        super.viewDidLoad();

        self.view.backgroundColor = UIColor.backgroundColor;
        self.collectionView.backgroundColor = UIColor.backgroundColor;

        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.tintColor = UIColor.tintColor;
        self.navigationController?.navigationBar.barTintColor = UIColor.backgroundColor;
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.tintColor,
            NSBackgroundColorAttributeName: UIColor.backgroundColor];

        self.collectionView.refreshControl = self.refreshControl;
        fetchNextPage();
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();

        self.collectionView.contentInset = UIEdgeInsets(top: self.view.layoutMargins.left, left: 0,
                                                        bottom: self.view.layoutMargins.left, right: 0);
    }
}

//mark: - actions
extension MoviesViewController {
    func pullToRefresh() {
        self.currentPage = 0;
        fetchNextPage();
    }

    fileprivate func fetchNextPage() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        movieDataSource.fetchMovies(page: currentPage + 1) { [weak self] (movies, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;

            if error == .none {
                guard let strongSelf = self else {
                    return;
                }

                strongSelf.refreshControl.endRefreshing();

                if strongSelf.currentPage == 0 {
                    strongSelf.content.removeAll();
                }

                strongSelf.currentPage += 1;
                strongSelf.content.append(contentsOf: movies);
                strongSelf.collectionView.reloadData();
            }
        }
    }
}

//mark: - segue
extension MoviesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movie = sender as? MovieModel else {
            assert(false, "Sender must be a movie model");
            return;
        }

        guard let vc = segue.destination as? MovieDetailViewController else {
            assert(false, "Segue destination is not a movie detail");
            return;
        }

        vc.currentMovie = movie;
        vc.dataSource = self.movieDataSource;
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let cell = sender as? MoviesCollectionViewCell else {
            assert(false, "Sender must be a cell");
            return false;
        }

        guard let movie = cell.currentMovie else {
            assert(false, "cell must have a movie");
            return false;
        }

        guard let id = movie.id else {
            assert(false, "movie must have an id");
            return false;
        }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        movieDataSource.fetchMovieDetail(movieId: id) { [weak self] (newMovie: MovieModel?, error: NSError?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            if let newMovie = newMovie {
                self?.performSegue(withIdentifier: "continue", sender: newMovie);
            }
        }

        return false;
    }
}

//mark: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.content.count;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MoviesCollectionViewCell ??
            MoviesCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 100));

        let movie = self.content[indexPath.row];
        cell.bindData(movie: movie);

        if let url = movie.imageUrl, let id = movie.id {

            cell.tag = id;
            self.movieDataSource.fetchMoviePoster(moviePosterPath: url, tag: id, completion: { [weak cell] (tag, img, error) in

                if cell?.tag == tag {
                    cell?.imageView.image = img;
                }
            })
        }
        return cell;
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.content.count - 1 {
            fetchNextPage();
        }
    }
}

//mark: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cellWidth = (collectionView.frame.width - flowLayout.minimumInteritemSpacing ) / 2;
            return CGSize(width: cellWidth, height: cellWidth * 1.5)
        }

        return CGSize(width: 100, height: 100 * 1.5);
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero;
    }
}

