//
//  ViewController.swift
//  VideoDDemo
//
//  Created by Jun  on 11/21/17.
//  Copyright © 2017 Arjuna. All rights reserved.
//

import UIKit
import CoreImage


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detect()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func Import(_ sender: Any)
    {
        //membuat image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        //display imagePicker
        self.present(imagePicker, animated: true, completion: nil)
    }
    // pick up the liblary
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
        myImageView.image = image
            
    }
    
        detect()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(){
        
        //get image from imageview
        let myImage = CIImage(image: myImageView.image!)!
        
        //set up the detector
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: myImage, options: [CIDetectorSmile:true])
        
        
        if !(faces?.isEmpty)!
        {
            for face in faces as! [CIFaceFeature]
            {
                let mouthShowing = "\nMouth is showing: \(face.hasMouthPosition)"
                let isSmilling = "\nMouth is smilling: \(face.hasSmile)"
                var bothEyesShowing = "\n Both eyes showing: true"
                
                if !face.hasRightEyePosition || !face.hasLeftEyePosition
                {
                    bothEyesShowing = "\n Both eyes showing: false"
                }
                
                //Degree of supnicess
                let array = ["Low", "Medium", "VeryHigh"]
                var supspectDegree = 0
                
                if !face.hasMouthPosition {supspectDegree += 1}
                if !face.hasSmile {supspectDegree += 1}
                if !bothEyesShowing.contains("false") {supspectDegree += 1}
                if face.faceAngle < 10 || face.faceAngle < -10 {supspectDegree += 1}
                
                let suspectText = "\nSuspiciousness: \(array[supspectDegree])"
                
                
                myTextView.text = "\(suspectText) \n\(mouthShowing) \(isSmilling) \(bothEyesShowing)"
                
                
            }
        }else
        {
            myTextView.text = "No faces found"
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}
