//
//  JobTableViewCell.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/21/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    var job: Job!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func build(_ job: Job) {
        self.job = job
        let mainView = UIView()
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 12
        mainView.layer.shadowOpacity = 0.12
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 5
        contentView.addSubview(mainView)
        contentView.constrain(type: .horizontalFill, mainView, margin: 8)
        contentView.constrain(type: .verticalFill, mainView, margin: 8)
        contentView.backgroundColor = UIColor.clear
        
        let title = label(job.title!, Color.darkText, UIFont.systemFont(ofSize: 22))
        let position = label(job.position!, Color.primary, UIFont.systemFont(ofSize: 14))
        let datetime = label(job.deadline!.description, Color.lightText, UIFont.systemFont(ofSize: 12))
        let location = label(job.location!, Color.lightText, UIFont.systemFont(ofSize: 12))
        let slot = label("\(job.slot!)", Color.lightText, UIFont.systemFont(ofSize: 12))
        let full_deadline = label(job.deadline!.stringFormat("EEEE d, MMM"), Color.lightText, UIFont.systemFont(ofSize: 12))
        let postedBy = label("Posted By:", Color.lightText, UIFont.systemFont(ofSize: 12))
        let companyName = label((job.company?.name)!, Color.darkText, UIFont.systemFont(ofSize: 14))
        let type = paddedLabel(job.type!, UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 12), Color.primary)
        if job.type! == "Full Time" {
            type.backgroundColor = Color.primaryGreen
        }else if job.type! == "Contract" {
            type.backgroundColor = Color.primaryOrange
        }
        let locationIc = UIImageView(image: UIImage(named: "location_ic"))
        locationIc.contentMode = .scaleAspectFit
        let slotIc = UIImageView(image: UIImage(named: "spot_ic"))
        slotIc.contentMode = .scaleAspectFit
        let deadlineIc = UIImageView(image: UIImage(named: "calendar_ic"))
        deadlineIc.contentMode = .scaleAspectFit
        let covers = [1: UIImage(named: "cover_sample")!, 2: UIImage(named: "rockstar")!, 3: UIImage(named: "twitter")!, 4: UIImage(named: "recode")!, 5: UIImage(named: "virgin")!]
        let companyLogo = UIImageView(image: covers[(job.company?.id)!])
        companyLogo.contentMode = .scaleAspectFill
        companyLogo.layer.cornerRadius = 12.5
        companyLogo.clipsToBounds = true
        
        let round_separator = UIView()
        round_separator.backgroundColor = Color.lightGray
        round_separator.layer.cornerRadius = 2
        let line_separator = UIView()
        line_separator.backgroundColor = Color.lightGray
        
        mainView.addSubviews(title, position, datetime, location, slot, full_deadline, postedBy, companyName, locationIc, slotIc, deadlineIc, type, round_separator, line_separator, companyLogo)
        
        mainView.addConstraints(withFormat: "H:|-16-[v0]-[v1(10)]-[v2]-(>=0)-|", views: title, round_separator, position)
        mainView.addConstraints(withFormat: "V:|-16-[v0]-4-[v1(18)]-[v2(14)]-16-[v3(1)]-16-[v4]-2-[v5(25)]-8-|", views: title, type, locationIc, line_separator, postedBy, companyLogo)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-8-[v1]-(>=0)-|", views: type, location)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-8-[v1(14)]-(>=0)-|", views: type, slotIc)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-8-[v1]-(>=0)-|", views: type, slot)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-8-[v1(14)]-(>=0)-|", views: type, deadlineIc)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-8-[v1]-(>=0)-|", views: type, full_deadline)
        mainView.addConstraints(withFormat: "H:|-16-[v0(14)]-4-[v1]-32-[v2(14)]-4-[v3]-32-[v4(14)]-4-[v5(<=120)]-16-|", views: locationIc, location, slotIc, slot, deadlineIc, full_deadline)
        mainView.constrain(type: .horizontalFill, line_separator)
        mainView.addConstraints(withFormat: "H:|-16-[v0(25)]-[v1]-(>=0)-|", views: companyLogo, companyName)
        mainView.addConstraints(withFormat: "H:|-16-[v0]-(>=0)-|", views: postedBy)
        mainView.addConstraints(withFormat: "H:|-16-[v0]-(>=0)-|", views: type)
        mainView.addConstraints(withFormat: "V:|-(>=0)-[v0]-6-[v1]-(>=0)-|", views: postedBy, companyName)
        mainView.addConstraints(withFormat: "V:|-22-[v0]-(>=0)-|", views: position)
        mainView.addConstraints(withFormat: "V:|-28-[v0(4)]-(>=0)-|", views: round_separator)
    }
    
    private func label(_ text: String, _ color: UIColor?, _ font: UIFont?) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        if color != nil {
            label.textColor = color!
        }
        if font != nil {
            label.font = font
        }
        return label
    }
    
    private func paddedLabel(_ text: String, _ padding: UIEdgeInsets, _ color: UIColor) -> UIView{
        let label: UILabel = UILabel()
        label.text = text
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 12)
        let background = UIView()
        background.backgroundColor = color
        background.clipsToBounds = true
        background.layer.cornerRadius = 8
        background.addSubview(label)
        background.addConstraints(withFormat: "H:|-\(padding.left)-[v0]-\(padding.right)-|", views: label)
        background.addConstraints(withFormat: "V:|-\(padding.top)-[v0]-\(padding.bottom)-|", views: label)
        return background
    }
}
