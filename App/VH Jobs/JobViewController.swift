//
//  JobViewController.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/22/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit


class JobViewController: AppController, UIScrollViewDelegate {
    
    var job: Job!
    var contentView: UIView!
    var coverFrame: CGRect!
    var cover: UIImageView!
    var covers: [Int: UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        covers = [1: UIImage(named: "cover_sample")!, 2: UIImage(named: "rockstar")!, 3: UIImage(named: "twitter")!, 4: UIImage(named: "recode")!, 5: UIImage(named: "virgin")!]
        
        let scrollView = UIScrollView()
        contentView = UIView()
        contentView.backgroundColor = UIColor.clear
        scrollView.addSubview(contentView)
        scrollView.addConstraints(withFormat: "V:|-0-[v0]-0-|", views: contentView)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.delegate = self
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        cover = UIImageView(image: covers[(job.company?.id)!])
        cover.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 240)
        cover.contentMode = .scaleAspectFill
        cover.alpha = 0.6
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubviews(cover, scrollView, closeBtn)
        view.addConstraints(withFormat: "H:|-(>=0)-[v0(22)]-24-|", views: closeBtn)
        view.addConstraints(withFormat: "V:|-32-[v0(22)]-(>=0)-|", views: closeBtn)
        
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        view.addConstraints(withFormat: "V:|-(\(-statusBarHeight))-[v0(\(view.frame.height+statusBarHeight))]-0-|", views: scrollView)
        view.constrain(type: .horizontalFill, scrollView)
        
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 20
        let companyName = label((job.company?.name)!, UIColor.white, UIFont.systemFont(ofSize: 22))
        let companyNameContainer = UIView()
        companyNameContainer.backgroundColor = UIColor.black
        companyNameContainer.layer.cornerRadius = 12
        let title = label(job.title!, Color.darkText, UIFont.boldSystemFont(ofSize: 22))
        companyName.adjustsFontSizeToFitWidth = true
        companyName.numberOfLines = 2
        companyName.minimumScaleFactor = 0.6
        let locationIc = UIImageView(image: UIImage(named: "location_ic"))
        locationIc.contentMode = .scaleAspectFit
        let location = medium_label(job.location!, Color.lightText)
        let website = medium_label((job.company?.website)!, Color.primary)
        let headerSeparator = colorView(Color.lighterGray)
        let companyDescription = medium_label((job.company?.description)!, Color.darkText)
        companyDescription.numberOfLines = 7
        let companySeparator = colorView(Color.lighterGray)
        let minEducation = xsmall_label("Min. Education", UIColor.black)
        let minExperience = xsmall_label("Req. Experience", UIColor.black)
        let education = small_label("Graduate", Color.lightText)
        let experience = small_label("2 - 8 years", Color.lightText)
        let experienceSeparator = colorView(Color.lighterGray)
        let experienceDot = colorView(Color.primary)
        experienceDot.layer.cornerRadius = 12.5
        let educationDot = colorView(Color.primaryGreen)
        educationDot.layer.cornerRadius = 12.5
        let respTitle = label("Responsibilities", Color.primary, UIFont.boldSystemFont(ofSize: 14))
        let responsibilities = medium_label(Util.responsibilityPlaceholder, Color.darkText)
        responsibilities.numberOfLines = 20
        let applyButton = colorRoundButton("Apply", Color.primary)
        
        contentView.addSubviews(container)
        contentView.addConstraints(withFormat: "V:|-200-[v0]-(-40)-|", views: container)
        contentView.constrain(type: .horizontalFill, container)
        container.addSubviews(companyNameContainer, locationIc, headerSeparator, title, website, location, companyDescription, companySeparator, minEducation, minExperience, education, experience, experienceSeparator, experienceDot, educationDot, respTitle, responsibilities, applyButton)
        container.addConstraints(withFormat: "V:|-(-35)-[v0(80)]-15-[v1(14)]-16-[v2(1)]-16-[v3]-16-[v4(1)]-18-[v5(25)]-18-[v6(1)]-18-[v7]-8-[v8]-32-[v9(40)]-(>=80)-|", views: companyNameContainer, locationIc, headerSeparator, companyDescription, companySeparator, educationDot, experienceSeparator, respTitle, responsibilities, applyButton)
        container.addConstraints(withFormat: "H:|-32-[v0(80)]-16-[v1]-16-|", views: companyNameContainer, title)
        container.constrain(type: .horizontalFill, headerSeparator, companySeparator, companyDescription, experienceSeparator, responsibilities, respTitle, applyButton, margin: 32)
        container.addConstraints(withFormat: "V:|-16-[v0]-(>=0)-|", views: title)
        companyNameContainer.addSubview(companyName)
        companyNameContainer.constrain(type: .horizontalFill, companyName, margin: 12)
        companyNameContainer.constrain(type: .verticalFill, companyName, margin: 8)
        container.addConstraints(withFormat: "H:|-32-[v0(14)]-6-[v1]-24-[v2(<=180)]-32-|", views: locationIc, location, website)
        container.addConstraints(withFormat: "V:|-(>=-35)-[v0]-14-[v1]-(>=0)-|", views: companyNameContainer, website)
        container.addConstraints(withFormat: "V:|-(>=-35)-[v0]-14-[v1]-(>=0)-|", views: companyNameContainer, location)
        container.addConstraints(withFormat: "V:|-(>=0)-[v0]-18-[v1]-1-[v2]-(>=0)-|", views: companySeparator, minEducation, education)
        container.addConstraints(withFormat: "V:|-(>=0)-[v0]-18-[v1]-1-[v2]-(>=0)-|", views: companySeparator, minExperience, experience)
        container.addConstraints(withFormat: "H:|-32-[v0(25)]-6-[v1]-32@1-[v2(25)]-6-[v3]-(>=32)-|", views: educationDot, education, experienceDot, experience)
        container.addConstraints(withFormat: "H:|-(>=0)-[v0]-6-[v1]-(>=0)-|", views: educationDot, minEducation)
        container.addConstraints(withFormat: "H:|-(>=0)-[v0]-6-[v1]-(>=0)-|", views: experienceDot, experience)
        container.addConstraints(withFormat: "H:|-(>=0)-[v0]-6-[v1]-(>=0)-|", views: experienceDot, minExperience)
        container.addConstraints(withFormat: "V:|-(>=0)-[v0]-18-[v1(25)]-(>=0)-|", views: companySeparator, experienceDot)

        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if cover != nil {
            cover.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 240 - scrollView.contentOffset.y)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
