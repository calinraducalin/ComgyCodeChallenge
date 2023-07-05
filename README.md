# Meter Installation

Hi 👋.

Meter Installation is a demo app entirely implemented using SwiftUI. It can be run on all iOS and ipadOS devices with a minimum version 16.

I focused on delivering a quality product in respect to the platform guidelines, supportting all the required features. I added a few extra features that I found helpful:
- search bar added in the main list allowing the user to filter the results
- unistall a device if needed before it was synced with the server
- swipe to install / uninstall a device as a shortcut
- showed a badge on the sync tab informing the users there are items needed for sync

## Code Implementation

The app was implemented using ****MVVM architecure**** for decoupling the main views logic and ****Repository pattern**** for data access and offline support. In my code ****DataStore**** represents the repository responsible for fetching the data from the server, parsing it, and storing it locally. The data storage was enabled using ****CoreData**** due to its beautiful integration in the iOS ecosystem.

## Key Aspects

I tried to write simple and modern code taking in consideration the following aspects:

- use ***async/await*** pattern everywhere for asynchronous code
- the ***DataClient*** responsible for API access is just an extension over ***URLSession***
- ***DataStorage*** and al the view models are final classes, discouraging inheritance
- ***protocols*** are used for limiting code access and enabling code testability
- code reuse was done with the help of ***protocol extensions***
- support previews for every view for faster UI implementation

## Testing

The code is quite testable and I added unit tests for all the data access and view model logic. When persisting data on disk I believe it is important to make sure the stored data is kept clean. Also, the preview support allows the developer to quickly test the UI variants depending on device configuration like dark mode and adjusted font size. For enabling the previews the ***DataStore*** uses a different environment that stores the data in memory only.

## Final Thoughts

I enjoyed implementing this project. Supporting previews was a bit tricky due to data persistance but it was all worth it in the end. I hope you like my approach, too. 🤞
And thank you for reviewing it! 🙏
