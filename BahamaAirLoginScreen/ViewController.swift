/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

// A delay function
func delay(seconds seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}


class ViewController: UIViewController {
    
    // MARK: IB outlets
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var heading: UILabel!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var cloud1: UIImageView!
    @IBOutlet var cloud2: UIImageView!
    @IBOutlet var cloud3: UIImageView!
    @IBOutlet var cloud4: UIImageView!
    
    
    // MARK: further UI
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    let status = UIImageView(image: UIImage(named: "banner"))
    let label = UILabel()
    let messages = ["Connecting ...", "Authorizing ...", "Sending credentials ...", "Failed"]
    let info = UILabel()
    
    // MARK: variables
    
    var statusPosition = CGPoint.zero
    var spinnerPosition = CGPoint.zero
    
    // MARK: view controller methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the UI
        loginButton.layer.cornerRadius = 8.0
        loginButton.layer.masksToBounds = true
        
        spinner.frame = CGRect(x: -20.0, y: 6.0, width: 20.0, height: 20.0)
        spinnerPosition = spinner.frame.origin
        spinner.startAnimating()
        spinner.alpha = 0.0
        loginButton.addSubview(spinner)
        
        status.hidden = true
        status.center = loginButton.center
        statusPosition = status.center
        view.addSubview(status)
        
        label.frame = CGRect(x: 0.0, y: 0.0, width: status.frame.size.width, height: status.frame.size.height)
        label.font = UIFont(name: "HelveticaNeue", size: 18.0)
        label.textColor = UIColor(red: 0.89, green: 0.38, blue: 0.0, alpha: 1.0)
        label.textAlignment = .Center
        status.addSubview(label)
        
        info.frame = CGRect(x: 0.0, y: loginButton.center.y + 60.0, width: view.frame.width, height: 30)
        info.font = UIFont(name: "HelveticaNeue", size: 12.0)
        info.textColor = UIColor.whiteColor()
        info.textAlignment = .Center
        info.text = "Tap on a field and enter username and password"
        view.addSubview(info)
 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        heading.center.x -= view.bounds.width
//        username.center.x -= view.bounds.width
//        password.center.x -= view.bounds.width
//        loginButton.center.y += 30
//        loginButton.alpha = 0.0
        
        cloud1.layer.opacity = 0.0
        cloud2.layer.opacity = 0.0
        cloud3.layer.opacity = 0.0
        cloud4.layer.opacity = 0.0
//        cloud1.alpha = 0.0
//        cloud2.alpha = 0.0
//        cloud3.alpha = 0.0
//        cloud4.alpha = 0.0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        username.delegate = self
        password.delegate = self
        
        let formGroup = CAAnimationGroup()
        formGroup.duration = 0.5
        formGroup.fillMode = kCAFillModeBackwards
        
        let fadeText = CABasicAnimation(keyPath: "opacity")
        fadeText.fromValue = 0.25
        fadeText.toValue = 1.0
        
        let flyRight = CABasicAnimation(keyPath: "position.x")
        flyRight.fromValue = -view.bounds.width/2
        flyRight.toValue = view.bounds.width/2
        
        formGroup.animations = [fadeText, flyRight]
        heading.layer.addAnimation(formGroup, forKey: nil)
        
        formGroup.delegate = self
        formGroup.setValue("form", forKey: "name")
        formGroup.setValue(username.layer, forKey: "layer")
        formGroup.beginTime = CACurrentMediaTime() + 0.3
        username.layer.addAnimation(formGroup, forKey: nil)
        
        formGroup.setValue(password.layer, forKey: "layer")
        formGroup.beginTime = CACurrentMediaTime() + 0.4
        password.layer.addAnimation(formGroup, forKey: nil)
        
        let flyLeft = CABasicAnimation(keyPath: "position.x")
        flyLeft.fromValue = info.layer.position.x + view.bounds.width
        flyLeft.toValue = info.layer.position.x
        flyLeft.duration = 5.0
//        flyLeft.repeatCount = 2.5  // use half an animation cycle to avoid label jump from offscreen to center
//        flyLeft.autoreverses = true
        info.layer.addAnimation(flyLeft, forKey: "infoappear")
        
