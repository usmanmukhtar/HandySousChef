//
//  RecommendationTableView.swift
//  HandySousChef
//
//  Created by Usman Mukhtar on 20/04/2020.
//  Copyright © 2020 Usman Mukhtar. All rights reserved.
//

import UIKit

class Recommendation: UIViewController, PlayerVCDelegate {
    
    
    //MARK:- outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTab: UIView!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet var playerView: PlayerView!
    
    //MARK:- variables
    var arrSectionTitle = ["","Have some dessert with that"]
    var queryParam = ""
    var message: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playerView)
        }
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            print("This VC is 'will' be popped. i.e. the back button was pressed.")
            playerView.removeFromSuperview()
        }
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if self.isMovingFromParent {
//            
//        }
//    }
    
    let hiddenOrigin: CGPoint = {
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let x = -UIScreen.main.bounds.width
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    let minimizedOrigin: CGPoint = {
        let x = UIScreen.main.bounds.width/2 - 10
        let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 10
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }()
    
    let fullScreenOrigin = CGPoint.init(x: 0, y: 0)
    
    func animatePlayView(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.beginFromCurrentState], animations: {
                self.playerView.frame.origin = self.fullScreenOrigin
            })
        case .minimized:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.minimizedOrigin
            })
        case .hidden:
            UIView.animate(withDuration: 0.3, animations: {
                self.playerView.frame.origin = self.hiddenOrigin
            })
        }
    }
    
    func positionDuringSwipe(scaleFactor: CGFloat) -> CGPoint {
        let width = UIScreen.main.bounds.width * 0.5 * scaleFactor
        let height = width * 9 / 16
        let x = (UIScreen.main.bounds.width - 10) * scaleFactor - width
        let y = (UIScreen.main.bounds.height - 10) * scaleFactor - height
        let coordinate = CGPoint.init(x: x, y: y)
        return coordinate
    }
    
    func didMinimize() {
        self.animatePlayView(toState: .minimized)
    }
    
    func didmaximize(){
        self.animatePlayView(toState: .fullScreen)
    }
    
    func didEndedSwipe(toState: stateOfVC){
        self.animatePlayView(toState: toState)
    }
    
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC){
        switch toState {
        case .fullScreen:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        case .hidden:
            self.playerView.frame.origin.x = UIScreen.main.bounds.width/2 - abs(translation) - 10
            self.playerView.ingredients.removeAll()
            self.playerView.steps.removeAll()
            self.playerView.Notes.reloadData()
        case .minimized:
            self.playerView.frame.origin = self.positionDuringSwipe(scaleFactor: translation)
        }
    }
    
    func setPreferStatusBarHidden(_ preferHidden: Bool) {
        self.isHidden = preferHidden
    }
    
    var isHidden = true {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
}

extension Recommendation {
    
    //MARK:- UISetup
    func setupUI(){
        
        //query param
        switch message {
        case 0:
            queryParam = "Breakfast Desi Recipe"
        case 1:
            queryParam = "Lunch Desi Recipe"
        case 2:
            queryParam = "Dinner Desi Recipe"
        default:
            queryParam = "Desi Recipe"
        }
        
        //navigationbar config
        self.title = "Suggestions"
        navigationController?.navigationBar.prefersLargeTitles = true

        //tableview config

        self.tableView.register(UINib(nibName: "RecommendationTVC", bundle: nil), forCellReuseIdentifier: "RecommendationTVC")
        self.tableView.register(UINib(nibName: "DessertTableViewCell", bundle: nil), forCellReuseIdentifier: "DessertTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.keyboardDismissMode = .onDrag
        
        //search tab
        self.searchTab.layer.shadowRadius = 20
        self.searchTab.layer.shadowColor = UIColor(named: "shadow-color")?.cgColor
        self.searchTab.layer.shadowOpacity = 0.5
        self.searchTab.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.searchTab.layer.shadowPath = UIBezierPath(rect: searchTab.bounds).cgPath
        
        //searchbar
        searchView.delegate = self
        if let textFieldInsideSearchBar = self.searchView.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView{

                //Magnifying glass
                glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
                glassIconView.tintColor = .white
        }
        
        //PLayerView setup
        self.playerView.frame = CGRect.init(origin: self.hiddenOrigin, size: UIScreen.main.bounds.size)
        self.playerView.delegate = self
        
    }
}

extension Recommendation: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 35
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        returnedView.backgroundColor = UIColor(named: "componentsBackground")
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 35))
        label.text = arrSectionTitle[section]
        label.font = UIFont(name: "ArialHebrew-Bold", size: 20)
        label.textColor = UIColor(named: "componentsWLbl")
        returnedView.addSubview(label)
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var customCell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendationTVC", for: indexPath) as! RecommendationTVC
            cell.queryParam = self.queryParam
            cell.awakeFromNib()
            customCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DessertTableViewCell", for: indexPath) as! DessertTableViewCell
            customCell = cell
        default:
            print("default value")
        }
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.height / 2
    }
}

extension Recommendation: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "VideoList") as! VideoList
        nextViewController.queryParam = (searchBar.text == "" ? "Cooking recipe" : searchBar.text ?? "Cooking recipe")
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
