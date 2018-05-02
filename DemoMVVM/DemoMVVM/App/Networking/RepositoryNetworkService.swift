//
//  RepositoryNetworkManager.swift
//  DemoMVVM
//
//  Created by Apple on 05/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class RepositoryNetworkService : ServiceManager{
    
    func callRepositoryListService(_ language : Language , completionHandler : @escaping (_ serviceReponse : ServiceResponse<[Respository], RepositoryError>) -> Void){
        self.requestWithUrlSession("https://api.github.com/search/repositories?q=language:\(language.name!)&sort=stars", withParams: [:], andCompletion: { response in
            switch response{
                case .success(let dic):
                    guard let arrItems = dic["items"] as? [[String : Any]] else {
                        completionHandler(.failure(.httpError(.jsonError)))
                        return
                    }
                    
                    let arrRepositories = arrItems.flatMap(Respository.init)
                    completionHandler(.success(arrRepositories))
                
                case .failure(let error):
                    completionHandler(.failure(.httpError(error)))
            }
        }
    )}
}
