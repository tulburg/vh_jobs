//
//  Extensions.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/16/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}


extension UIView {
    func addConstraints(withFormat: String, views: UIView...) {
        var viewDict = [String: Any]()
        for(index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
    
    func constrain(type: ConstraintType, _ views: UIView..., margin: Float = 0) {
        if type == .horizontalFill {
            for view in views {
                addConstraints(withFormat: "H:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        }else if type == .verticalFill {
            for view in views {
                addConstraints(withFormat: "V:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        }
    }
    
    func showIndicator(size: Int) {
        showIndicator(size: size, color: UIColor.black)
    }
    
    func showIndicator(size: Int, color: UIColor) {
        let loadIndicator = UIActivityIndicatorView()
        loadIndicator.activityIndicatorViewStyle = .whiteLarge
        loadIndicator.color = color
        loadIndicator.startAnimating()
        var dimen = 20
        if size == 2 { dimen = 40 }
        if size == 3 { dimen = 60 }
        if size == 4 { dimen = 80 }
        if size == 5 { dimen = 100 }
        addSubview(loadIndicator)
        addConstraints(withFormat: "V:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        addConstraints(withFormat: "H:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
        loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func hideIndicator() {
        for v: UIView in subviews {
            if v is UIActivityIndicatorView {
                v.removeFromSuperview()
            }
        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
    
    func roundShadow() {
        layer.shadowOpacity = 0.16
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

extension Data {
    func toJsonArray() -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [Any]
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
    func toJsonObject() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? NSDictionary
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
}

enum ConstraintType {
    case horizontalFill
    case verticalFill
}

// Utility Classes

class Color {
    static let primary = UIColor(hex: 0x04749D)
    static let tint = UIColor(hex: 0x0A9D04)
    static let darkText = UIColor(hex: 0x282828)
    static let lightText = UIColor(hex: 0x7b7b7b)
    static let darkGray = UIColor(hex: 0x909090)
    static let lightGray = UIColor(hex: 0xc0c0c0)
    static let lighterGray = UIColor(hex: 0xf0f0f0)
    static let primaryGreen = UIColor(hex: 0x0A9D04)
    static let primaryOrange = UIColor(hex: 0xD3960C)
}


class Util {
    class func parseDate(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if dateFormatter.date(from:string) != nil {
            return dateFormatter.date(from:string)
        }else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            if dateFormatter.date(from: string) != nil {
                return dateFormatter.date(from:string)
            }else {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if dateFormatter.date(from: string) != nil {
                    return dateFormatter.date(from:string)
                }
            }
        }
        return nil
    }
    
    class func parseString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: date)
    }
    
    static let responsibilityPlaceholder = "We share documents internally broadly and systematically. Nearly every document is fully open for anyone to read and comment on, and everything is cross-linked. Memos on each title’s performance, on every strategy decision, on every competitor, and on every product feature test are open for all employees to read. Despite this huge access, we’ve had very few leaks, due to our ethos of self-discipline and responsibility.\nThere are virtually no spending controls or contract signing controls. Each employee is expected to seek advice and perspective as appropriate. “Use good judgment” is our core precept.\nOur policy for travel, entertainment, gifts, and other expenses is 5 words long: “act in Netflix’s best interest.” We also avoid the compliance departments that most companies have to enforce their policies.\nOur vacation policy is “take vacation.” We don’t have any rules or forms around how many weeks per year. Frankly, we intermix work and personal time quite a bit, doing email at odd hours, taking off weekday afternoons for kids’ games, etc. Our leaders make sure they set good examples by taking vacations, often coming back with fresh ideas, and encourage the rest of the team to do the same."
}


extension Date {
    func stringFormat(_ string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = string
        return dateFormatter.string(from: self)
    }
}
