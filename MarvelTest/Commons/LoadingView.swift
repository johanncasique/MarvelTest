//
//  LoadingView.swift
//  MarvelTest
//
//  Created by johann casique on 25/10/20.
//

import UIKit

public class LoadingView: UIActivityIndicatorView {
    public override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static let shared = LoadingView.init(style: .large)
    
    func show(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        startAnimating()
        hidesWhenStopped = true
    }
    
    func hide() {
        stopAnimating()
    }
}