        let fadeLabelIn = CABasicAnimation(keyPath: "opacity")
        fadeLabelIn.fromValue = 0.2
        fadeLabelIn.toValue = 1.0
        fadeLabelIn.duration = 4.5
        info.layer.addAnimation(fadeLabelIn, forKey: "fadein")
        
//        UIView.animateWithDuration(0.5) {
//            self.heading.center.x += self.view.bounds.width
//        }
//        UIView.animateWithDuration(0.5, delay: 0.3, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
//            self.username.center.x += self.view.bounds.width
//            }, completion: nil)
//        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
//            self.password.center.x += self.view.bounds.width
//            }, completion: nil)
        
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() + 0.5
        group.duration = 0.5
        group.fillMode = kCAFillModeBackwards
        
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.fromValue = 3.5
        scaleDown.toValue = 1.0
        
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = CGFloat(M_PI_4)
        rotate.toValue = 0.0
        
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.0
        fadeIn.toValue = 1.0
        
        group.animations = [scaleDown, rotate, fadeIn]
        group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        loginButton.layer.addAnimation(group, forKey: nil)
        
//        UIView.animateWithDuration(0.5,
//                                   delay: 0.5,
//                                   usingSpringWithDamping: 0.5,
//                                   initialSpringVelocity: 0.0,
//                                   options: [],
//                                   animations: {
//                                    self.loginButton.center.y -= 30
//                                    self.loginButton.alpha = 1.0
//            },
//                                   completion: nil)
        
        let fadeCloud = CABasicAnimation(keyPath: "opacity")
        fadeCloud.fromValue = 0.0
        fadeCloud.toValue = 1.0
        fadeCloud.duration = 0.5
        fadeCloud.fillMode = kCAFillModeBackwards
        
        fadeCloud.beginTime = CACurrentMediaTime() + 0.5
        cloud1.layer.addAnimation(fadeCloud, forKey: nil)
        cloud1.layer.opacity = 1.0
        
        fadeCloud.beginTime = CACurrentMediaTime() + 0.7
        cloud2.layer.addAnimation(fadeCloud, forKey: nil)
        cloud2.layer.opacity = 1.0
        
        fadeCloud.beginTime = CACurrentMediaTime() + 0.9
        cloud3.layer.addAnimation(fadeCloud, forKey: nil)
        cloud3.layer.opacity = 1.0
        
        fadeCloud.beginTime = CACurrentMediaTime() + 1.1
        cloud4.layer.addAnimation(fadeCloud, forKey: nil)
        cloud4.layer.opacity = 1.0
//        
//        UIView.animateWithDuration(0.5, delay: 0.5, options: [.CurveEaseOut], animations: {
//            self.cloud1.alpha = 1.0
//            }, completion: nil)
//        UIView.animateWithDuration(0.5, delay: 0.7, options: [.CurveEaseOut], animations: {
//            self.cloud2.alpha = 1.0
//            }, completion: nil)
//        UIView.animateWithDuration(0.5, delay: 0.9, options: [.CurveEaseOut], animations: {
//            self.cloud3.alpha = 1.0
//            }, completion: nil)
//        UIView.animateWithDuration(0.5, delay: 1.1, options: [.CurveEaseOut], animations: {
//            self.cloud4.alpha = 1.0
//            }, completion: nil)
        
        self.animateCloud(cloud1.layer)
        
        self.animateCloud(cloud2.layer)
        
        self.animateCloud(cloud3.layer)
        
