//
//  ChangeGitLanguageVC.swift
//  DemoMVVM
//
//  Created by Apple on 07/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {
    
    var languageViewModel : LanguageViewModel!
    
    @IBOutlet weak var tblLanguage : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        languageViewModel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LanguageViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblLanguage.dequeueReusableCell(withIdentifier: "ChangeLanguageCell", for: indexPath) as! ChangeLanguageCell
        let obj = languageViewModel.getTitleForLanguageIndex(indexPath.row)
        cell.lblLanguage.text = obj.language
        cell.lblCheck.isHidden = !obj.isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        languageViewModel.selectLanguageAtIndex(indexPath.row)
    }
}

extension LanguageViewController : LanguageViewModelDelegate{
    func navigateBackToPreviousView() {
        self.navigationController?.popViewController(animated: true)
    }
}
