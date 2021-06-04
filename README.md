# FitbuddAssignment

##  AppStoryboard
### Usage - 
1. To Avoid using string literals.
2.  Improves code readability.

## TableExtension
### Usage - 
1. To avoid using string literals.
2. To avoid forceful typecasting.

## Resuable View
### Search TableView, Search TableViewCells, Slide Container and Toast
#### Usage - 
1. Created seperately to reuse it and pass data to it. Eg: - If we want search table view in any other view controller we can Sub class that table view to search table view and pass data to it.
2. As search table view, search tableview cells can be used with any table view as i have created Xib, but for that we have to register it.
3. Slide Container made it seperately to reuse it.

## Network Request
### Usage - 

Created a singleton for this would be required in most of our app states. 
Request generator to create headers and url (baseUrl + endPoint), and for endpoint i have used associated enums so I can pass data to it.

## SearchViewController
## Description - 

Conforms to UISearchBar delegate to get notify whenever search text changes.
Calls api everytime  as soon searchbar text chnages
Pass data to search table view class 
For any data to passed from table view to viewcontroller, I have used closuers for it. We can use delegates as well.
 
 ## SearchWebService
 Created a search web service to call all netorking request for a specific view and can be used for others as well as it basicually dumb class. We pass url, creaete params via internal func (with private variables) and use it.
 
 ## SearchModel and SearchViewModel
 Search model (struct) is a data model which stores all the api data and view model is initialize by it and if required we can do some calculations in view model only.
