//
//  MenuBar.swift
//  Spotify
//
//  Created by Mitya Kim on 8/25/22.
//

import Foundation
import UIKit

protocol MenuBarDelegate: AnyObject {
    func didSelectItemAt(index: Int)
}

class MenuBar: UIView {
    
    let playlistsButton: UIButton!
    let artistsButton: UIButton!
    let albumsButton: UIButton!
    let buttons: [UIButton]!
    
    let indicator = UIView()
    var indicatorLeading: NSLayoutConstraint?
    var indicatorTrailing: NSLayoutConstraint?
    let leadPadding: CGFloat = 16
    let buttonSpace: CGFloat = 36
    
    weak var delegate: MenuBarDelegate?
    
    override init(frame: CGRect) {
        playlistsButton = makeButton(withText: "Playlist")
        artistsButton = makeButton(withText: "Artists")
        albumsButton = makeButton(withText: "Albums")
        
        buttons = [playlistsButton, artistsButton, albumsButton]
        
        super.init(frame: .zero)
        
        playlistsButton.addTarget(self, action: #selector(playlistsButtonTapped), for: .primaryActionTriggered)
        artistsButton.addTarget(self, action: #selector(artistsButtonTapped), for: .primaryActionTriggered)
        albumsButton.addTarget(self, action: #selector(albumsButtonTapped), for: .primaryActionTriggered)
        
        setAlpha(for: playlistsButton)
        
        styleIndicator()
        
        layout()
    }
    
    private func styleIndicator() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.backgroundColor = .spotifyGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(playlistsButton)
        addSubview(artistsButton)
        addSubview(albumsButton)
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            // buttons
            playlistsButton.topAnchor.constraint(equalTo: topAnchor),
            playlistsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadPadding),
            
            artistsButton.topAnchor.constraint(equalTo: topAnchor),
            artistsButton.leadingAnchor.constraint(equalTo: playlistsButton.trailingAnchor, constant: buttonSpace),
            
            albumsButton.topAnchor.constraint(equalTo: topAnchor),
            albumsButton.leadingAnchor.constraint(equalTo: artistsButton.trailingAnchor, constant: buttonSpace),
            
            // bar
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 3)
            
        ])
        
        indicatorLeading = indicator.leadingAnchor.constraint(equalTo: playlistsButton.leadingAnchor)
        indicatorTrailing = indicator.trailingAnchor.constraint(equalTo: playlistsButton.trailingAnchor)
        
        indicatorLeading?.isActive = true
        indicatorTrailing?.isActive = true
    }
}

// MARK: - Actions
extension MenuBar {
    @objc func playlistsButtonTapped() {
        delegate?.didSelectItemAt(index: 0)
        setAlpha(for: playlistsButton)
    }
    
    @objc func artistsButtonTapped() {
        delegate?.didSelectItemAt(index: 1)
        setAlpha(for: artistsButton)
    }
    
    @objc func albumsButtonTapped() {
        delegate?.didSelectItemAt(index: 2)
        setAlpha(for: albumsButton)
    }
}
 
extension MenuBar {
    
    func selectItem(at index: Int) {
        animateIndecator(to: index)
    }
    
    private func animateIndecator(to index: Int) {
        
        var button: UIButton
        switch index {
        case 0:
            button = playlistsButton
        case 1:
            button = artistsButton
        case 2:
            button = albumsButton
        default:
            button = playlistsButton
        }
        
        setAlpha(for: button)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    private func setAlpha(for button: UIButton) {
        playlistsButton.alpha = 0.5
        artistsButton.alpha = 0.5
        albumsButton.alpha = 0.5
        
        button.alpha = 1.0
    }
    
    func scrollIndecator(to contentOffset: CGPoint) {
        let index = Int(contentOffset.x / frame.width)
        let atScrollStart = Int(contentOffset.x) % Int(frame.width) == 0
        
        if atScrollStart {
            return
        }
        
        let percentScrolled: CGFloat
        switch index {
        case 0:
            percentScrolled = contentOffset.x / frame.width - 0
        case 1:
            percentScrolled = contentOffset.x / frame.width - 1
        case 2:
            percentScrolled = contentOffset.x / frame.width - 2
        default:
            percentScrolled = contentOffset.x / frame.width
        }
        
        var fromButton: UIButton
        var toButton: UIButton
        
        switch index {
        case 2:
            fromButton = buttons[index]
            toButton = buttons[index - 1]
        default:
            fromButton = buttons[index]
            toButton = buttons[index + 1]
        }
        
        switch index {
        case 2:
            break
        default:
            fromButton.alpha = fmax(0.5, (1 - percentScrolled))
            toButton.alpha = fmax(0.5, percentScrolled)
        }
        
        let fromWidth = fromButton.frame.width
        let toWidth = toButton.frame.width
        
        let sectionWidth: CGFloat
        switch index {
        case 0:
            sectionWidth = leadPadding + fromWidth + buttonSpace
        default:
            sectionWidth = fromWidth + buttonSpace
        }
        
        let sectionFraction = sectionWidth / frame.width
        let x = contentOffset.x * sectionFraction
        
        let buttonWidthDiff = fromWidth - toWidth
        let widthOffset = buttonWidthDiff * percentScrolled
        
        let y: CGFloat
        switch index {
        case 0:
            if x < leadPadding {
                y = x
            } else {
                y = x - leadPadding * percentScrolled
            }
        case 1:
            y = x + 13
        case 2:
            y = x
        default:
            y = x
        }
        
        indicatorLeading?.constant = y
        
        let yTrailing: CGFloat
        switch index {
        case 0:
            yTrailing = y - widthOffset
        case 1:
            yTrailing = y - widthOffset - leadPadding
        case 2:
            yTrailing = y - widthOffset - leadPadding / 2
        default:
            yTrailing = y - widthOffset - leadPadding
        }
        
        indicatorTrailing?.constant = yTrailing
        
        print("\(index) percetScrolled=\(percentScrolled)")
        
    }
}

func makeButton(withText text: String) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    
    return button
}

