//
//  ViewController.swift
//  Stretchable image
//
//  Created by aeroclub on 21.11.2024.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "myImage2")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    let contentView = UIView()
    var imageHeightConstraint: NSLayoutConstraint!
    
    let initialImageHeight: CGFloat = 270
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupScrollView()
        setupContent()
    }
    
    func setup() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: initialImageHeight)
        imageHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    func setupContent() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        let newHeight: CGFloat
        
        if offsetY < 0 {
            newHeight = initialImageHeight - offsetY
            imageView.frame.origin.y = 0
        } else {
            newHeight = max(initialImageHeight, initialImageHeight - offsetY)
            imageView.frame.origin.y = -offsetY
        }

        imageView.frame.size.height = newHeight
        
        scrollView.contentInset = UIEdgeInsets(top: newHeight - initialImageHeight, left: 0, bottom: 0, right: 0)
        
        let totalHeight = contentView.frame.height + (newHeight - initialImageHeight)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        
        if offsetY <= 0 {
            resetImageView()
        }
    }
    
    func resetImageView() {
        UIView.animate(withDuration: 0.7) {
            self.imageHeightConstraint.constant = self.initialImageHeight
            self.imageView.frame.origin.y = 0
            self.view.layoutIfNeeded()
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.scrollView.contentSize.height = self.contentView.frame.height
        }
    }
}
