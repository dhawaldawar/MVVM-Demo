//
//  ServiceManager.swift
//  DemoMVVM
//
//  Created by Apple on 05/02/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ServiceManager {
    
    private var dataTask : URLSessionDataTask?
    
    func requestWithUrlSession(_ strUrl: String, withParams params: [AnyHashable: Any], andCompletion completionBlock: @escaping (_ serviceResponse: ServiceResponse<[String : Any], HTTPError>) -> Void){
        
        let request = NSMutableURLRequest(url: NSURL(string: strUrl)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        
        // Invalidate and cancel
        // Required brief detail
        session.invalidateAndCancel()
        
        dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
            if (error != nil) {
                completionBlock(.failure(.networkError))
            } else {
                guard let responseDict = (try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as? [String : Any] else{
                    completionBlock(.failure(.jsonError))
                    return
                }
                
                completionBlock(.success(responseDict))
            }
            self?.dataTask = nil
        })
        
        dataTask!.resume()
    }
    
    func cancel(){
        if(dataTask != nil){
            dataTask?.cancel()
            dataTask = nil
        }
    }
}