        self.animateCloud(cloud4.layer)
    }
    
    // MARK: further methods
    
    @IBAction func login() {
        view.endEditing(true)
        
        
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.bounds.size.width += 80
            }, completion: {_ in
                self.showMessage(index: 0)
        })
        
        UIView.animateWithDuration(0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
            self.loginButton.center.y += 60
//            self.loginButton.backgroundColor = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
            
            self.spinner.center = CGPointMake(40, self.loginButton.frame.size.height / 2)
            self.spinner.alpha = 1.0
            }, completion: nil)
        
        let color = UIColor(red: 0.85, green: 0.83, blue: 0.45, alpha: 1.0)
        self.tintBackgroudColor(loginButton.layer, toColor: color)
        roundCorner(layer: loginButton.layer, toRadius: 25.0)
    }
    
    func showMessage(index index: Int) {
        label.text = messages[index]
        
        UIView.transitionWithView(self.status, duration: 0.33, options: [.CurveEaseOut, .TransitionCurlDown], animations: {
            self.status.hidden = false
            }) { _ in
                delay(seconds: 2.0, completion: { 
                    if index < self.messages.count-1 {
                        self.removeMessage(index: index)
                    } else {
                        // reset form
                        self.resetForm()
                    }
                })
        }
    }
    
    func removeMessage(index index: Int) {
        UIView.animateWithDuration(0.33, delay: 0.0, options: [], animations: { 
            self.status.center.x += self.view.bounds.size.width
            }) { _ in
                self.status.hidden = true
                self.status.center = self.statusPosition
                
                self.showMessage(index: (index+1))
        }
    }
    
    func resetForm() {
        UIView.animateWithDuration(0.2, delay: 0.0, options: [.CurveEaseIn, .TransitionCurlUp], animations: { 
            self.status.hidden = true
            self.status.center = self.statusPosition
            }) { _ in
                
        }
        
        UIView.animateWithDuration(0.33, delay: 0.0, options: [], animations: { 
            self.spinner.frame.origin = self.spinnerPosition
            self.spinner.alpha = 0.0
            
//            self.loginButton.backgroundColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha: 1.0)
            self.loginButton.bounds.size.width -= 80
            self.loginButton.center.y -= 60
            }, completion: {_ in
                let tintColor = UIColor(red: 0.63, green: 0.84, blue: 0.35, alpha:1.0)
                self.tintBackgroudColor(self.loginButton.layer, toColor: tintColor)
                self.roundCorner(layer: self.loginButton.layer, toRadius: 10.0)
        })
        
        
    }
    
    
    // This animation will flash at the end 
    // Use fillMode = kCAFillModeForwards and removedOnCompletion = false to solve pre-problem
    func animateCloud(cloudLayer: CALayer) {
        
        let cloudSpeed = 60.0 / Double(view.layer.frame.size.width)
        let duration: NSTimeInterval = Double(view.layer.frame.size.width - cloudLayer.frame.origin.x) * cloudSpeed
        
        let cloudMove = CABasicAnimation(keyPath: "position.x")
        cloudMove.duration = duration
        cloudMove.toValue = self.view.bounds.width + cloudLayer.frame.width / 2.0
        cloudMove.fillMode = kCAFillModeForwards
        cloudMove.removedOnCompletion = false
        cloudMove.delegate = self
        cloudMove.setValue("cloud", forKey: "name")
        cloudMove.setValue(cloudLayer, forKey: "layer")
        
        cloudLayer.addAnimation(cloudMove, forKey: "cloudmove")
        
//        UIView.animateWithDuration(duration,
//                                   delay: 0.0,
//                                   options: [.CurveLinear],
//                                   animations: {
//                                    cloud.frame.origin.x = self.view.frame.width
//        }){ _ in
//            cloud.frame.origin.x = -self.view.frame.size.width
//            self.animateCloud(cloud)
//        }

    }
    
    func tintBackgroudColor(layer: CALayer, toColor: UIColor) {
        let tintBC = CABasicAnimation(keyPath: "backgroudColor")
        tintBC.fromValue = layer.backgroundColor
        tintBC.toValue = toColor.CGColor
        tintBC.duration = 1.0
        
        layer.addAnimation(tintBC, forKey: nil)
        layer.backgroundColor = toColor.CGColor
    }
    
    func roundCorner(layer alayer: CALayer, toRadius: CGFloat) {
        let roundC = CABasicAnimation(keyPath: "cornerRadius")
        roundC.fromValue = alayer.cornerRadius
        roundC.toValue = toRadius
        roundC.duration = 0.33
        
        alayer.addAnimation(roundC, forKey: nil)
        alayer.cornerRadius = toRadius
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextField = (textField === username) ? password : username
        nextField.becomeFirstResponder()
        return true
    }
    
    // MARK: CAAnimation Delegate
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let name = anim.valueForKey("name") as? String {
            if name == "form" {
                let layer = anim.valueForKey("layer") as? CALayer
                anim.setValue(nil, forKey: "layer") // this pulse animation will only happen the first time in form right
                
                // this only work properly in ios 9.0+
                let pulse = CASpringAnimation(keyPath: "transform.scale")
                pulse.fromValue = 1.25
                pulse.toValue = 1.0
                pulse.damping = 7.5 //a greater damping value means the pendulum will settle faster.
                pulse.duration = pulse.settlingDuration
                
                layer?.addAnimation(pulse, forKey: nil)  // cast operation can fail, use optionals to handle errors
                
            }
            if name == "cloud" {
                if let layer = anim.valueForKey("layer") as? CALayer {
                    anim.setValue(nil, forKey: "layer")
                    layer.removeAnimationForKey("cloudmove")
                    layer.position.x = -layer.bounds.width/2
                    delay(seconds: 0.5, completion: {
                        self.animateCloud(layer)
                    })
                }
            }
        }
        
    }
    
}



// MARK: UITextField Delegate

// Separating protocols into their own extensions like this helps keep the file organized.

extension ViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        print(info.layer.animationKeys())
        
        info.layer.removeAnimationForKey("infoappear")
    }
}