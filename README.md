# zzz
MHML Sleep App

## To Do
* Narrow down the scope
* Timeline and milestones
* System design
* Allocate work
* See the Texas Instruments Sensor Tag
* Research

## Scope
The general idea is to create an app with accompanying hardware to help users improve their sleep hygeine, with the app being able to learn in order to be able to personalise recommendations to the user. Our current thoughts for things to monitor/consider are as follows (if I missed something feel free to add to it).
* Bedroom environment monitoring
    * Temperature
    * Noise
    * Light
    * Humidity
* Accelerometer measures the movement of the sleep to infer quality of sleep
* Manual/auto input with watch/phone and/or scrape HealthKit
    * Caffeine intake
    * Alcohol intake
    * Meals/snacks consumed
    * Physical activity
    * phone activity
To classify data gathered, the user will be asked to classify their sleep quality (binary?) either through the app or simply let us know.

Machine learning will be used to "weight" the different factors affecting sleep to find the individual's optimum sleeping conditions.

App as an informer:
* Make suggestions for improving current environment
* Display graphically what are the biggest issues for the user
* Display more detailed info on any given night - one graph with sleep movement and environment tracking, nice display of daytime activities that could have affected it through icons

App as an active aid:
* Mini meditation exercises to be performed before bed (look to BreathEasy?)
* Suggestion for last coffee/activity of the day (potential with integrating with the previous coffee app?)
* Use haptic feedback on watch to slow the heart beat
* Alarm clock integration

## Timeline and milestones
The deadlines are as follows, the ones I suggest are in italics and obviously up for changing:

| Task | Date |
| ---- | ----: |
| Project feasibility confirmation | 25 Jan |
| Design Report | 1 Feb |
| Individual Component Report | 22 Feb |
| First Demonstration | 1 Mar |
| *Personal testing fortnight begins* | *1 Mar* |
| Final Presentation | 15 Mar |
| *Start write up* | *15 Mar* |
| Final Submission | 22 Mar |

## System Design
IPhone and/or iPad app:
* Display environment data and suggestions
* Feedback from user (Did you sleep well? etc.)
* Retrieve data from TI Sensor tag
* Machine learning for individual's factor weightings

This could be done in HTML5, making it platform independent. The TI Sensor tag can be used with EvoThings which allows you to create HTML5 apps connected to devices via Bluetooth LE.

Server
* Centralised Database
* Analysis of many individuals' data to find default weightings

Communication...

Diagram...

## Work allocation
Nothing here atm...
## Tools
### [Texas Instruments Sensor Tag](http://www.ti.com/ww/en/wireless_connectivity/sensortag2015/index.html)
This is a kit that makes integrating sensors into projects easy. The department apparently have lots of them, and they are cheap enough that if we show that we know what we are doing and we want more, the department will probably be happy to pay for them.

In terms of sensors, it includes:
* Infrared and Ambient Temperature Sensor
* Ambient Light Sensor
* Humidity Sensor
* Barometric Pressure Sensor
* 9-axis Motion Tracking Device - Accelerometer, Gyroscope and Compass
* Magnet Sensor

I (Helen) suggest sticking to these functions to make our lives easier, but maybe it's easy to integrate new sensors into it if we're desparate for some other sensor.

