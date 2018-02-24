//
//  MenuViewController.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/20/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit


class MenuViewController: AppController{
    
    var contentView: UIView!
    var cvLeftContraint: NSLayoutConstraint!
    var overlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        overlay = UIView()
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.0
        overlay.frame = view.frame
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        contentView = UIView()
        contentView.frame = CGRect(x: self.view.frame.width, y: 0, width: view.frame.width - 100, height: view.frame.height)
        contentView.backgroundColor = Color.primary
        view.addSubviews(overlay, contentView)
//        view.constrain(type: .verticalFill, contentView)
//        view.addConstraints(withFormat: "H:|-(>=0)-[v0]-(<=0)-|", views: contentView)
//        cvLeftContraint = NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: view.frame.width)
//        cvLeftContraint.isActive = true
//        view.addConstraint(cvLeftContraint)
        // init menu
//        createMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.overlay.alpha = 0.1
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
             self.contentView.frame = CGRect(x: 100, y: 0, width: self.view.frame.width - 100, height: self.view.frame.height)
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func close() {
         UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.contentView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width - 100, height: self.view.frame.height)
         }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
         })
    }
//    func createMenu() {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.rowHeight = 10
//        tableView.estimatedRowHeight = UITableViewAutomaticDimension
//        tableView.tableFooterView = UIView()
//
//        contentView.addSubviews(tableView)
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
}
