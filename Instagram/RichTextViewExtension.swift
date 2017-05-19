//
//  RichTextView.swift
//  scenested-experiment
//
//  Created by Xie kesong on 7/22/16.
//  Copyright © 2016 ___Scenested___. All rights reserved.
//

import UIKit

let HashTagAttributeName = "hashtag"
let MentionedAttributeName = "mentioned"


extension UILabel {
    func setStyleText(text: String){
        if text.characters.count == 0{
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.6
        
        let font = UIFont.systemFont(ofSize: 15.0)
        
        let attributes = [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName: font
        ]
        
        
        let mutableAttributedString = NSMutableAttributedString(string: text)
       
        mutableAttributedString.addAttributes(attributes, range:  NSRangeFromString(text))
        
        
        self.attributedText = mutableAttributedString
        let textRange = text.startIndex..<text.endIndex
        

        let hashTagOrMentionedRegx = try! NSRegularExpression(pattern: "[#|@][\\w]+", options: .caseInsensitive)
        
        hashTagOrMentionedRegx.enumerateMatches(in: text, options: .withTransparentBounds, range: NSRangeFromString(text)) { (checkingResult, flag, stop) in
            if let range = checkingResult?.range{
                mutableAttributedString.addAttributes([NSForegroundColorAttributeName: StyleSchemeConstant.linkColor], range: range)
                
                let stringToBeHighlighted = (text as NSString).substring(with: range)
                
                let keyword = (stringToBeHighlighted as NSString).substring(from: 1)
                if stringToBeHighlighted.contains("#"){
                    mutableAttributedString.addAttribute(HashTagAttributeName, value: keyword, range: range)
                }else if stringToBeHighlighted.contains("@"){
                    mutableAttributedString.addAttribute(MentionedAttributeName, value: keyword, range: range)
                }
            }

        }
        
        
        self.attributedText = mutableAttributedString
    }
    
    
    
    
    
    
    
    
    
    
    
    
//    func textViewTapped(tapGesture: UITapGestureRecognizer){
//        let point = tapGesture.locationInView(self)
//        self.selectable = true
//        if let position = closestPositionToPoint(point){
//            let range = tokenizer.rangeEnclosingPosition(position, withGranularity: .Word, inDirection: 1)
//            if range != nil {
//                let location = offsetFromPosition(beginningOfDocument, toPosition: range!.start)
//                let length = offsetFromPosition(range!.start, toPosition: range!.end)
//                let attrRange = NSMakeRange(location, length)
//                let word = attributedText.attributedSubstringFromRange(attrRange)
//                if let hashTagValue = word.attribute(HashTagAttributeName, atIndex: 0, effectiveRange: nil ) {
//                    print(hashTagValue)
//                }else if let mentionedValue = word.attribute(MentionedAttributeName, atIndex: 0, effectiveRange: nil ){
//                   
//                    let userInfo: [String: AnyObject] = [
//                        "mentionedUserName": mentionedValue,
//                        "textView": self
//                    ]
//                    let textViewMentionedTappedNotification = NSNotification(name: NotificationLocalizedString.TextViewMentionedTappedNotificationName, object: self, userInfo: userInfo)
//                        NSNotificationCenter.defaultCenter().postNotification(textViewMentionedTappedNotification)
//                    print(mentionedValue)
//                }else{
//                    let userInfo: [String: AnyObject] = [
//                        "textView": self
//                    ]
//                    let textViewTappedNotification = NSNotification(name: NotificationLocalizedString.TextViewTappedNotificationName, object: self, userInfo: userInfo)
//                    NSNotificationCenter.defaultCenter().postNotification(textViewTappedNotification)
//                }
//                
//                
//            }
//        }
//        self.selectable = false
//    }
//    
//    
//    func setBioDefaultText(){
//        self.text = "No introduction yet."
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 2.6
//        
//        let font = UIFont.systemFontOfSize(15)
//        
//        let attributes: [String: AnyObject] = [
//            NSParagraphStyleAttributeName: paragraphStyle,
//            NSFontAttributeName: font,
//            NSForegroundColorAttributeName: UIColor(red: 120 / 255.0, green: 120 / 255.0, blue: 120 / 255.0, alpha: 1)
//        ]
//        
//        let mutableAttributedString = NSMutableAttributedString(string: text)
//        mutableAttributedString.addAttributes(attributes, range: text.fullRange())
//        self.attributedText = mutableAttributedString
//
//    }
//    
//    
//    
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
