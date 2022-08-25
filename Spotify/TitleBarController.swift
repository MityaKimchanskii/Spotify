//
//  ViewController.swift
//  Spotify
//
//  Created by Mitya Kim on 8/24/22.
//

import UIKit

class MusicViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

class PodcastViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
}

class TitleBarController: UIViewController {
    
    var musicBarButtonItem: UIBarButtonItem!
    var podcastBarButtonItem: UIBarButtonItem!
    
    let container = Container()
    
    let viewControllers: [UIViewController] = [MusicViewController(), PodcastViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupViews()
    }
    
    func setupNavBar() {
        navigationItem.leftBarButtonItems = [musicBarButtonItem, podcastBarButtonItem]
    }
    
    func setupViews() {
        guard let containerView = container.view else { return }
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .systemRed
        
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        musicBarButtonItem = makeBarButtonItem(text: "Music", selector: #selector(musicTapped))
        podcastBarButtonItem = makeBarButtonItem(text: "Podcast", selector: #selector(podcastTapped))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeBarButtonItem(text: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .primaryActionTriggered)
        
        let attr = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits: [.traitBold]),
                    NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        
        let attrText = NSMutableAttributedString(string: text, attributes: attr)
        
        button.setAttributedTitle(attrText, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 16)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        
        return barButtonItem
    }
    
    @objc func musicTapped() {
        if container.children.first == viewControllers[0] { return }
        container.add(viewControllers[0])
        viewControllers[1].remove()
    }
    
    @objc func podcastTapped() {
        if container.children.first == viewControllers[1] { return }
        container.add(viewControllers[1])
        viewControllers[0].remove()
    }
}

extension UIFont {
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

