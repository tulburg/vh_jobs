//
//  Notice.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/17/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//


import UIKit

class Notice {
    
    var viewController = UIViewController()
    var viewHolder: UIView!
    var mainView: UIView!
    var backgroundOverlay: UIView!
    var callback: (_ completed: Bool) -> Void!
    var showing: Bool = false
    var controller: UIViewController!
    
    init(_ message: String, type: NoticeType, tap: @escaping (_ completed: Bool) -> Void) {
        viewHolder = UIView()
        mainView = UIView()
        backgroundOverlay = UIView()
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overCurrentContext
        mainView.frame = viewController.view.frame
        mainView.backgroundColor = UIColor.clear
        backgroundOverlay.backgroundColor = UIColor.black
        backgroundOverlay.frame = mainView.frame
        backgroundOverlay.alpha = 0.0
        viewController.view.addSubview(mainView)
        mainView.addSubview(backgroundOverlay)
        viewHolder.backgroundColor = Color.primary
        viewHolder.layer.shadowOpacity = 0.2
        viewHolder.layer.shadowOffset = CGSize(width: -2, height: -2)
        viewHolder.layer.cornerRadius = 4
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.white
        title.text = "\(message)\nTap to Retry"
        title.numberOfLines = 3
        title.textAlignment = .left
        let image = UIImageView()
        if type == NoticeType.error {
            image.image = UIImage(named: "bad")?.withRenderingMode(.alwaysTemplate)
        }else {
            image.image = UIImage(named: "good")?.withRenderingMode(.alwaysTemplate)
        }
        image.tintColor = UIColor.white
        viewHolder.addSubviews(title, image)
        viewHolder.addConstraints(withFormat: "V:|-8-[v0(40)]-(>=8)-|", views: image)
        viewHolder.constrain(type: .verticalFill, title, margin: 8)
        viewHolder.addConstraints(withFormat: "H:|-16-[v0(40)]-[v1]-16-|", views: image, title)
        //        image.centerXAnchor.constraint(equalTo: viewHolder.centerXAnchor).isActive = true
        callback = tap
        viewHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(call)))
        mainView.addSubview(viewHolder)
        mainView.addConstraints(withFormat: "V:|-72-[v0]-(>=0)-|", views: viewHolder)
        mainView.addConstraints(withFormat: "H:|-32-[v0]-32-|", views: viewHolder)
        
        controller = UIApplication.shared.keyWindow?.rootViewController
    }
    
    func show() {
        showing = true
        controller.present(viewController, animated: false, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 60000, execute: {
            self.call()
        })
    }
    
    func setController(_ vc: UIViewController) -> Notice {
        self.controller = vc
        return self
    }
    
    @objc func call() {
        if showing {
            self.callback(true)
            self.viewController.dismiss(animated: false, completion: nil)
        }
    }
    
    
    enum NoticeType: String {
        case error
        case info
    }
}

