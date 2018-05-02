//
//  LangaugeViewModel.swift
//  DemoMVVM
//
//  Created by Dhawal ideavate on 12/04/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

protocol LanguageViewModelDelegate : class{
    func navigateBackToPreviousView()
}

protocol LanguageSelectionDelegate : class{
    func didSelectLanguage(language : Language)
}

class LanguageViewModel{
    
    weak var delegate : LanguageViewModelDelegate!
    weak var delegateSelection : LanguageSelectionDelegate!
    
    var count : Int{
        return arrLanguages.count
    }
   
    init(language : Language) {
        self.selectedLanguage = language
        setupLanguageList()
    }
    
    //Mark:- Private variables
    private var arrLanguages = [Language]()
    private var selectedLanguage : Language!
    
    func getTitleForLanguageIndex(_ index : Int) -> (language: String,isSelected: Bool){
        let language = arrLanguages[index]
        let selected =  selectedLanguage.name == language.name
        return (language.name, selected)
    }
    
    func selectLanguageAtIndex(_ index : Int){
        let language = arrLanguages[index]
        delegateSelection.didSelectLanguage(language: language)
        delegate.navigateBackToPreviousView()
    }
    
    //Mark:- Private functions
    private func setupLanguageList(){
        arrLanguages.append(Language(name: "Swift"))
        arrLanguages.append(Language(name: "Java"))
        arrLanguages.append(Language(name: "Python"))
        arrLanguages.append(Language(name: "Php"))
        arrLanguages.append(Language(name: "Scala"))
        arrLanguages.append(Language(name: "Javascript"))
    }
    
}
