//
//  ImageCache.swift
//  RiaChatSDK
//
//  Created by Rakesh Tatekonda on 17/08/17.
//  Copyright © 2017 Mine. All rights reserved.
//

import UIKit
import ImageIO


class ImageCache: NSObject {
    
    static let sharedInstance: ImageCache =
    {
        let instance = ImageCache()
        return instance
    }()
    
    override init()
    {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearImageCache), name: .UIApplicationWillTerminate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearImageCache), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        
    }
    
    
    func storeLocalImage(_ localImgURl: NSString, withImage image: UIImage)
    {
        let imgURLStr : String = localImgURl as String
        
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let imgpath : String = "SDKImages/"+self.getTrimedImageURL(withURL: imgURLStr)
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(imgpath)
        
        if !FileManager.default.fileExists(atPath: fileURL.path)
        {
            let imgData : Data = (UIImagePNGRepresentation(image) as Data?)!
            
            do
            {
                try imgData.write(to: fileURL)
                
                print("Image Added Successfully")
                print("Image Path: \(fileURL.path)")
                
                
            }
            catch
            {
                print("image write error : \(error)")
            }
        }
        else
        {
            
        }
        
    }
        
    
    func getImageFromURL(_ urlStr: String, successBlock successCompletion: @escaping (_ data: Data) -> Void, failBlock failCompletion: @escaping (_ error: Error?) -> Void)
    {
        let imgURLStr : String = urlStr
        
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let imgpath : String = "SDKImages/"+self.getTrimedImageURL(withURL: imgURLStr)
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(imgpath)
        
        
        if !FileManager.default.fileExists(atPath: fileURL.path)
        {
            DispatchQueue.global(qos: .default).async {
                
                do
                {
                    let imgData : Data = try Data(contentsOf: URL(string: imgURLStr)!)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                    {
//                        let imageFromData = UIImage(data: (imgData as NSData) as Data)
                        
                        do
                        {
                            try imgData.write(to: fileURL)
                            
                            print("Image Added Successfully")
                            print("Image Path: \(fileURL.path)")
                            
                            successCompletion(imgData)
                            
                        }
                        catch
                        {
                            print("image write error : \(error)")
                            failCompletion(error)
                        }
                        
                    }
                }
                catch
                {
                    print("image download error : \(error)")
                    failCompletion(error)
                }
            }
        }
        else
        {
            print("Image Cached")
            do
            {
                let imgData : NSData = try NSData.init(contentsOfFile: fileURL.path)
                successCompletion(imgData as Data)
            }
            catch
            {
                print("Image cache error")
                failCompletion(error)
            }
            
        }
        
    }
    
    
    func initilizeImageDirectory()
    {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("SDKImages")
        do {
            try FileManager.default.createDirectory(at: logsPath!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("Unable to create image cache directory \(error.debugDescription)")
        }
    }
    
    
    @objc func clearImageCache()
    {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = documentsDirectoryURL.appendingPathComponent("SDKImages")
        
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(atPath: fileURL.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func getTrimedImageURL(withURL imgURLStr: String) -> String
    {
        let unfilteredString: String = imgURLStr
        let notAllowedChars = CharacterSet(charactersIn: "!@#$%^&*()_+|abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890").inverted
        let resultString = (unfilteredString.components(separatedBy: notAllowedChars) as NSArray).componentsJoined(by: "")
        
        return resultString
        
    }
    
    
    //////    GIF IMAGE
    
    func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return self.animatedImageWithSource(source)
    }
    
    func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = self.delayForImageAtIndex(Int(i),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to milliseconds
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = self.gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
    func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = self.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
}
