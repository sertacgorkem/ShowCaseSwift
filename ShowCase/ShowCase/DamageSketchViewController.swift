//
//  DamageSketchViewController.swift
//  CollApp
//
//  Created by Sertac Selim Gorkem on 1/23/20.
//  Copyright © 2020 Memduh Gorkem. All rights reserved.
//

import UIKit


class DamageSketchViewController: UIViewController {

    
     weak var delegate:DamageSketchDelegate?
     
     @IBOutlet weak var signatureView: UIImageView!
     
     
    var imageID = 0
    var latestSignPoint: CGPoint!
    var tapCount :Int = 0
    var fieldValue  = ""
    var citeSgn: [String: String] = [String: String]()
    var signatureImage: UIImage = UIImage()
    var SignatureLines = [SignLine]()
    var previousLines = [SignLine]()
    var fromLoad = false
     //var SavedSignatureLines = [SignLine]()
     @IBOutlet weak var toolbarTop: UIImageView!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.isUserInteractionEnabled = true
        if (fieldValue as NSString).length > 10{
            signatureImage = loadImageFromVals(rawString: fieldValue, fromVC: true)
            fromLoad = true
            if (SignatureLines.count > 0) {
                latestSignPoint = SignatureLines[SignatureLines.count-1].end
            }
            self.signatureView.image = signatureImage
            
            
        }

    }
    
    override public func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        if fromLoad == true{
            fromLoad = false
            signatureImage = resizeImage(image: signatureImage, targetSize: self.signatureView.frame.size)
        }
        
        if let firstTouch = touches.first {
              let touchPoint = firstTouch.location(in: signatureView)
              let _x: CGFloat = CGFloat(Int(touchPoint.x ))
              let _y: CGFloat = CGFloat(Int(touchPoint.y ))
              latestSignPoint = CGPoint(x: _x, y: _y)
              
          }
      }
      
      override public func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
          if fromLoad == true{
              fromLoad = false
              signatureImage = resizeImage(image: signatureImage, targetSize: self.signatureView.frame.size)
          }
        
        if let firstTouch = touches.first {
              let touchPoint = firstTouch.location(in: signatureView)
              let _x: CGFloat = CGFloat(Int(touchPoint.x ))
              let _y: CGFloat = CGFloat(Int(touchPoint.y ))
              if (latestSignPoint != CGPoint(x: _x, y: _y)) {
                let _sgnLn: SignLine = SignLine(startX: Int(latestSignPoint!.x), startY: Int(latestSignPoint.y), endX: Int(_x), endY: Int(_y))
                SignatureLines.append(_sgnLn)
                let imageSize = self.signatureView.frame.size
                let scale: CGFloat = 0
                UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
                let context = UIGraphicsGetCurrentContext()
                signatureImage.draw(at: CGPoint(x: 0, y: 0))
                context!.setLineWidth(CGFloat(3))
                context!.setStrokeColor(UIColor.blue.cgColor)



                context!.move(to: CGPoint(x: latestSignPoint.x, y: latestSignPoint.y))
                context!.addLine(to: CGPoint(x: _x, y: _y))
                context!.strokePath()
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                signatureImage = newImage!
                self.signatureView.image = signatureImage
                latestSignPoint = CGPoint(x: _x, y: _y)
                //print ("touch moved: \(latestSignPoint.x)  \(latestSignPoint.y) "    )

              }
          }
      }
      
      override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
          
      }
      
      
      
    @IBAction func trashButtonTapped(_ sender: Any) {

        SignatureLines.removeAll()
        previousLines.removeAll()
        signatureImage = UIImage()
        self.signatureView.image = signatureImage
        imageID = -1
    }
      
    
    @IBAction func defaultButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "defaultDamage") ?? UIImage(), targetSize: self.signatureView.frame.size)
        self.signatureView.image = signatureImage
        imageID = 3
        //imageType = .Default
    }
    
    @IBAction func carButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "car1_sketch") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 1
    }
    @IBAction func car2dButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "car2d_bp") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 2
    }
    @IBAction func suvButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "suv_bp") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 4
    }
    @IBAction func minivanButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "minivan_bp") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 5
    }
    @IBAction func truckButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "truck_bp") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 6
    }
    @IBAction func motorbikeButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "motorbike_sketch") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 7
    }
    @IBAction func bicycleButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "bicycle_sketch_bp") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 8
    }
    @IBAction func rigButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "truck_sketch") ?? UIImage(), targetSize: self.signatureView.frame.size)
        signatureImage = redrawLines(sigImage: signatureImage)
        self.signatureView.image = signatureImage
        imageID = 9
    }
    @IBAction func freightButtonTapped(_ sender: Any) {
        signatureImage = resizeImage(image: UIImage(named: "freight_sketch") ?? UIImage(), targetSize: self.signatureView.frame.size)
        
        self.signatureView.image = signatureImage
        imageID = 10
    }
    
    func redrawLines(sigImage: UIImage)->UIImage{
        var img = sigImage
        if previousLines.count > 0{
            img = drawLines(image: sigImage, lineArr: previousLines)
        }
        if SignatureLines.count > 0{
            img = drawLines(image: img, lineArr: SignatureLines)
        }

        return img
    }
    
    
      
    @IBAction func exitButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

      


    @IBAction func saveTapped(_ sender: Any) {


        var jsonString = ""

        var base64Encoded = ""
        let encoder = JSONEncoder ()

        do{
            var originalSize = signatureView.frame.size
            if let image = damageImageDictionary[imageID]{

                originalSize = UIImage(named: image)!.size
            }
            let ratio = getImageRatio(imageSize: originalSize, rect: signatureView.frame.size)
            var i = 0
            while(i < SignatureLines.count){
                var _line = SignatureLines[i]
                _line.start.x = (_line.start.x / ratio).rounded(.toNearestOrEven)
                _line.start.y =  (_line.start.y / ratio).rounded(.toNearestOrEven)
                _line.end.x = (_line.end.x / ratio).rounded(.toNearestOrEven)
                _line.end.y = (_line.end.y / ratio).rounded(.toNearestOrEven)
                SignatureLines[i] = _line
                i = i + 1
            }
            if previousLines.count > 0 {
                SignatureLines.append(contentsOf: previousLines)
            }
            let encodedData = try! encoder.encode (SignatureLines)
            let encodedString = String (bytes: encodedData, encoding: .utf8)!
           


            var substr = removeFrontAndLast(value: encodedString)

            substr = substr.replacingOccurrences(of: "[", with: "\"")
            substr = substr.replacingOccurrences(of: "]", with: "\"")



            jsonString = "{\"DiagramLines\":[" + substr + "]," + "\"ImageID\":\(imageID)}"
        }catch{}

        if let data = (jsonString).data(using: String.Encoding.utf8) {
            base64Encoded = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))

            //print(base64Encoded)// dGVzdDEyMw==\n
        }


        self.delegate?.damageSketchSaved( _encodedData: base64Encoded)
        self.dismiss(animated: true, completion: nil)

    }
  
    
    func retrieveSignLine(text: String) -> [SignLine]{
        var SignLineArr = [SignLine]()
        if let startIndex = text.range(of: "[")?.lowerBound {
            if let endIndex = text.range(of: "]")?.lowerBound{
                let str = text[startIndex..<endIndex]
                var subst = String(str)
                subst = subst.replacingOccurrences(of: "\"start\"", with: "'start'")
                subst = subst.replacingOccurrences(of: "\"end\"", with: "'end'")
                subst = subst.replacingOccurrences(of: ":\"", with: ":[")
                subst = subst.replacingOccurrences(of: "\"", with: "]")
                subst = subst.replacingOccurrences(of: "'start'", with: "\"start\"")
                subst = subst.replacingOccurrences(of: "'end'", with: "\"end\"")
                
                subst = subst + "]"
                if let data = subst.data(using: .utf8) {
                    do {
                        let jsonDecoder = JSONDecoder()
                        SignLineArr = try jsonDecoder.decode([SignLine].self, from: data)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
            }else{
            }
    //
        }else{
        }


        return SignLineArr
    }

    
    
    
    
    func loadImageFromVals(rawString: String, fromVC: Bool) -> UIImage{
    
        let decodedData = Data(base64Encoded: (rawString as String))!
        let decodedString = String(data: decodedData, encoding: .utf8)!
        
        let _dictionary = convertToDictionary(text: decodedString)
        let linesArr = retrieveSignLine(text: decodedString)
        
        let id = _dictionary!["ImageID"] as! Int
        var img: UIImage
        
        
        if fromVC == true{
            previousLines = linesArr
            imageID = id
            if let fileName = damageImageDictionary[id]{
                
                
                let originalImage = UIImage(named: fileName) ?? UIImage()
                
                let oldShrinkedLines = shrinkLineArr(lineArr: previousLines, originalImage: originalImage)
                img = resizeImage(image: originalImage, targetSize: self.signatureView.frame.size)
                
                
                img = drawLines(image: img, lineArr: oldShrinkedLines)
                
                
                
                
            }else{
                img = UIImage()
            }
            
            
        }else{
            if let fileName = damageImageDictionary[id]{
                let originalImage = UIImage(named: fileName) ?? UIImage()
                
                let oldShrinkedLines = shrinkLineArr(lineArr: previousLines, originalImage: originalImage)
                img = resizeImage(image: originalImage, targetSize: self.signatureView.frame.size)
                
                
                img = drawLines(image: img, lineArr: oldShrinkedLines)
            }else{
                img = UIImage()
            }
        }
        return img
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
   
    
    func drawLines(image: UIImage, lineArr: [SignLine]) -> UIImage{
         //let _sgnLn: SignLine = SignLine(startX: Int(latestSignPoint!.x), startY: Int(latestSignPoint.y), endX: Int(_x), endY: Int(_y))
          //SignatureLines.append(_sgnLn)
        let imageSize = image.size
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint(x: 0, y: 0))
        context!.setLineWidth(CGFloat(3))
        context!.setStrokeColor(UIColor.blue.cgColor)

        for _line in lineArr{
            context!.move(to: CGPoint(x: _line.start.x, y: _line.start.y))
            context!.addLine(to: CGPoint(x: _line.end.x, y: _line.end.y))
            context!.strokePath()
        }
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func getImageRatio(imageSize: CGSize, rect: CGSize) -> CGFloat{
        var ratio: CGFloat = 1
        
        let widthRatio  = rect.width  / imageSize.width
        let heightRatio = rect.height / imageSize.height
        
        // Figure out what our orientation is, and use that to form the rectangle

        
        if(widthRatio > heightRatio) {
            ratio = heightRatio
            //newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            ratio = widthRatio
            //newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        return ratio
    }
    
    
    func shrinkLineArr(lineArr: [SignLine], originalImage: UIImage) -> [SignLine]{
        var oldShrinkedLines = [SignLine]()
        let originalSize = originalImage.size
        let ratio = getImageRatio(imageSize: originalSize, rect: signatureView.frame.size)
        var i = 0
        while(i < lineArr.count){
            var _line = lineArr[i]
            _line.start.x = (_line.start.x * ratio).rounded(.toNearestOrEven)
            _line.start.y =  (_line.start.y * ratio).rounded(.toNearestOrEven)
            _line.end.x = (_line.end.x * ratio).rounded(.toNearestOrEven)
            _line.end.y = (_line.end.y * ratio).rounded(.toNearestOrEven)
            oldShrinkedLines.append(_line)
            i = i + 1
        }
        return oldShrinkedLines
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
