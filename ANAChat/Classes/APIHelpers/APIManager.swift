//
//  NFAPIManager.swift
//  NowFloats-iOSSDK
//
//  Created by Rakesh Tatekonda on 11/08/17.
//  Copyright © 2017 NowFloats. All rights reserved.
//

import UIKit
import MobileCoreServices

class APIManager: NSObject {
    static let sharedInstance = APIManager()
    static let baseUrl  = "http://chat-alpha.withfloats.com/"
    
    func getDataFromAPI(_ urlStr: String, input paramDict: [AnyHashable: Any], methodType: String, successBlock successCompletion: @escaping (_ data: [String: Any]) -> Void, failBlock failCompleation: @escaping (_ error: Error?) -> Void)
    {
        switch methodType.uppercased() {
        case "POST":
            self.post(params: paramDict as! Dictionary<String, String>, apiPath: urlStr, completionHandler: { (response) in
                successCompletion(response)
            })
            break
            
        case "GET":
            self.get(params: paramDict as? Dictionary<String, String>, apiPath: urlStr, completionHandler: { (response) in
                successCompletion(response)
            })
            break
            
        default:
            self.post(params: paramDict as! Dictionary<String, String>, apiPath: urlStr, completionHandler: { (response) in
                successCompletion(response)
            })
            break
        }
        /*
        if(methodType.uppercased() == "POST"){
            self.post(params: paramDict as! Dictionary<String, String>, url: urlStr, completionHandler: { (response) in
                successCompletion(response)
            })
        }else{
            self.get(params: paramDict as! Dictionary<String, String>, url: urlStr, completionHandler: { (response) in
                successCompletion(response)
            })
        }
         */
    }
    
    func post(params : [String: Any]?, apiPath : String? ,completionHandler:@escaping ([String: Any]) -> ()) {
        
        var finalApiPathString = String()
        
        if let apiPath = apiPath{
            finalApiPathString =  String(format:"%@%@", APIManager.baseUrl, apiPath)
        }else{
            finalApiPathString =  String(format:"%@", APIManager.baseUrl)
        }
        
        var finalParams = [String: Any]()
        if params == nil {
            finalParams = [:]
        }else{
            finalParams = params!
        }
        
        let finalUrl = NSURL(string: finalApiPathString)!
        var request = URLRequest(url: finalUrl as URL)
        request.httpMethod = "POST"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: finalParams, options: .prettyPrinted)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(String(jsonData.count), forHTTPHeaderField: "Content-Length")
        
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= 200 && httpStatus.statusCode <= 299 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
//                completionHandler(true)
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(json)
                        // handle json...
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }else{
                print("handle error")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func get(params : Dictionary<String, String>?, apiPath : String? ,completionHandler:@escaping ([String: Any]) -> ()) {
        
        var finalApiPathString = String()
        
        if let apiPath = apiPath{
           finalApiPathString =  String(format:"%@%@", APIManager.baseUrl, apiPath)
        }else{
            finalApiPathString =  String(format:"%@", APIManager.baseUrl)
        }

        var finalUrl = NSURL()
        if let parameterString = params?.stringFromHttpParameters()
        {
            finalApiPathString =  String(format:"%@?%@", finalApiPathString,parameterString)
            finalUrl = NSURL(string: finalApiPathString)!
        }else{
            finalUrl = NSURL(string: finalApiPathString)!
        }
        var request = URLRequest(url: finalUrl as URL)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= 200 && httpStatus.statusCode <= 299 {

                print("response = \(String(describing: response))")
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(json)
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }else{
                print("handle error")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func postMessageToServer(params : [String: Any]?, apiPath : String? , messageObject : Message,completionHandler:@escaping ([String: Any]) -> ()) {
        post(params: params, apiPath: apiPath) { (response) in
            completionHandler(response)
        }
    }
    
    // upload event
    func uploadMedia(withMedia videoPath: URL,completionHandler:@escaping ([String: Any]) -> ()){
        let url = NSURL(string: String(format:"%@files/", APIManager.baseUrl))
        let request = NSMutableURLRequest(url: url! as URL)
        let boundary = "------------------------chatBotSDK"
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var movieData: NSData?
        do {
            movieData = try NSData(contentsOfFile: (videoPath.relativePath), options: NSData.ReadingOptions.alwaysMapped)
        } catch _ {
            movieData = nil
            return
        }
        
        let body = NSMutableData()
        let filename = videoPath.lastPathComponent
        let mimetype = mimeTypeForPath(path: videoPath.absoluteString)
        let fileName: String = "file"

        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(movieData! as Data)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode >= 200 && httpStatus.statusCode <= 299{
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                //                completionHandler(true)
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(json)
                        // handle json...
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }

    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    func uploadImage(withMedia image: UIImage,completionHandler:@escaping ([String: Any]) -> ()){

        let url = NSURL(string: String(format:"%@files/", APIManager.baseUrl))
        let request = NSMutableURLRequest(url: url! as URL)
        let boundary = "------------------------chatBotSDK"
    
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        let filename = "\(arc4random()).jpeg"
//        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        //which field you have to sent image on server
        let fileName: String = "file"
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body as Data
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                //                completionHandler(true)
                
                do {
                    //create json object from data
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        
        task.resume()
    }

}
