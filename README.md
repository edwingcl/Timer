# timer-swiftui
A Simple Timer build in SwiftUI

/** 1. Resolve all errors and warnings to ensure the app starts without crashing. **/

Solutions: 
1. Fixed crash issues caused by directly fill in hex in Color and cast an Int to CGColor as!
2. Wrong calculation in time interval
3. Missing operator '+' between progress and stepProgress
4. Incorrect syntax in .trim(from: 0, to: viewModel.progress) need to pass in CGFloat
5. Incorrect init for StateObject
6. languageService from KMP's functions not found. Replace functions with swift codes

/** 2. The circular progress bar does not reflect any progress. Can you fix it using only the existing code? **/

Solution: The CircularProgressBar has binding variable and if I pass state var, it will not update. Just call CircularTimer with previously declared initializer and get value from StateObject

/** 3. What improvements would you suggest for this project? Why? Do you see any logical issues? If so, which ones and how would you address them? Implement your improvements. **/

Solution: The core timer logic shouldn't be placed in the initializer. I created it as a function so that can be reused or reset the timer. Furthermore, I also enhance the UI to make it presentable. A sound completion effect, play & pause and a restart button is added. 
