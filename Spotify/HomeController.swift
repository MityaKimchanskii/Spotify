//
//  HomeController.swift
//  Spotify
//
//  Created by Mitya Kim on 8/25/22.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    let menuBar = MenuBar()
    let playlistCellId = "playlistCellId"
    let music: [[Track]] = [playlists, artists, albums]
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PlaylistCell.self, forCellWithReuseIdentifier: playlistCellId)
        cv.backgroundColor = .spotifyBlack
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
            
        return cv
    }()
    
    let colors: [UIColor] = [.systemRed, .systemBlue, .systemMint]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .spotifyBlack
        menuBar.delegate = self
        
        layout()
    }
    
    func layout() {
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(menuBar)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            // menuBar
            menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuBar.heightAnchor.constraint(equalToConstant: 42),
            
            // collectionView
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: menuBar.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 0),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 0)
        ])
    }
}

extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return music.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistCellId, for: indexPath) as! PlaylistCell
        
//        cell.backgroundColor = colors[indexPath.item]
        cell.tracks = music[indexPath.item]
        return cell
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let index = targetContentOffset.pointee.x / view.frame.width
//        menuBar.selectItem(at: Int(index))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.scrollIndecator(to: scrollView.contentOffset)
    }
}

extension HomeController: MenuBarDelegate {
    func didSelectItemAt(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
}
