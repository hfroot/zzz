# z<sup>3</sup>
MHML Sleep App to help users improve their sleep hygiene, with the app being able to learn in order to be able to personalise recommendations to the user.

## System

The system will monitor:
* Bedroom environment monitoring
    * Temperature
    * Noise
    * Light
    * Humidity
* Accelerometer measures the movement of the sleep to infer quality of sleep (apparently it could be possible to do it using a microphone as well, see [here](http://www.cse.buffalo.edu/~lusu/cse721/papers/iSleep%20Unobtrusive%20Sleep%20Quality%20Monitoring%20using%20Smartphones.pdf))
* Manual/auto input with watch/phone and/or scrape HealthKit
    * Caffeine intake
    * Alcohol intake
    * Meals/snacks consumed
    * Physical activity
    * phone activity
To classify data gathered, the user will be asked to classify their sleep quality (binary?) either through the app or simply let us know.

Component analysis will be used to "weight" the different factors affecting sleep to find the individual's optimum sleeping conditions.

[System Overview](https://github.com/hfroot/zzz/blob/master/MHML_system_diagram%20(6).pdf)

### App

IPhone and/or iPad app:
* Display environment data and suggestions
* Feedback from user (Did you sleep well? etc.)
* Retrieve data from TI Sensor tag
* Machine learning for individual's factor weightings

This could be done in HTML5, making it platform independent. The TI Sensor tag can be used with EvoThings which allows you to create HTML5 apps connected to devices via Bluetooth LE.

App as an informer:
* Make suggestions for improving current environment
* Display graphically what are the biggest issues for the user
* Display more detailed info on any given night - one graph with sleep movement and environment tracking, nice display of daytime activities that could have affected it through icons

App as an active aid:
* Mini meditation exercises to be performed before bed (look to BreathEasy?)
* Suggestion for last coffee/activity of the day (potential with integrating with the previous coffee app?)
* Use haptic feedback on watch to slow the heart beat
* Alarm clock integration

**[ResearchKit](http://researchkit.org)**

Apple's open source SDK helping researchers to develop apps. 
Good video to begin using Research Kit [here](https://developer.apple.com/videos/play/wwdc2015/213/). 
Github repository available [here](https://github.com/ResearchKit/ResearchKit).
[SleepHealth](https://itunes.apple.com/us/app/sleephealth/id1059830442?mt=8&ls=1&v0=www-us-researchkit-itms-sleep-health): an app made using research kit that is used to study sleep, its causes and effects.

**[HealthKit](https://developer.apple.com/healthkit/)**

Apple's kit for health apps.
HealthKit sleep related elements: 
- [HKCategoryValueSleepAnalysis](https://developer.apple.com/reference/healthkit/hkcategoryvaluesleepanalysis).
- [HKUnit](https://developer.apple.com/reference/healthkit/hkunit) (quantities compatible with HeathKit).

**iOS Resources**
- [Start Developing iOS Apps (Swift)](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1)
- [How to sideload apps on your iPhone using Xcode 7](http://bouk.co/blog/sideload-iphone/)
- Sketch App for Mac to design UI artboards + InVision to build interactive prototypes

### Hardware

**[Texas Instruments Sensor Tag](http://www.ti.com/ww/en/wireless_connectivity/sensortag2015/index.html)**

This is a kit that makes integrating sensors into projects easy. The department apparently have lots of them, and they are cheap enough that if we show that we know what we are doing and we want more, the department will probably be happy to pay for them.

In terms of sensors, it includes:
* Infrared and Ambient Temperature Sensor
* Ambient Light Sensor
* Humidity Sensor
* Barometric Pressure Sensor
* 9-axis Motion Tracking Device - Accelerometer, Gyroscope and Compass
* Magnet Sensor

For simple data collection the TI SensorTag app can stream data to the cloud and be collected using IBM Bluemix:
https://developer.ibm.com/recipes/tutorials/connect-a-cc2650-sensortag-to-the-iot-foundations-quickstart/
https://github.com/IBM-Bluemix/iot-sensor-tag

This [blog post](http://anasimtiaz.com/?p=201) seems like a good place to start integrating the Sensor Tag into an iOS app with Swift. [Here is the repo](https://github.com/anasimtiaz/SwiftSensorTag) for the whole code in swift.

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

## Work allocation

* Sensory tag - Belen
   * Interfacing with app
   * Checking data readings
* Machine learning - Xavi and Julia
   * Gathering user data
   * Generating algo for default case
   * Figure out how to make the algo keep learning with new data coming into phone
* App design - Pierre and Helen
   * UI design
   * Data storage
   * Feedback to user
   * Feedback from user (slept well or not)

## Assessment

[Design Report](https://www.overleaf.com/7914295rhxmqhwrgkxb)



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
* BBC - What should I eat for a good night's sleep?: http://www.bbc.co.uk/guides/z282p39
 
Products:
* [CubeSensors](https://cubesensors.com)
* [Beddit](http://www.beddit.com)
* US Army sleep monitoring: https://trid.trb.org/view.aspx?id=650799

## Background research - machine learning
A GTA said it may be useful looking into: VGG 16, TensorFlow, Neural Networks.
The DoC lecturer for Machine Learning posts all of the course materials publicly, accessible [here](http://ibug.doc.ic.ac.uk/courses), which might be helpful to look through if you haven't done any machine learning.

## Background research - component analysis
* Graphical explanantion of PCA: http://setosa.io/ev/principal-component-analysis/
* Good high level and low level description of PCA: http://stats.stackexchange.com/questions/2691/making-sense-of-principal-component-analysis-eigenvectors-eigenvalues
* Walkthrough of the maths behind it: http://www.cs.otago.ac.nz/cosc453/student_tutorials/principal_components.pdf
* Why PCA should be used: http://blog.explainmydata.com/2012/07/should-you-apply-pca-to-your-data.html
* An example use, characterising beef: http://www.sciencedirect.com/science/article/pii/S0309174000000504

## Background research - suggestions
* Relaxation Techniques: http://link.springer.com/article/10.1007/s00520-004-0594-5
* Lifestyle changes to improve sleep: http://onlinelibrary.wiley.com/doi/10.1046/j.1467-9566.2003.00371.x/full
* Advice for the aged population: http://onlinelibrary.wiley.com/doi/10.1111/j.1365-2702.2006.01385.x/full

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

## Evaluation

* Qualitative judgement of output display appearance
* Graphs to show change of weightings to display personalisation over time
* To use the daily sleep quality feedback as a more quanititative example of improvement during the app, do we first need to ask the users(/us) to record how well they slept for a week before we give them the technology, then see if giving feedback about their environment in the second week actually helps improve the number of times they report sleeping well? I'll let you decide whether we want to test in this way Xavi, just thought about it as I was typing up.
* Qualitative survey at the end of the trial period, asking whether they felt that their sleep improved and questions about their interaction with the app.

## Justification
Will be created for personal use, but has possible wider solutions, like improving sleep quality in hospitals (sleep being necessary to improve health).
Stats on number of people who don't get good sleep.

## Misc
[Markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