This [blog post](http://anasimtiaz.com/?p=201) seems like a good place to start integrating the Sensor Tag into an iOS app with Swift.

### [ResearchKit](http://researchkit.org)
Apple's open source SDK helping researchers to develop apps. 
Good video to begin using Research Kit [here](https://developer.apple.com/videos/play/wwdc2015/213/). 
Github repository available [here](https://github.com/ResearchKit/ResearchKit).
[SleepHealth](https://itunes.apple.com/us/app/sleephealth/id1059830442?mt=8&ls=1&v0=www-us-researchkit-itms-sleep-health): an app made using research kit that is used to study sleep, its causes and effects.

### [HealthKit](https://developer.apple.com/healthkit/)
Apple's kit for health apps.

### iOS Resources
- [Start Developing iOS Apps (Swift)](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1)
- [How to sideload apps on your iPhone using Xcode 7](http://bouk.co/blog/sideload-iphone/)
- Sketch App for Mac to design UI artboards + InVision to build interactive prototypes


## Background research - sleep
Update this with whatever you find.

Scientific papers/books:
*  [Long-term sleep measurement with a smartphone-connected flexible bed sensor strip](http://www.sciencedirect.com/science/article/pii/S138994571301842X)
* [Sleep Medicine](https://books.google.co.uk/books?id=2uAzBwAAQBAJ&pg=PA48&lpg=PA48&dq=sleep+environment+measurement&source=bl&ots=1hWqbv8dBE&sig=SsSO-G3b2cWEoMAj28A3Z7f3lII&hl=en&sa=X&ved=0ahUKEwjS8eGdjd3RAhXMK5oKHcJZDpw4ChDoAQhbMBE#v=onepage&q=sleep%20environment%20measurement&f=false)
* [Sleep: A Comprehensive Handbook](https://books.google.co.uk/books?id=aNhAk4knmukC&pg=PA306&lpg=PA306&dq=sleep+environment+measurement&source=bl&ots=fS_fUiSamG&sig=5bzdqi1CFct-9M14Q98D-FqiUBc&hl=en&sa=X&ved=0ahUKEwjS8eGdjd3RAhXMK5oKHcJZDpw4ChDoAQhZMBA#v=onepage&q=Environment&f=false) p. 910 looks at environmental influences on sleep.
* [Clinical review: Sleep measurement in critical care patients: research and clinical implications](https://ccforum.biomedcentral.com/articles/10.1186/cc5966)
* [Actigraphy](https://en.m.wikipedia.org/wiki/Actigraphy)
* A more general paper, posted on BB by YD: [The Promise of mHealth: Daily Activity Monitoring and Outcome Assessments by Wearable Sensors](https://bb.imperial.ac.uk/bbcswebdav/pid-887498-dt-content-rid-3074434_1/courses/DSS-EE4_67-16_17/nihms599582.pdf)
* From BB: [Healthcare in the pocket: Mapping the space of mobile-phone health interventions](https://bb.imperial.ac.uk/bbcswebdav/pid-887499-dt-content-rid-3074427_1/courses/DSS-EE4_67-16_17/HealthcareinthePocket.pdf)
* From BB: [An NHS Guide for Developing Mobile Healthcare Applications](https://bb.imperial.ac.uk/bbcswebdav/pid-887500-dt-content-rid-3074420_1/courses/DSS-EE4_67-16_17/58C7C0E0-E1B7-4C20-9820-C2B2C94A36B3.pdf)
 
Products:
* [CubeSensors](https://cubesensors.com)
* [Beddit](http://www.beddit.com)

## Background research - machine learning
A GTA said it may be useful looking into: VGG 16, TensorFlow, Neural Networks.
The DoC lecturer for Machine Learning posts all of the course materials publicly, accessible [here](http://ibug.doc.ic.ac.uk/courses), which might be helpful to look through if you haven't done any machine learning.

## Data collection 

### Surveys

Survey before going to bed:
- Did you do exercise today? Yes/No
- When did you have dinner? (3,2,1 hour ago or not had dinner)
- Did you have sex today? Yes/No
- In the last X hours did you: (select all that apply)
   - Drink alcohol 
   - Smoke
   - Drink coffee 
- Do you sleep naked? Yes/No
- In the last hour did you drink water? Yes/No
- Do you sleep with electronic devices turned on in you room? Yes/No
- Do you feel tired? Yes/No (If not, tell to wait 15 mins before going to bed)

Survey after getting out of bed:
- Did you wake up to: dark room/artificial light/natural light? (select one)
- Did you wake up to urinate during the night? Yes/No
- Did you turn the lights on during the night? Yes/No
- Did any electronic device wake you up? Yes/No
- Do you feel tired? Yes/No
- Overall, do you feel like you had a good sleep? Yes/No


## Justification
Will be created for personal use, but has possible wider solutions, like improving sleep quality in hospitals (sleep being necessary to improve health).
Stats on number of people who don't get good sleep.

## Misc
[Markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
