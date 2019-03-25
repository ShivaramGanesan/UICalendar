//
//  UICalendar.swift
//  UICalendar
//
//  Created by shivaram-pt2458 on 25/03/19.
//  Copyright © 2019 shivaram-pt2458. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    public func getTodayDate() -> Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return day
    }
    
    public func getCurrentDate() -> Date{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return date
    }
    
    public func getDisplayDatesFromToday() -> [Date] {
        var dateArray:[Date] = []
        let thisDate:Date = getCurrentDate()
        var duplicateDate : Date = getCurrentDate()
        duplicateDate = Calendar.current.date(byAdding: .day, value: -10, to: duplicateDate)!
        for i in 0...20{
            dateArray.append(Calendar.current.date(byAdding: .day, value: 1, to: duplicateDate)!)
            duplicateDate = Calendar.current.date(byAdding: .day, value: 1, to: duplicateDate)!
        }
        return dateArray
    }
    
    public func changeToDisplayFormat() -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMM d, yyyy"
        let resultDateString = inputFormatter.string(from: self)
        return resultDateString
    }
    
    public func getWeekString() -> String{
        let day = Calendar.current.component(.weekday, from: self)
        switch day {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
    
    public func getMonthString() -> String{
        let month = Calendar.current.component(.month, from: self)
        switch month {
        case 1:
            return "JAN"
        case 2:
            return "FEB"
        case 3:
            return "MAR"
        case 4:
            return "APR"
        case 5:
            return "MAY"
        case 6:
            return "JUN"
        case 7:
            return "JUL"
        case 8:
            return "AUG"
        case 9:
            return "SEP"
        case 10:
            return "OCT"
        case 11:
            return "NOV"
        case 12:
            return "DEC"
        default:
            return ""
        }
    }
}

public extension UIView{
    func initCalendar(context:UIViewController) -> MyCalendarView{
        print("init calendar")
        var calendar:MyCalendarView = MyCalendarView.init(onView:self, context:context)
        return calendar
    }
    
}

public class MyCalendarView{
    private var scrollView:UIScrollView!
    private var dateLabel:UILabel!
    private var xOffset:Int
    private var rootController:UIViewController?
    public var delegate:MyCalendarDelegate?
    private var prevButton:UIButton?
    private var dateArray:[Date]?
    var selectedDate:Date?
    private var buttons:[UIButton]?
    public var initialHeight:CGFloat?
    
    //customization
    var scrollViewColor:UIColor?
    var displayDateColor:UIColor?
    var dateBackgroundColor:UIColor?
    
    
    init(onView : UIView, context:UIViewController) {
        //ideal height of UIView = 140
        print("Mycalendar View init")
        
        let viewHeight = onView.frame.height/2
        self.scrollView = UIScrollView(frame : CGRect(x:0, y:0, width:onView.bounds.width, height:viewHeight+10))
        self.dateLabel = UILabel(frame : CGRect(x:0, y:70, width:onView.bounds.width, height:viewHeight-10))
        self.xOffset = 10
        self.rootController = context
        self.initialHeight = onView.bounds.height
        scrollView.showsHorizontalScrollIndicator = false
        self.dateLabel.textAlignment = .center
        onView.addSubview(self.scrollView)
        onView.addSubview(self.dateLabel)
        self.selectedDate = Date().getCurrentDate()
        self.scrollViewColor = UIColor.clear
        self.displayDateColor = UIColor.black
        self.dateBackgroundColor = UIColor.clear
    }
    
    
    public func populateScrollView(dateArray:[Date]){
        print("populate scroll View")
        self.dateArray = dateArray
        for (i,d) in dateArray.enumerated(){
            let button = UIButton(type: UIButton.ButtonType.custom)
            let dayLabel = UILabel()
            
            button.tag = i
            button.backgroundColor = UIColor.clear
            button.setTitle("\(d.getTodayDate())", for: .normal)
            button.setTitleColor(UIColor.black, for: .normal)
            button.layer.cornerRadius = 25
            
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.frame = CGRect(x:self.xOffset, y:10, width:50, height:50)
            dayLabel.frame = CGRect(x:self.xOffset, y:45, width:50, height:50)
            dayLabel.text = d.getWeekString()
            dayLabel.textAlignment = .center
            button.isUserInteractionEnabled = true
            self.buttons?.append(button)
            button.addTarget(self, action: #selector(self.buttonClicked), for: .touchDown)
            self.xOffset = (self.xOffset) + (10) + Int(button.frame.size.width)
            
            self.scrollView.addSubview(button)
            self.scrollView.addSubview(dayLabel)
            
            self.scrollView.contentSize = CGSize(width:CGFloat(xOffset), height:self.scrollView.frame.height)
        }
    }
    
    public func loadToday(){
        print("sadsd")
        print(self.dateArray?.count)
        let center = ((self.dateArray?.count)!/2) - 1
        print(center)
        let todayButton = self.scrollView.viewWithTag(center) as! UIButton
        self.prevButton = todayButton
        todayButton.backgroundColor = UIColor.cyan
        self.dateLabel.text = Date().getCurrentDate().changeToDisplayFormat()
        moveToCenter(button: todayButton)
    }
    
    func moveToCenter(button:UIButton){
        let width = self.scrollView.frame.width
        let xCoord = button.frame.origin.x - ((width/2) - (button.frame.width/2))
        let rect = CGRect(x:xCoord, y:0, width:width, height:scrollView.frame.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    @objc func buttonClicked(sender:UIButton){
        moveToCenter(button: sender)
        self.selectedDate = self.dateArray?[sender.tag]
        displayDate(date: self.selectedDate!)
        self.prevButton?.backgroundColor = UIColor.clear
        sender.backgroundColor = UIColor.cyan
        self.prevButton = sender
        delegate?.onClick(button: sender, date:self.selectedDate!)
        
    }
    
    func displayDate(date:Date){
        self.dateLabel.text = date.changeToDisplayFormat()
    }
    
}

public protocol MyCalendarDelegate{
    func onClick(button : UIButton, date:Date)
}


