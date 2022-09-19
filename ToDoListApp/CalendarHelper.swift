import Foundation
import UIKit

class CalendarHelper
{
	let calendar = Calendar.current
	
    
	func plusMonth(date: Date) -> Date
	{
        /*
         15 jan 2022
         15 feb 2022
         gives the next month
         */
		return calendar.date(byAdding: .month, value: 1, to: date)!
	}
	
	func minusMonth(date: Date) -> Date
	{
        //Gives the previous month
		return calendar.date(byAdding: .month, value: -1, to: date)!
	}
	
	func monthString(date: Date) -> String
	{
        //Returns January as
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "LLLL"
		return dateFormatter.string(from: date)
	}
	
	func yearString(date: Date) -> String
	{
        //reurns the year
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		return dateFormatter.string(from: date)
	}
	
	func timeString(date: Date) -> String
	{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		return dateFormatter.string(from: date)
	}
	
    //Retruns the days in a month
	func daysInMonth(date: Date) -> Int
	{
		let range = calendar.range(of: .day, in: .month, for: date)!
		return range.count
	}
	
    //Returns the day in that month
	func dayOfMonth(date: Date) -> Int
	{
		let components = calendar.dateComponents([.day], from: date)
		return components.day!
	}
	
    //Gives use the first day of that month
	func firstOfMonth(date: Date) -> Date
	{
		let components = calendar.dateComponents([.year, .month], from: date)
		return calendar.date(from: components)!
	}
	
    
    //Returns the day of that date
	func weekDay(date: Date) -> Int
	{
		let components = calendar.dateComponents([.weekday], from: date)
		return components.weekday! - 1
	}
	
    //going foward and backwards
	func addDays(date: Date, days: Int) -> Date
	{
		return calendar.date(byAdding: .day, value: days, to: date)!
	}
	
    //Given thursdau find the nearest sunday
	func sundayForDate(date: Date) -> Date
	{
		var current = date
		let oneWeekAgo = addDays(date: current, days: -7)
		
        
		while(current > oneWeekAgo)
		{
            //get the sunday which is equal to one while the current day isnt less than a week ago
			let currentWeekDay = calendar.dateComponents([.weekday], from: current).weekday
			if(currentWeekDay == 1)
			{
				return current
			}
			current = addDays(date: current, days: -1)
		}
		return current
	}
	
}
