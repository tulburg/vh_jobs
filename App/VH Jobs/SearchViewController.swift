//
//  SearchViewController.swift
//  VH Jobs
//
//  Created by tolu oluwagbemi on 2/16/18.
//  Copyright © 2018 tolu oluwagbemi. All rights reserved.
//

import UIKit

class SearchViewController: AppController, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, AuthorizationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var bg: UIImageView!
    var scrollView: UIScrollView!
    var table: UITableView!
    var search: UIView!
    var goBtn: UIButton!
    var oldScrollY: CGFloat!
    var oldSearchFrame: CGRect!
    var oldGoBtnFrame: CGRect!
    var loadCount = 0
    var loadMax = 10
    var dataLoading = true
    var filterField: [String] = ["Location", "Company", "Position"]
    var filterOptions: Dictionary<String, Any> = ["location":[], "company":[], "position":[]]
    var filterTextField: UITextField!
    var filter: UIButton!
    var filterValue: UIButton!
    var selectedFilter: String!
    var selectedValue: String!
    var jobs: [Job] = []
    
    var filterSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate.addAuthorizationDelegate(delegate: self)
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        UIApplication.shared.statusBarStyle = .default
        // init background
        bg = UIImageView(image: UIImage(named: "bg"))
        bg.contentMode = .scaleAspectFill
        bg.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.insertSubview(bg, at: 0)
    
        filterTextField = UITextField()
        
        // init search box / header
        search = searchBox()
        goBtn = filterBtn()
        table = tableView()
        goBtn.addTarget(self, action: #selector(doFilter), for: .touchUpInside)
        let separator = separatorContainer()
        view.addSubviews(separator, table, search, goBtn)
        view.addConstraints(withFormat: "V:|-\((32 + statusBarHeight))-[v0(40)]-(>=0)-|", views: goBtn)
        view.addConstraints(withFormat: "H:|-24-[v0]-14-[v1(40)]-24-|", views: search, goBtn)
        view.constrain(type: .horizontalFill, separator, margin: 32)
        view.constrain(type: .horizontalFill, table, margin: 12)
        view.addConstraints(withFormat: "V:|-\((32 + statusBarHeight))-[v0(40)]-18-[v1]-(>=0)-|", views: search, separator)
        view.addConstraints(withFormat: "V:|-(\(statusBarHeight))-[v0]-0-|", views: table)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Authorization_didAuthorize() {
        // starting up....
        self.load()
    }
    
    func Authorization_didFailAuthorization() {
        Notice("Authorization Failed! Please contact support!", type: .error, tap: {
            _ in
        }).show()
    }
    
    @objc func doFilter(){
        if selectedValue != nil && selectedFilter != nil {
            
            DispatchQueue.main.async {
                self.table.showIndicator(size: 2)
                self.jobs = []
                self.table.reloadData()
            }
            
            let params = ["query":"mutation{jobs:filterJobs(filter:\"\(selectedFilter!)\", value: \"\(selectedValue!)\"){id,title,position,location,slot,deadline,type,salary, company{name,description,location,website,id}}}"]
            Linker(parameters: params, completion: {
                (data, response, error) -> () in
                DispatchQueue.main.async {
                    self.table.hideIndicator()
                }
                if error != nil {
                    DispatchQueue.main.async {
                        Notice((error?.localizedDescription)!, type: .error, tap: {
                            (bool) -> () in self.doFilter()
                        }).show()
                    }
                }else {
                    let response = Response(data?.toJsonObject() as! NSDictionary)
                    self.loadResponse(response)
                }
            }).executeJsonRequest(token: delegate.access_token!)
        }else {
            DispatchQueue.main.async {
                self.table.hideIndicator()
            }
            Notice("Please select a filter to proceed.", type: .error, tap: {
                _ in
            }).show()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.frame
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x:0, y: 0.5)
        gradient.colors = [
            UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0).cgColor,
            UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1).cgColor
        ]
        gradientView.layer.addSublayer(gradient)
        view.insertSubview(gradientView, at: 1)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if table.contentOffset.y > 0 {
            print(table.contentOffset.y)
            self.search.frame = CGRect(x: self.oldSearchFrame.origin.x, y: -45, width: self.oldSearchFrame.width, height: self.oldSearchFrame.height)
            self.goBtn.frame = CGRect(x: self.oldGoBtnFrame.origin.x, y: -45, width: self.oldGoBtnFrame.width, height: self.oldGoBtnFrame.height)
        }
    }
    
    private func load() {
        loadMore(loadCount)
    }
    
    private func loadMore(_ start: Int) {
        DispatchQueue.main.async {
            self.table.tableFooterView?.showIndicator(size: 2)
        }
        let params = ["query":"query{jobs(start:\(start), limit: \(loadMax)) {id,title,position,location,slot,deadline,type,salary, company{name,description,location,website,id}}}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!]
        Linker(parameters: params, completion: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.table.tableFooterView?.hideIndicator()
            }
            if error != nil {
                DispatchQueue.main.async {
                    Notice((error?.localizedDescription)!, type: .error, tap: {
                        (bool) -> () in self.load()
                    }).show()
                }
            }else {
                let response = Response(data?.toJsonObject() as! NSDictionary)
                if response.data != nil {
                    // print(response.data!) // debug
                    self.loadResponse(response)
                }else {
                    if response.errors != nil {
                        print("Error encountered \(response.errors!)")
                    }
                }
            }
        }).setMethod("GET").executeAuth(token: delegate.access_token!)
    }
    
    private func loadResponse(_ response: Response) {
        if let jobs = response.data!["jobs"] as? [NSDictionary] {
            for job in jobs {
                let jobObj = Job(job)
                self.jobs.append(jobObj)
                if var locations = self.filterOptions["location"] as? [String] {
                    if !locations.contains(jobObj.location!) {
                        locations.append(jobObj.location!)
                        self.filterOptions["location"] = locations
                    }
                }
                if var companies = self.filterOptions["company"] as? [String] {
                    if !companies.contains((jobObj.company?.name)!) {
                        companies.append((jobObj.company?.name)!)
                        self.filterOptions["company"] = companies
                    }
                }
                if var positions = self.filterOptions["position"] as? [String] {
                    if !positions.contains(jobObj.position!) {
                        positions.append(jobObj.position!)
                        self.filterOptions["position"] = positions
                    }
                }
            }
            self.loadCount = self.loadCount + jobs.count
            if jobs.count >= self.loadMax {
                self.dataLoading = false
            }
            
            // print(self.filterOptions) // debug
        }
        // print(self.jobs) // debug
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    
    private func searchBox() -> UIView {
        let background = UIView()
        background.backgroundColor = UIColor.white
        background.roundShadow()
        background.layer.cornerRadius = 20
        filter = UIButton()
        filter.setImage(UIImage(named: "caret"), for: .normal)
        filter.setTitle("Filter by", for: .normal)
        filter.setTitleColor(UIColor.black, for: .normal)
        filter.semanticContentAttribute = .forceRightToLeft
        filter.imageEdgeInsets = UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 8)
        filter.addTarget(self, action: #selector(openFilters), for: .touchUpInside)
        filterValue = UIButton()
        filterValue.setImage(UIImage(named: "caret"), for: .normal)
        filterValue.setTitle("Value", for: .normal)
        filterValue.setTitleColor(Color.primary, for: .normal)
        filterValue.semanticContentAttribute = .forceRightToLeft
        filterValue.imageEdgeInsets = UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 8)
        filterValue.isHidden = true
        filterValue.addTarget(self, action: #selector(openFiltersValue), for: .touchUpInside)
        let separator = colorView(Color.lighterGray)
        background.addSubviews(filter, filterValue, separator)
        background.addConstraints(withFormat: "H:|-0-[v0(120)]-0-[v1(1)]-2-[v2]-12-|", views: filter, separator, filterValue)
        background.constrain(type: .verticalFill, filter, filterValue, separator, margin: 4)
        return background
    }
    
    @objc func openFilters() {
        filterSelected = true
        showPickerView()
    }
    
    @objc func openFiltersValue() {
        filterSelected = false
        showPickerView()
    }
    
    func showPickerView() {
        let filterPickerView = UIPickerView()
        filterPickerView.dataSource = self
        filterPickerView.delegate = self
        filterPickerView.frame = CGRect(x: 17, y: 0, width: 270, height: 200)
        filterTextField.inputView = filterPickerView
        view.addSubview(filterTextField)
        filterTextField.becomeFirstResponder()
    }
    
    private func filterBtn() -> UIButton {
        let button = UIButton()
        button.backgroundColor = Color.primary
        button.layer.cornerRadius = 20
        button.roundShadow()
        button.setImage(UIImage(named: "arrow_right"), for: .normal)
        return button
    }
    
    private func separatorContainer() -> UIView {
        let container = UIView()
        let label = small_label("Top 100", Color.darkText)
        let separator = UIView()
        separator.backgroundColor = Color.darkGray
        container.addSubviews(label, separator)
        container.addConstraints(withFormat: "V:|-(>=0)-[v0(1)]-(>=0)-|", views: separator)
        separator.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        container.addConstraints(withFormat: "H:|-0-[v0]-16-[v1]-0-|", views: label, separator)
        container.constrain(type: .verticalFill, label)
        return container
    }
    
    private func tableView() -> UITableView {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 110))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.tintColor = UIColor.blue
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        tableView.tableFooterView = footer
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 100 && scrollView.contentOffset.y > 0 {
            let alpha = scrollView.contentOffset.y / 100
            bg.alpha = 1 - alpha
            if oldSearchFrame == nil {
                search.layoutIfNeeded()
                goBtn.layoutIfNeeded()
                oldSearchFrame = search.frame
                oldGoBtnFrame = goBtn.frame
            }
        }
        
        if scrollView.contentOffset.y >= 60 && scrollView.contentOffset.y < 200 {
            if oldScrollY < scrollView.contentOffset.y {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.search.frame = CGRect(x: self.oldSearchFrame.origin.x, y: -45, width: self.oldSearchFrame.width, height: self.oldSearchFrame.height)
                    self.goBtn.frame = CGRect(x: self.oldGoBtnFrame.origin.x, y: -45, width: self.oldGoBtnFrame.width, height: self.oldGoBtnFrame.height)
                }, completion: nil)
            }else {
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.search.frame = self.oldSearchFrame
                    self.goBtn.frame = self.oldGoBtnFrame
                }, completion: nil)
            }
        }
        oldScrollY = scrollView.contentOffset.y
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARk:- Table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let jobVC = JobViewController()
        jobVC.job = jobs[indexPath.row]
        present(jobVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = JobTableViewCell()
        cell.build(jobs[indexPath.row])
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == jobs.count - 1) {
            if !dataLoading && (selectedFilter == nil && selectedValue == nil) {
                print("loading more \(loadCount)")
                loadMore(loadCount)
                dataLoading = true
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // MARk:- Picker View functions
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if filterSelected {
            return filterField.count
        }
        return ((filterOptions[selectedFilter] as? [String])?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if filterSelected {
            return filterField[row]
        }
        return (filterOptions[selectedFilter] as? [String])?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterTextField.resignFirstResponder()
        if filterSelected {
            selectedFilter = filterField[row].lowercased()
            filter.setTitle(filterField[row], for: .normal)
            if ((filterOptions[selectedFilter] as? [String])?.count)! > 0 {
                selectedValue = (filterOptions[selectedFilter] as? [String])?[0]
                filterValue.setTitle(selectedValue, for: .normal)
            }
            filterValue.isHidden = false
        }else {
            selectedValue = (filterOptions[selectedFilter] as? [String])?[row]
            filterValue.setTitle(selectedValue, for: .normal)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
