//
//  RespositoryVC.swift
//  DemoMVVM
//
//  Created by Dhawal Dawar on 04/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RespositoryViewController: UIViewController {
    
    lazy var repositoryViewModel : RespositoryViewModel = RespositoryViewModel(delegate: self)
    
    @IBOutlet fileprivate weak var tblRepository : UITableView!
    @IBOutlet fileprivate weak var lblLoading : UILabel!
    @IBOutlet fileprivate weak var activityIndicator : UIActivityIndicatorView!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK- Private Methods
    private func setupView(){
        // Setup tableview row height
        self.tblRepository.estimatedRowHeight = 60
        self.tblRepository.rowHeight = UITableViewAutomaticDimension
    }
    
    private func enableLoading(_ isLoading : Bool){
        tblRepository.isHidden = isLoading
        lblLoading.isHidden = !isLoading
        activityIndicator.isHidden = !isLoading
    }
    
    //MARK: Navigation
    @IBAction func btnLanguageAction(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let languageViewController = storyBoard.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageViewController.languageViewModel = repositoryViewModel.getSelectedLanguageViewModel()
        self.navigationController?.pushViewController(languageViewController, animated: true)
    }
}

extension RespositoryViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.title = self.repositoryViewModel.title
        return repositoryViewModel.arrRepositoryCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblRepository.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath) as! RepositoryCell
        cell.configureCell(repositoryViewModel.arrRepositoryCellModels[indexPath.row])
        
        return cell
    }
}

extension RespositoryViewController : RespositoryViewModelDelegate{
    func didStartLoadingRepository() {
        self.title = repositoryViewModel.title
        self.enableLoading(true)
    }
    
    func refreshRepositoriesList() {
        DispatchQueue.main.async { [weak self] in
            self!.title = self!.repositoryViewModel.title
            self!.enableLoading(false)
            self!.tblRepository.reloadData()
            
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func showError(_ errMsg : String){
        DispatchQueue.main.async { [weak self] in
            self!.enableLoading(false)
            let alertController = UIAlertController.init(title: "", message: errMsg, preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
                self!.dismiss(animated: true, completion: {
                })
            }
            alertController.addAction(okAction)
            self!.present(alertController, animated: true, completion: {
            })
        }
    }
}
