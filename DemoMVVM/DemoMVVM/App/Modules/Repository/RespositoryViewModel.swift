//
//  RespositoryViewModel.swift
//  DemoMVVM
//
//  Created by Apple on 04/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol RespositoryViewModelDelegate : class{
    func didStartLoadingRepository()
    func refreshRepositoriesList()
    func showError(_ errMsg : String)
}

public final class RespositoryViewModel{
    
    //MARK:- Public Variables
    weak var delegate : RespositoryViewModelDelegate?
    var arrRepositoryCellModels : Array<RepositoryCellViewModel> = []
    var title : String{
        return "\(selectedLanguage.name!) Repo"
    }
    
    //MARK:- Private Variables
    private var repoService : RepositoryNetworkService!
    private var selectedLanguage = Language(name: "Swift")
    
    //MARK:- Public Functions
    init(delegate : RespositoryViewModelDelegate?) {
        self.delegate = delegate
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self!.refreshRepositoryDetails()
        }
    }
    
    func getSelectedLanguageViewModel() -> LanguageViewModel{
        let languageViewModel = LanguageViewModel(language: selectedLanguage)
        languageViewModel.delegateSelection = self
        return languageViewModel
    }
    
    //MARK:- Private Functions
    private func refreshRepositoryDetails(){
        delegate?.didStartLoadingRepository()
        repoService = RepositoryNetworkService()
        repoService.callRepositoryListService(selectedLanguage, completionHandler: { [weak self] (serviceResponse) in
            switch serviceResponse{
                case .success(let arrRepositories):
                    self?.arrRepositoryCellModels = arrRepositories.flatMap(RepositoryCellViewModel.init)
                    self?.delegate?.refreshRepositoriesList()
                case .failure(let error):
                    let errMsg : String
                    switch error{
                        case .httpError(let httpErr):
                            switch httpErr{
                                case .jsonError:
                                errMsg = "Json Error"
                                
                                case .networkError:
                                errMsg = "Network Error"
                                
                                case .requestTimedOut:
                                errMsg = "Request Timed Out"
                            }
                        
                        case .repositoriesNotFound:
                            errMsg = "Repositories not found"
                    }
                    self?.delegate?.showError(errMsg)
            }
        })
    }
}

extension RespositoryViewModel : LanguageSelectionDelegate{
    
    func didSelectLanguage(language: Language) {
        selectedLanguage = language
        refreshRepositoryDetails()
    }
}

