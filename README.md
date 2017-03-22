![Header](https://github.com/hfroot/zzz/blob/master/ZZZHeader.png)

## Project outline
Sleep is a natural process which is essential to human beings, and lack of sleep or bad sleep hygiene can have profound effects on an individual’s well-being. To improve sleep quality there are several existing technologies. Some of them indicate how much different factors affect your sleep. Others, give recommendations based on general parameters. Our novelty comes from combining both: interpreting how much the different factors affect your sleep and consequently giving the user personalised recommendations.

## Software files
The project software files are located in the **Final** directory, which contains the following:

* **AIToolBox** - Files for framework which implements the SVM functions in swift
* **RealmSwift** - Files for framework which implements the database functions
* **ResearchKit** - Files for framework which implements all the forms, surveys and active tasks (night monitoring) as well as the plots
* **zzz** - XCode project files for the Z3 app

The **zzz** directory is organised into multiple folders which correspond to distinct features of the app:

* **Main** - top level View Controller and App delegate files (the top level storyboard is located in the Base.lproj folder)
* **Database** - object-oriented database model definition and functions to write to database
* **SensorTag** - implements BLE communication between the smartphone and the SensorTag within a custom ResearchKit ActiveStep for night monitoring + displays the live sensor values in the custom step view controller
* **Tasks** - instantiation of ResearchKit tasks to implement Login and Register forms as well as the Bedtime task, which includes one survey before bedtime, the night monitoring active step, and another survey after waking up
* **LastNight** - use of ResearchKit graph library to display the data recorded during the most recent night monitoring session
* **Recommender** - use of the AIToolbox framework to implement SVM functions that process the data recorded every night, in order to update the weightings of each factor that can affect sleep
* **Advice** - generates custom sleep advice based on the weightings calculated by recommender and displays the advice and weightings in a pie chart
* **SleepScheduler** - based on the user's average bedtime, goal waketime and desired sleep duration, the schedule engine calculates the ideal bedtime, and sets out a gradual plan to reach that goal over several days
* **Network** - the database is synchronised across all devices using a secure web server (it is also encrypted locally), in order to provide anonymised information about the network such as the proportion of people who did and didn't sleep well

## User testing data

The user testing results are located in the **Results** folder. The best way to visualise the data collected is to download the [Realm Browser](https://itunes.apple.com/gb/app/realm-browser/id1007457278?mt=12) (only available for Apple Mac computers) and then open the file called zzz-encrypted.realm

The results of the surveys we ran before and after testing are available at the following links:
* [Before test survey](https://docs.google.com/forms/d/13s00wE7_hj8rJzOB02wdftV1nuQPycHFv37PJbZYNfg/edit?usp=sharing)
* [After test survey](https://docs.google.com/forms/d/15LLIqoj2dAOG6MEmk0LqHOhSK5P7gnoZvGreiD7LBqU/edit?usp=sharing)
* [UI test survey](https://docs.google.com/forms/d/1l-N6hKzZ24sesO86uH5jFKM3I5JtVA1V0WExkMHDRpo/edit?usp=sharing)
