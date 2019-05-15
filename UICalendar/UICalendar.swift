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
        duplicateDate = Calendar.current.date(byAdding: .day, value: -13, to: duplicateDate)!
        for i in 0...26{
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
            return "SUN"
        case 2:
            return "MON"
        case 3:
            return "TUE"
        case 4:
            return "WED"
        case 5:
            return "THU"
        case 6:
            return "FRI"
        case 7:
            return "SAT"
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
    public var scrollView:UIScrollView!
    private var dateLabel:UILabel!
    private var xOffset:Int
    private var rootController:UIViewController?
    public weak var delegate:MyCalendarDelegate?
    private var prevButton:UIButton?
    private var dateArray:[Date]?
    public var selectedDate:Date?
    private var buttons:[UIButton]?
    public var initialHeight:CGFloat?
    
    //customization
    var scrollViewColor:UIColor?
    var displayDateColor:UIColor?
    var dateBackgroundColor:UIColor?
    
    
    init(onView : UIView, context:UIViewController) {
        //ideal height of UIView = 140
        print("Mycalendar View init")
        
        self.scrollView = UIScrollView(frame : CGRect(x:0, y:0, width:onView.bounds.width, height:onView.bounds.height+10))
        scrollView.backgroundColor = UIColor.clear
        
        onView.addSubview(self.scrollView)
        
        self.xOffset = 10
        self.rootController = context
        self.initialHeight = onView.bounds.height
        scrollView.showsHorizontalScrollIndicator = false
        //        self.dateLabel.textAlignment = .center
        //        onView.addSubview(self.scrollView)
        //        onView.addSubview(self.dateLabel)
        self.selectedDate = Date().getCurrentDate()
        self.scrollViewColor = UIColor.clear
        self.displayDateColor = UIColor.black
        self.dateBackgroundColor = UIColor.clear
    }
    
    
    
    public func populateScrollView(dateArray:[Date]){
        print("populate scroll View")
        self.dateArray = dateArray
        for (i,d) in dateArray.enumerated()
        {
            let button = UIButton(type: UIButton.ButtonType.custom)
            let dayLabel = UILabel()
            
            if(i <= 2 || i >= dateArray.count - 3)
            {
                button.setTitleColor(UIColor.lightGray, for: .normal)
                button.isEnabled = false
            }
            else
            {
                button.setTitleColor(UIColor.black, for: .normal)
            }
            
            button.tag = i
            button.backgroundColor = UIColor.white
            button.setTitle("\(d.getTodayDate())", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 23)
            button.layer.cornerRadius = 20
            
            
            button.frame = CGRect(x:self.xOffset + 5, y:35, width:40, height:40)
            dayLabel.frame = CGRect(x:self.xOffset, y:10, width:50, height:20)
            
            dayLabel.text = d.getWeekString()
            dayLabel.font = UIFont.systemFont(ofSize: 10)
            dayLabel.textColor = UIColor.gray
            dayLabel.textAlignment = .center
            
            button.isUserInteractionEnabled = true
            self.buttons?.append(button)
            button.addTarget(self, action: #selector(self.buttonClicked), for: .touchDown)
            
            self.xOffset = (self.xOffset) + (20) + Int(button.frame.size.width)
            
            self.scrollView.addSubview(dayLabel)
            self.scrollView.addSubview(button)
            
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
        todayButton.backgroundColor = UIColor.init(red: 17/255, green: 105/255, blue: 195/255, alpha: 1)
        todayButton.setTitleColor(UIColor.white, for: .normal)
        //        self.dateLabel.text = Date().getCurrentDate().changeToDisplayFormat()
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
        self.prevButton?.backgroundColor = UIColor.white
        self.prevButton?.setTitleColor(UIColor.black, for: .normal)
        sender.backgroundColor = UIColor.init(red: 17/255, green: 105/255, blue: 195/255, alpha: 1)
        sender.setTitleColor(UIColor.white, for: .normal)
        self.prevButton = sender
        delegate?.onClick(button: sender, date:self.selectedDate!)
        
    }
    
    func displayDate(date:Date){
        //        self.dateLabel.text = date.changeToDisplayFormat()
    }
    
    public func hideScrollView()
    {
        scrollView.isHidden = !scrollView.isHidden
    }
    
    public func updateFrame(_ width:CGFloat)
    {
        scrollView.frame = CGRect(x: scrollView.frame.origin.x, y: scrollView.frame.origin.y, width: width, height: scrollView.frame.height)
    }
    
}

public protocol MyCalendarDelegate:class
{
    func onClick(button : UIButton, date:Date)
}
