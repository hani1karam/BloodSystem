//
//  NetworkManager.swift
//  BloodSystem
//
//  Created by Hany Karam on 8/5/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import Foundation
import Alamofire
struct NetworkingManager {
    static let shared: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        let sessionManager = Alamofire.SessionManager(configuration: configuration)
        return sessionManager
    }()
}

class NetworkMangerUser {
    
    
    
    static let instance = NetworkMangerUser()
    
    func registerNewUser (userInfoDict : [String:Any] , completion : @escaping( RegisterModel? , Error?) -> ()) {
        let headers = ["Content-Type" : "application/json"]
        Alamofire.request("https://salemsaber.com/websites/hospital/api/register", method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(RegisterModel.self, from: response.data!)
                    print(responseModel)
                    completion(responseModel , nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    } // Register Function
    
    static let jsonDecoder = JSONDecoder()
    
    
    func loginUser (userInfoDict : [String:Any] , completion:@escaping ( LoginModel? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        Alamofire.request("https://salemsaber.com/websites/hospital/api/login", method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(LoginModel.self, from: response.data!)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    } //Login
    
    
    
    func loginHospital (userInfoDict : [String:Any] , completion:@escaping ( SignIn? ,  Error?) -> Void) {
        let headers = ["content-type" : "application/json"]
        
        Alamofire.request("https://salemsaber.com/websites/hospital/api/hospitalLogin", method: .post, parameters: userInfoDict, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(SignIn.self, from: response.data!)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error.localizedDescription)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    } // login for hosptial
    
    class func sendRequest<T: Decodable>( userImage: Data? = nil, method: HTTPMethod, url: String, parameters:[String:Any]? = nil, header: [String:String]?  = nil, completion: @escaping (_ error: Error?, _ response: T?)->Void) {
        NetworkingManager.shared.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .responseJSON { res -> Void in
                print(res.result.value)
                switch res.result
                {
                case .failure(let error):
                    completion(error,nil)
                case .success(_):
                    if let dict = res.result.value as? Dictionary<String, Any>{
                        
                        print(dict)
                        
                        do{
                            guard let data = res.data else { return }
                            let response = try JSONDecoder().decode(T.self, from: data)
                            completion(nil,response)
                        }catch let err{
                            print("Error In Decode Data \(err.localizedDescription)")
                            completion(err,nil)
                        }
                    }else{
                        completion(nil,nil)
                    }
                }
        }
        
    }
    
    
}
