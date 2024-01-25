//
//  DashboardVC.swift
//  WhatSticks11iOS
//
//  Created by Nick Rodriguez on 08/12/2023.
//

import UIKit

class DashboardVC: TemplateVC, SelectDashboardVCDelegate{
    
    var userStore: UserStore!
    var requestStore: RequestStore!
    var appleHealthDataFetcher:AppleHealthDataFetcher!
    var healthDataStore:HealthDataStore!
    var btnGoToManageDataVC=UIButton()
    var boolDashObjExists:Bool!
    var tblDashboard:UITableView?
    var refreshControlTblDashboard:UIRefreshControl?
    //    var btnCheckDashTableObj = UIButton()
    //    var lblDashboardTitle=UILabel()
    var lblDashboardTitle:UILabel?
    var btnRefreshDashboard:UIButton?
    //    var btnTblDashboardOptions:UIButton?
    var btnDashboards:UIButton?
    var btnDashboardTitleInfo:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupIsDev(urlStore: requestStore.urlStore)
        self.lblUsername.text = userStore.user.username
        self.lblScreenName.text = "Dashboard"
        print("- in DashboardVC viewDidLoad -")
        //        setup_btnGoToManageDataVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        checkDashboardTableObjectNew()
    }
    
    func checkDashboardTableObjectNew(){
        
        if userStore.boolDashObjExists{
            if lblDashboardTitle == nil {
                setup_lblDashboardTitle_isNil()
            }
            if lblDashboardTitle != nil {
                setup_lblDashboardTitle_isNotNil()
            }
            if tblDashboard == nil {
                setup_tblDashboard_isNil()
            }
            if tblDashboard != nil {
                setup_tblDashboard_isNotNil()
            }
            if btnDashboards == nil {
                setup_btnDashboards_isNil()
            }
            if btnDashboards != nil {
                setup_btnDashboards_isNotNil()
            }
            if btnRefreshDashboard != nil {
                btnRefreshDashboard?.removeFromSuperview()
            }
        } else {
            print("create btnRefreshDashboard")
            if btnRefreshDashboard == nil {
                print("setup_btnRefreshDashboard()")
            }
        }
    }
    
    func setup_lblDashboardTitle_isNil(){
        print("This is lblDashboardTitle is nil")
        lblDashboardTitle=UILabel()
        lblDashboardTitle!.accessibilityIdentifier="lblDashboardTitle"
        lblDashboardTitle!.translatesAutoresizingMaskIntoConstraints=false
        lblDashboardTitle!.font = UIFont(name: "ArialRoundedMTBold", size: 45)
        lblDashboardTitle!.numberOfLines = 0
        view.addSubview(lblDashboardTitle!)
        NSLayoutConstraint.activate([
            lblDashboardTitle!.topAnchor.constraint(equalTo: vwTopBar.bottomAnchor, constant: heightFromPct(percent: 1)),
            lblDashboardTitle!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 2)),
            lblDashboardTitle!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -12)),
        ])
    }
    func setup_lblDashboardTitle_isNotNil(){
        print("This is lblDashboardTitle not nil")
        lblDashboardTitle!.text = userStore.currentDashboardObject?.dependentVarName ?? "No title"
    }
    
    func setup_tblDashboard_isNil(){
        print("This is tblDashboard is nil")
        self.tblDashboard = UITableView()
        self.tblDashboard!.accessibilityIdentifier = "tblDashboard"
        self.tblDashboard!.translatesAutoresizingMaskIntoConstraints=false
        self.tblDashboard!.delegate = self
        self.tblDashboard!.dataSource = self
        self.tblDashboard!.register(DashboardTableCell.self, forCellReuseIdentifier: "DashboardTableCell")
        self.tblDashboard!.rowHeight = UITableView.automaticDimension
        self.tblDashboard!.estimatedRowHeight = 100
        view.addSubview(self.tblDashboard!)
        NSLayoutConstraint.activate([
            tblDashboard!.topAnchor.constraint(equalTo: lblDashboardTitle!.bottomAnchor, constant: heightFromPct(percent: 2)),
            tblDashboard!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tblDashboard!.bottomAnchor.constraint(equalTo: vwFooter.topAnchor),
            tblDashboard!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        self.refreshControlTblDashboard = UIRefreshControl()
        refreshControlTblDashboard!.addTarget(self, action: #selector(self.refresh_tblDashboardData(_:)), for: .valueChanged)
        self.tblDashboard!.refreshControl = refreshControlTblDashboard!
    }
    func setup_tblDashboard_isNotNil(){
        print("This is tblDashboard not nil")
    }
    
    func setup_btnDashboards_isNil(){
        print("This is tblDashboard is nil")
        btnDashboards=UIButton()
        btnDashboards!.accessibilityIdentifier="btnDashboards"
        btnDashboards!.translatesAutoresizingMaskIntoConstraints=false
        btnDashboards!.backgroundColor = .systemBlue
        btnDashboards!.layer.cornerRadius = 10
        btnDashboards!.setTitle(" Dashboards ", for: .normal)
        btnDashboards!.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        btnDashboards!.addTarget(self, action: #selector(touchUpInside_btnDashboards(_:)), for: .touchUpInside)
        view.addSubview(btnDashboards!)
        NSLayoutConstraint.activate([
            btnDashboards!.topAnchor.constraint(equalTo: vwFooter.topAnchor, constant: heightFromPct(percent: 2)),
            btnDashboards!.leadingAnchor.constraint(equalTo: vwFooter.leadingAnchor, constant: widthFromPct(percent: 2)),
        ])
    }
    func setup_btnDashboards_isNotNil(){
        print("This is tblDashboard not nil")
    }
    
    func setup_btnRefreshDashboard_isNil(){
        self.btnRefreshDashboard = UIButton()
        self.btnRefreshDashboard!.accessibilityIdentifier = "btnRefreshDashboard"
        self.btnRefreshDashboard!.translatesAutoresizingMaskIntoConstraints=false
        self.btnRefreshDashboard!.backgroundColor = .systemGray
        self.btnRefreshDashboard!.layer.cornerRadius = 10
        self.btnRefreshDashboard!.setTitle(" Refresh Table ", for: .normal)
        self.btnRefreshDashboard!.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        self.btnRefreshDashboard!.addTarget(self, action: #selector(touchUpInside_btnRefreshDashboard(_:)), for: .touchUpInside)
        view.addSubview(self.btnRefreshDashboard!)
        NSLayoutConstraint.activate([
            self.btnRefreshDashboard!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.btnRefreshDashboard!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 2)),
        ])
    }
    
    /* Action Methods Obj C */
    
    @objc private func refresh_tblDashboardData(_ sender: UIRefreshControl){
        self.update_arryDashboardTableObjects()
    }
    @objc private func touchUpInside_btnDashboards(_ sender: UIRefreshControl){
        //        self.update_arryDashboardTableObjects()
        print("present SelectDashboardVC")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        let selectDashboardVC = SelectDashboardVC(userStore: userStore)
        selectDashboardVC.delegate = self
        selectDashboardVC.modalPresentationStyle = .overCurrentContext
        selectDashboardVC.modalTransitionStyle = .crossDissolve
        self.present(selectDashboardVC, animated: true, completion: nil)
    }
    
    @objc private func touchUpInside_btnRefreshDashboard(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        self.update_arryDashboardTableObjects()
    }

    
    /* Action Methods */
    func update_arryDashboardTableObjects(){
        self.userStore.callSendDashboardTableObjects { resultDashTableObj in
            switch resultDashTableObj{
            case .success(_):
                print("- Success: userStore.arryDashboardTableObjects updated with \(self.userStore.arryDashboardTableObjects.count) dash objects")
                if let unwp_refreshControlTblDashboard = self.refreshControlTblDashboard {
                    unwp_refreshControlTblDashboard.endRefreshing()
                }
                if let unwp_tblDashboard = self.tblDashboard {
                    unwp_tblDashboard.reloadData()
                }
                self.checkDashboardTableObjectNew()
            case let .failure(error):
                print("failure: DashboardVC trying to update dashboard via func update_arryDashboardTableObjects; the error is \(error)")
                if let unwp_refreshControlTblDashboard = self.refreshControlTblDashboard {
                    unwp_refreshControlTblDashboard.endRefreshing()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.templateAlert(alertTitle: "No Data Found Dashboard", alertMessage: "If you just added data, it could take a couple minutes to process. \n\nOtherwise try adding data.")
                }

            }
        }
    }
    
    
    
    /* Protocol methods */
    func didSelectDashboard(currentDashboardObjPos:Int){
        DispatchQueue.main.async{
            self.userStore.currentDashboardObjPos = currentDashboardObjPos
            self.userStore.currentDashboardObject = self.userStore.arryDashboardTableObjects[currentDashboardObjPos]
            if let unwp_lblDashboardTitle = self.lblDashboardTitle{
                unwp_lblDashboardTitle.text = self.userStore.arryDashboardTableObjects[currentDashboardObjPos].dependentVarName
            } else {
                self.templateAlert(alertTitle: "UI Error", alertMessage: "Please let email nick: nrodrig1@gmail: No lblDashboardTitle in DashboardVC when trying to select a new Dashboard ")
            }
            print("DashboardVC has a new self.dashboardTableObject")
            print("self.dashboardTableObject: \(String(describing: self.userStore.currentDashboardObject!.dependentVarName))")
            // Update your view accordingly
            if let unwp_tblDashboard = self.tblDashboard {
                unwp_tblDashboard.reloadData()
            } else {
                self.templateAlert(alertTitle: "UI Error", alertMessage: "Please let email nick: nrodrig1@gmail: No tblDashboard in DashboardVC when trying to select a new Dashboard ")
            }
            self.checkDashboardTableObjectNew()
        }
    }
    
    /* Segue Methods */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToManageDataVC"){
            let manageDataVC = segue.destination as! ManageDataVC
            manageDataVC.userStore = self.userStore
            manageDataVC.appleHealthDataFetcher = self.appleHealthDataFetcher
            manageDataVC.healthDataStore = self.healthDataStore
            manageDataVC.requestStore = self.requestStore
        }
    }
    
    
}

