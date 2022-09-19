import UIKit

var selectedDate = Date()

class WeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
							UITableViewDelegate, UITableViewDataSource
{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	@IBOutlet weak var monthLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var collectionView: UICollectionView!
	

	var totalSquares = [Date]()
    private var weeklyTasks = [ToDoListItem]()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		setCellsView()
		setWeekView()
	}
	
	func setCellsView()
	{
		let width = (collectionView.frame.size.width - 2) / 8
		let height = (collectionView.frame.size.height - 2)
		
		let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		flowLayout.itemSize = CGSize(width: width, height: height)
	}
	
	func setWeekView()
	{
		totalSquares.removeAll()
		
		var current = CalendarHelper().sundayForDate(date: selectedDate)
		let nextSunday = CalendarHelper().addDays(date: current, days: 7)
		
		while (current < nextSunday)
		{
			totalSquares.append(current)
			current = CalendarHelper().addDays(date: current, days: 1)
		}
		
		monthLabel.text = CalendarHelper().monthString(date: selectedDate)
			+ " " + CalendarHelper().yearString(date: selectedDate)
		collectionView.reloadData()
		tableView.reloadData()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		totalSquares.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
		
		let date = totalSquares[indexPath.item]
		cell.dayOfMonth.text = String(CalendarHelper().dayOfMonth(date: date))
		
		if(date == selectedDate)
		{
            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            cell.backgroundView?.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
            cell.layer.cornerRadius = 15
            
		}
		else
		{
			cell.backgroundColor = UIColor.white
		}
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		selectedDate = totalSquares[indexPath.item]
		collectionView.reloadData()
		tableView.reloadData()
	}
	
	@IBAction func previousWeek(_ sender: Any)
	{
        //minus 7 days
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
		setWeekView()
	}
	
	@IBAction func nextWeek(_ sender: Any)
	{
        //add 7 days
		selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
		setWeekView()
	}
	
	override open var shouldAutorotate: Bool
	{
		return false
	}
	
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
    
        return eventsForDate(date: selectedDate).count
        
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") as! EventCell
		let event = eventsForDate(date: selectedDate)[indexPath.row]
        cell.eventLabel.text = event.name ?? "" + " " + CalendarHelper().timeString(date: event.createdAt ?? Date())
		return cell
	}
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)
		tableView.reloadData()
        getAllItems()
	}
    
    func getAllItems() {
        do {
            weeklyTasks  = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
            print(error.localizedDescription)
        }
    }
    
    func eventsForDate(date: Date) -> [ToDoListItem]
    {
        var daysEvents = [ToDoListItem]()
        for event in weeklyTasks
        {
            if(Calendar.current.isDate(event.createdAt ?? Date(), inSameDayAs:date))
            {
                daysEvents.append(event)
            }
        }
        return daysEvents
    }
}

