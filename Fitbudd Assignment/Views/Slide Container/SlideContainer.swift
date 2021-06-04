//
//  SlideContainer.swift
//  Fitbudd Assignment
//
//  Created by Shubham Arora on 04/06/21.
//

import UIKit

enum SlideDirection {
    case right
    case left
}

protocol SlideContainerDelegate {
    func moveToThumbnail(toIndex: Int)
    func slideDidSelect()
}

class SlideContainer: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!

    // Variables
    var actionDelegate: SlideContainerDelegate!
    var isVideoLoaded: Bool = false
    var currentSlideIndex: Int = 0
    var slides: [Slide]! = []{
        didSet{
            moveToSlide(toIndex: currentSlideIndex)
        }
    }
    var enablePinch: Bool = true{
        didSet{
           // self.pinchGesture.isEnabled = self.enablePinch
        }
    }
    var enableTab: Bool = false {
        didSet{
            if enableTab {
                addTapGesture()
            }
        }
    }
    var isViewAdded: Bool! = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        UINib(nibName: "SlideContainer", bundle: nil).instantiate(withOwner: self, options: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "SlideContainer", bundle: nil).instantiate(withOwner: self, options: nil)
    }
}

extension SlideContainer{
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if isViewAdded == false{
            isViewAdded = true
            addMainView()
            currentSlideIndex = 0
        }
        enablePinch = true
        addSwipeGesture()
    }
    
    func addMainView() {
        let parentView = self
        addSubview(self.view)
        
        self.view?.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint.init(item:  self.view as Any, attribute:.top, relatedBy:.equal, toItem:parentView, attribute:.top, multiplier: 1.0, constant:0)
        let left = NSLayoutConstraint.init(item:  self.view as Any, attribute:.leading, relatedBy:.equal, toItem:parentView, attribute:.leading, multiplier: 1.0, constant:0)
        let bottom = NSLayoutConstraint.init(item:  self.view as Any, attribute:.bottom, relatedBy:.equal, toItem:parentView, attribute:.bottom, multiplier: 1.0, constant:0)
        let right = NSLayoutConstraint.init(item:  self.view as Any, attribute:.trailing, relatedBy:.equal, toItem:parentView, attribute:.trailing, multiplier: 1.0, constant:0)
        
        parentView.addConstraints([top,left,bottom,right])
    }
    
    func addSwipeGesture() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }

    private func addTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(slideTapped(_:))))
    }
    
    @IBAction func slideTapped(_ sender: UITapGestureRecognizer) {
        actionDelegate.slideDidSelect()
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if(self.slides.count > 0){
            
            var moveIndex: Int = 0

            if(sender.direction == .left ){
                moveIndex = (currentSlideIndex < self.slides.count - 1) ? (currentSlideIndex + 1) : 0
                moveToSlide(toIndex: moveIndex, direction: SlideDirection.left)
            }
            if(sender.direction == .right ){
                moveIndex = (currentSlideIndex > 0) ? (currentSlideIndex - 1) : (self.slides.count - 1)
                moveToSlide(toIndex: moveIndex, direction: SlideDirection.right)
            }
        }
    }
    
    func moveToSlide(toIndex: Int, direction: SlideDirection! = .left)  {
        if isValidIndex(index: toIndex) {

            if let url: URL = self.slides[toIndex].imageURL{
                
                self.imageView.isHidden = false
                self.imageView.sd_setImage(with: url, placeholderImage: nil)
            }
            
            playAnimation(withIndex: toIndex, direction: direction)
            if(self.actionDelegate != nil){
                self.actionDelegate.moveToThumbnail(toIndex: toIndex)
            }
            currentSlideIndex = toIndex
        }
    }
    
    func stopVideo()  {
    }
    
    func isValidIndex(index: Int) -> Bool {
        if(self.slides.count > 0 && (index >= 0 && index < self.slides.count)){
            return true
        }
        return false
    }
    
    func playAnimation(withIndex: Int, direction: SlideDirection! = .left)  {
        if(direction == .right){
            self.leadingConstraint.constant = -self.view.frame.width
        }else if(direction == .left){
            self.leadingConstraint.constant = self.view.frame.width
        }

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: Double(0.5), animations: {
            self.leadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func setClipToBound(isTrue: Bool) {
        self.view?.clipsToBounds = isTrue
        imageView.clipsToBounds = isTrue
    }
}