extension DashboardVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DashboardTableCell else { return }
        cell.isVisible.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension DashboardVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dashTableObj = self.userStore.currentDashboardObject else {
            return 0
        }
        return dashTableObj.arryIndepVarObjects!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        guard let currentDashObj = userStore.currentDashboardObject,
              let arryIndepVarObjects = currentDashObj.arryIndepVarObjects,
              let unwpVerb = currentDashObj.verb else {return cell}
        
        cell.indepVarObject = arryIndepVarObjects[indexPath.row]
        cell.configureCellWithIndepVarObject()
        cell.depVarVerb = unwpVerb
        return cell
    }
    
}

protocol SelectDashboardVCDelegate{
    func didSelectDashboard(currentDashboardObjPos: Int)
}


//    /*------------ OLD  DashboardVC -------- */
//
//
//    //    func dashboardTableObjectExists(){
//    func checkDashboardTableObject(){
//        if self.userStore.boolDashObjExists{
//
//            self.lblDashboardTitle.text = self.userStore.currentDashboardObject!.dependentVarName
//            DispatchQueue.main.async {
//                self.setup_lblDashboardTitle()
//                self.btnDashboardTitleInfo = UIButton(type: .custom)
//                self.setupInformationButton()
//                if self.userStore.arryDashboardTableObjects.count >= 2 && self.btnTblDashboardOptions == nil {
//                    self.setup_btnTblDashboardOptions()
//                }
//                self.tblDashboard = UITableView()
//                self.setup_tbl()
//                self.tblDashboard.delegate = self
//                self.tblDashboard.dataSource = self
//                self.tblDashboard.register(DashboardTableCell.self, forCellReuseIdentifier: "DashboardTableCell")
//                self.tblDashboard.rowHeight = UITableView.automaticDimension
//                self.tblDashboard.estimatedRowHeight = 100
//                let refreshControl = UIRefreshControl()
//                refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
//                self.tblDashboard.refreshControl = refreshControl
//
//                if let _ = self.btnRefreshDashboard{
//                    self.btnRefreshDashboard.removeFromSuperview()
//                }
//
//            }
//        }else {
//            self.setup_btnRefreshDashboard()
//            if let _ = self.tblDashboard{
//                self.tblDashboard.removeFromSuperview()
//                self.lblDashboardTitle.removeFromSuperview()
//                self.btnDashboardTitleInfo.removeFromSuperview()
//            }
//            print("No arryDashboardTableObjects.json file found")
//        }
//    }
//    func setup_lblDashboardTitle(){
//
//        lblDashboardTitle.text = userStore.currentDashboardObject?.dependentVarName ?? "No title"
//        lblDashboardTitle.font = UIFont(name: "ArialRoundedMTBold", size: 45)
//        lblDashboardTitle.translatesAutoresizingMaskIntoConstraints = false
//        lblDashboardTitle.accessibilityIdentifier="lblDashboardTitle"
//        view.addSubview(lblDashboardTitle)
//        lblDashboardTitle.topAnchor.constraint(equalTo: vwTopBar.bottomAnchor, constant: heightFromPct(percent: bodyTopPaddingPercentage/4)).isActive=true
//        lblDashboardTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: bodySidePaddingPercentage)).isActive=true
//    }
//    private func setupInformationButton() {
//        if let unwrapped_image = UIImage(named: "information") {
//            let small_image = unwrapped_image.scaleImage(toSize: CGSize(width: 10, height: 10))
//            // Set the image for the button
//            btnDashboardTitleInfo.setImage(small_image, for: .normal)
//            // Add action for button
//            btnDashboardTitleInfo.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
//            // Add the button to the view
//            self.view.addSubview(btnDashboardTitleInfo)
//            btnDashboardTitleInfo.translatesAutoresizingMaskIntoConstraints=false
//            btnDashboardTitleInfo.leadingAnchor.constraint(equalTo: lblDashboardTitle.trailingAnchor,constant: widthFromPct(percent: 0.5)).isActive=true
//            btnDashboardTitleInfo.centerYAnchor.constraint(equalTo: lblDashboardTitle.centerYAnchor, constant: heightFromPct(percent: -2)).isActive=true
//
//        }
//
//    }
//    @objc private func infoButtonTapped() {
//        let infoVC = InfoVC(dashboardTableObject: userStore.currentDashboardObject)
//        infoVC.modalPresentationStyle = .overCurrentContext
//        infoVC.modalTransitionStyle = .crossDissolve
//        self.present(infoVC, animated: true, completion: nil)
//    }
//    func setup_tbl(){
//        tblDashboard.accessibilityIdentifier = "tblDashboard"
//        tblDashboard.translatesAutoresizingMaskIntoConstraints=false
//        view.addSubview(tblDashboard)
//        tblDashboard.topAnchor.constraint(equalTo: lblDashboardTitle.bottomAnchor, constant: heightFromPct(percent: 2)).isActive=true
//        tblDashboard.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive=true
//        tblDashboard.bottomAnchor.constraint(equalTo: vwFooter.topAnchor).isActive=true
//        tblDashboard.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive=true
//        tblDashboard.translatesAutoresizingMaskIntoConstraints=false
//    }
//    func setup_btnGoToManageDataVC(){
//        view.addSubview(btnGoToManageDataVC)
//        btnGoToManageDataVC.translatesAutoresizingMaskIntoConstraints=false
//        btnGoToManageDataVC.accessibilityIdentifier="btnGoToManageDataVC"
//        btnGoToManageDataVC.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
//        btnGoToManageDataVC.addTarget(self, action: #selector(touchUpInside_goToManageDataVC(_:)), for: .touchUpInside)
//        // vwFooter button Placement
//        btnGoToManageDataVC.topAnchor.constraint(equalTo: vwFooter.topAnchor, constant: heightFromPct(percent: 2)).isActive=true
//        btnGoToManageDataVC.trailingAnchor.constraint(equalTo: vwFooter.trailingAnchor, constant: widthFromPct(percent: -2)).isActive=true
//        btnGoToManageDataVC.backgroundColor = .systemBlue
//        btnGoToManageDataVC.layer.cornerRadius = 10
//        btnGoToManageDataVC.setTitle(" Manage Data ", for: .normal)
//    }
//    @objc func touchUpInside_goToManageDataVC(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
//            sender.transform = .identity
//        }, completion: nil)
//        performSegue(withIdentifier: "goToManageDataVC", sender: self)
//
//    }
//    func setup_btnTblDashboardOptions(){
////        if userStore.arryDashboardTableObjects.count >= 2 {
//            btnTblDashboardOptions = UIButton()
//            guard let btnTblDashboardOptions = btnTblDashboardOptions else {return}
//            view.addSubview(btnTblDashboardOptions)
//            btnTblDashboardOptions.translatesAutoresizingMaskIntoConstraints=false
//            btnTblDashboardOptions.accessibilityIdentifier="btnTblDashboardOptions"
//            btnTblDashboardOptions.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
//            btnTblDashboardOptions.addTarget(self, action: #selector(touchUpInside_btnTblDashboardOptions(_:)), for: .touchUpInside)
//            // vwFooter button Placement
//            btnTblDashboardOptions.topAnchor.constraint(equalTo: vwFooter.topAnchor, constant: heightFromPct(percent: 2)).isActive=true
//            btnTblDashboardOptions.leadingAnchor.constraint(equalTo: vwFooter.leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
//            btnTblDashboardOptions.backgroundColor = .systemBlue
//            btnTblDashboardOptions.layer.cornerRadius = 10
//            btnTblDashboardOptions.setTitle(" Dashboards ", for: .normal)
////        }
//    }
//    @objc func touchUpInside_btnTblDashboardOptions(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
//            sender.transform = .identity
//        }, completion: nil)
//        //        let selectDashboardVC = SelectDashboardVC(arryDashboardTableObject: userStore.arryDashboardTableObjects)
//        let selectDashboardVC = SelectDashboardVC(userStore: userStore)
//        selectDashboardVC.delegate = self
//        selectDashboardVC.modalPresentationStyle = .overCurrentContext
//        selectDashboardVC.modalTransitionStyle = .crossDissolve
//        self.present(selectDashboardVC, animated: true, completion: nil)
//    }
//    func setup_btnRefreshDashboard(){
//        btnRefreshDashboard = UIButton()
//        view.addSubview(btnRefreshDashboard)
//        btnRefreshDashboard.translatesAutoresizingMaskIntoConstraints=false
//        btnRefreshDashboard.accessibilityIdentifier="btnRefreshDashboard"
//        btnRefreshDashboard.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
//        btnRefreshDashboard.addTarget(self, action: #selector(touchUpInside_btnRefreshDashboard(_:)), for: .touchUpInside)
//        // vwFooter button Placement
//        btnRefreshDashboard.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
//        btnRefreshDashboard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -2)).isActive=true
//        btnRefreshDashboard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 2)).isActive=true
//        btnRefreshDashboard.backgroundColor = .systemGray
//        btnRefreshDashboard.layer.cornerRadius = 10
//        btnRefreshDashboard.setTitle(" Refresh Table ", for: .normal)
//    }
//
//    @objc func touchUpInside_btnRefreshDashboard(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
//            sender.transform = .identity
//        }, completion: nil)
//        print("*--- self.userStore.arryDashboardTableObjects ---*")
//        if self.userStore.arryDashboardTableObjects.count > 0 {
//            print("count: \(self.userStore.arryDashboardTableObjects.count)")
//            print("0 dependentVarName: \(self.userStore.arryDashboardTableObjects[0].dependentVarName!)")
//            print("1 dependentVarName: \(self.userStore.arryDashboardTableObjects[1].dependentVarName!)")
//        }
//        self.userStore.callSendDashboardTableObjects { responseResult in
//            switch responseResult {
//            case let .success(arryDashboardTableObjects):
//                print("- DashboardVC userStore.callSendDashboardTableObjects received SUCCESSFUL response")
//
//                self.userStore.arryDashboardTableObjects = arryDashboardTableObjects
//                if self.userStore.currentDashboardObjPos == nil {
//                    self.userStore.currentDashboardObjPos = 0
//                }
//                self.userStore.currentDashboardObject = arryDashboardTableObjects[self.userStore.currentDashboardObjPos]
//                self.userStore.boolDashObjExists = true
//                self.userStore.writeObjectToJsonFile(object: arryDashboardTableObjects, filename: "arryDashboardTableObjects.json")
//                self.checkDashboardTableObject()
//
//            case let .failure(error):
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    if case UserStoreError.fileNotFound = error {
//                        print("* file not found error *")
//                        self.templateAlert(alertTitle: "", alertMessage: "No data exists. Go to Manage Data to add data for your dashboard.")
//                    } else {
//                        self.templateAlert(alertTitle: "Alert", alertMessage: "Failed to update data. Error: \(error)")
//                    }
//                }
//            }
//        }
//    }
//
//    @objc private func refreshData(_ sender: UIRefreshControl) {
//
//        self.userStore.callSendDataSourceObjects { responseResult in
//            switch responseResult{
//            case let .success(arryDataSourceObjects):
//                self.userStore.arryDataSourceObjects = arryDataSourceObjects
//                self.userStore.writeObjectToJsonFile(object: arryDataSourceObjects, filename: "arryDataSourceObjects.json")
//                //                self.refreshValuesInTable()
//                self.refreshDashboardTableObjects(sender)
//            case .failure(_):
//                print("No new data")
//                self.refreshDashboardTableObjects(sender)
//            }
//        }
//    }
//
//    func refreshDashboardTableObjects(_ sender: UIRefreshControl){
//        self.userStore.callSendDashboardTableObjects { responseResult in
//            DispatchQueue.main.async {
//                switch responseResult {
//                case let .success(arryDashboardTableObjects):
//                    print("- table updated")
//                    self.userStore.arryDashboardTableObjects = arryDashboardTableObjects
//                    self.userStore.writeObjectToJsonFile(object: arryDashboardTableObjects, filename: "arryDashboardTableObjects.json")
//                    self.tblDashboard.reloadData() // Reloads table view
//                    sender.endRefreshing()
//
//
//                    if self.userStore.arryDashboardTableObjects.count >= 2 && self.btnTblDashboardOptions == nil {
//                        self.setup_btnTblDashboardOptions()
//                    }
//
//                case let .failure(error):
//                    sender.endRefreshing() // Stop refreshing before showing alert
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        if case UserStoreError.fileNotFound = error {
//                            print("* file not found error *")
//                            self.templateAlert(alertTitle: "Error", alertMessage: "Dashboard file not found")
//                        } else {
//                            print("* failed to arryDashboardTableObjects from API *")
//                            self.templateAlert(alertTitle: "Alert", alertMessage: "Failed to update data. Error: \(error)")
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    //    func didSelectDashboard(dashboard: DashboardTableObject) {
//    func didSelectDashboard(currentDashboardObjPos:Int){
//        DispatchQueue.main.async{
//            self.userStore.currentDashboardObjPos = currentDashboardObjPos
//            self.userStore.currentDashboardObject = self.userStore.arryDashboardTableObjects[currentDashboardObjPos]
//            self.lblDashboardTitle.text = self.userStore.arryDashboardTableObjects[currentDashboardObjPos].dependentVarName
//            print("DashboardVC has a new self.dashboardTableObject")
//            print("self.dashboardTableObject: \(self.userStore.currentDashboardObject!.dependentVarName)")
//            // Update your view accordingly
//            self.tblDashboard.reloadData()
//        }
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "goToManageDataVC"){
//            let manageDataVC = segue.destination as! ManageDataVC
//            manageDataVC.userStore = self.userStore
//            manageDataVC.appleHealthDataFetcher = self.appleHealthDataFetcher
//            manageDataVC.healthDataStore = self.healthDataStore
//            manageDataVC.requestStore = self.requestStore
//
//        }
//
//    }
