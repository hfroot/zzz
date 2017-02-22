# z<sup>3</sup>
MHML Sleep App to help users improve their sleep hygiene, with the app being able to learn in order to be able to personalise recommendations to the user.

## System

![System Diagram](https://github.com/hfroot/zzz/blob/master/MHML_System_Overview_Split (1).png)

![App Diagram](https://github.com/hfroot/zzz/blob/master/MHML_app_flow.png)

The system will monitor:

* Bedroom environment monitoring
    * Temperature
    * Noise
    * Light
    * Humidity
* Accelerometer or [microphone](http://www.cse.buffalo.edu/~lusu/cse721/papers/iSleep%20Unobtrusive%20Sleep%20Quality%20Monitoring%20using%20Smartphones.pdf) to quantitavely measure sleep quality
* Manual/auto input with watch/phone and/or scrape HealthKit
    * Caffeine intake
    * Alcohol intake
    * Meals/snacks consumed
    * Physical activity
    * Phone activity
To classify data gathered, the user will be asked to rate their sleep quality.

Component analysis will be used to "weight" the different factors affecting sleep to find the individual's optimum sleeping conditions.

## Work allocation

The app will consist of a home page which will link to all the other pages in the system. Each person/team is responsible for making the page(s) that will display their data to the user or for testing purposes.

Task breakdown:

* Sensor tag - Belen
	* Investigate other hardware we can acquire to test against 
    * Coordinate with Pierre for saving data in-app
    * Ability to connect to the sensor tag through the app
    * See data coming in through the app (for user's peace of mind)
* Machine learning - Xavi and Julia
    * Gather user data
    * Generate algo for default case
    * Pull data from local/remote database to generate new weightings
    * Save new weightings locally/remotely
* Storage - Pierre
    * Set up database(s)
	* Coordinate with others on how to query the DB
	* Display trends as outlined below
* Sleep training/general FE - Helen
	* Create alarm
	* Create alarm settings
	* Make suggestions on daily sleep times according to past hours of sleep, hours needed and user-input schedule settings
	* Incorporating gamification techniques to make the app interesting to use

## Timeline and milestones
The deadlines are as follows, the ones I suggest are in italics and obviously up for changing:

| Task | Date |
| ---- | ----: |
| Individual Component Report | 22 Feb |
| First Demonstration | 1 Mar |
| *Personal testing fortnight begins* | *1 Mar* |
| Final Presentation | 15 Mar |
| *Start write up* | *15 Mar* |
| Final Submission | 22 Mar |

### App specs

Features overview:

* Gather sensor and user data to record a night's worth of sleep
* Set an alarm
* Create a sleep schedule
* Display environment data for a night and average trends
* Display trends in mood, energy levels etc.
* Adjusts factor weightings based on data to make personalised suggestions for sleep improvement

### App design

Features:

* Nightime:
   * sleep quality per night and over time (not to be shown to the user)
   * factors affecting sleep (weightings i.e. results of PCA algorithm)
   * mood & energy levels over time
   * live sensor data + sensor info & pairing
* Daytime:
   * user input of daily activites such as food intake, perceived energy/mood levels (through big icons for simplicity)
   * user input of perceived sleep quality 
* Recommendations:
   * draw data from social network, personal history, generic facts and other personal information
   * give interesting stats
   * give advice + option to remove advice in case user has no control over specific things e.g. noise level
   * tell user what is bad but also what is good
* Taking action:
   * schedule training plan for adjustements of:
      * factors affecting sleep during night
      * daily habits that have effect on sleep
      * sleep deprivation (how to catch up sleep)
   * meditation exercises
   * suggest when to seek professional help
   * tips from social network i.e. 'lots of users like to listen to ambient music such as XXX before going to bed'
   * other app suggestions (headspace?) and/or endorsements

Implementation:

* Local database contents:
   * Nightime log: temperature, humidity, light, noise, accelerometer/sleep cycles, 
   * Daytime log: food intake, caffeine intake, alcohol intake, exercise, perceived energy and mood levels, perceived sleep quality
   * User results: list all nightime and daytime factors recorded and associate weighting that describes impact on sleep quality
   * Live data: most recent data collected by sensor/user before resampling and processing
* Cloud database contents:
   * Social network results: statistics that summarise results of all users in network for analysis, comparison and feeback to users
   * Social network info: what techniques users have developed to improve their sleep
* Core functions/algorithms that need to be developed:
   * Collect sensor data: connect to TI SensorTag, retrieve relevant data, store it in appropriate tables in local database
   * Collect user data: surveys and icon dashboard for easy input of daily activities
   * Process sensor+user data: resampling, PCA and ICA algorithms to analyse frequency and produce weightings according to impact on sleep
   * Analyse network data: pull data from local databases, store some of it in cloud, produce statistics
   * Collect network analysis results: pull data from cloud if it can be used as a recommendation for the user

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

* [Start Developing iOS Apps (Swift)](https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/index.html#//apple_ref/doc/uid/TP40015214-CH2-SW1)
* [How to sideload apps on your iPhone using Xcode 7](http://bouk.co/blog/sideload-iphone/)
* Sketch App for Mac to design UI artboards + InVision to build interactive prototypes

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

## Assessment

### [Design Report](https://www.overleaf.com/7914295rhxmqhwrgkxb)

Feedback on design report:

* in final report, incorporate short survey of available commercial applications around sleep, and look for additional papers/data on factors that influency sleep and for evidence of individual variations
* two-stages hypothesis (population statistics then personalisation): danger of collecting only sparse data and not being able to produce meaningful statistics due to lack of time and resources
* consider re-thinking ways of presenting information, e.g. employ social network to personalise user recommendations ("most people sleep better after a light meal" can become "82% of people in your network slept better after a light meal" or "Karen couldn't sleep last night after her 11pm chicken mandras curry")
* there is no harm in collecting hard data for use by our application, even if it is not shown to the user, therefore we should consider collecting objective measures of sleep quality - questionnaires are notoriously unreliable therfore we should rely on more objective data
* TI sensor is great, but we should test it on the field to maje sure it gives reasonable data - we might also want to compare against other commercial devices
* consider using Apple watch for hear rate measurement, could be interesting (however Demiris is not sure about haptic feedback feature)
* **overall, we must speed up the actual development and experimentation since a lot of the final result will depend on data collection (ask for more sensors if it helps)**

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
* [Comparison of mental health and sleep hygiene](http://europepmc.org/abstract/med/17915984)
* [Sleep and other behaviours' effect on performance](http://www.tandfonline.com/doi/abs/10.1080/07448480009596294)
* [NHS Sleep Diary](http://www.nhs.uk/Livewell/insomnia/Documents/sleepdiary.pdf)
 
Products:

* [CubeSensors](https://cubesensors.com)
* [Beddit](http://www.beddit.com)
* [US Army sleep monitoring](https://trid.trb.org/view.aspx?id=650799)

## Background research - machine learning
A GTA said it may be useful looking into: VGG 16, TensorFlow, Neural Networks.
The DoC lecturer for Machine Learning posts all of the course materials publicly, accessible [here](http://ibug.doc.ic.ac.uk/courses), which might be helpful to look through if you haven't done any machine learning.

## Background research - component analysis
* [Graphical explanantion of PCA](http://setosa.io/ev/principal-component-analysis)
* [Good high level and low level description of PCA](http://stats.stackexchange.com/questions/2691/making-sense-of-principal-component-analysis-eigenvectors-eigenvalues)
* [Walkthrough of the maths behind it](http://www.cs.otago.ac.nz/cosc453/student_tutorials/principal_components.pdf)
* [Why PCA should be used](http://blog.explainmydata.com/2012/07/should-you-apply-pca-to-your-data.html)
* [An example use, characterising beef](http://www.sciencedirect.com/science/article/pii/S0309174000000504)

## Background research - suggestions
* [Relaxation Techniques](http://link.springer.com/article/10.1007/s00520-004-0594-5)
* [Lifestyle changes to improve sleep](http://onlinelibrary.wiley.com/doi/10.1046/j.1467-9566.2003.00371.x/full)
* [Advice for the aged population](http://onlinelibrary.wiley.com/doi/10.1111/j.1365-2702.2006.01385.x/full)
* [Sleep hygiene advice](http://onlinelibrary.wiley.com/doi/10.1111/j.1467-9450.2011.00902.x/full)
* [Effects of caffeine and technology on sleep](http://pediatrics.aappublications.org/content/123/6/e1005?sso=1&sso_redirect_count=1&nfstatus=401&nftoken=00000000-0000-0000-0000-000000000000&nfstatusdescription=ERROR%3A+No+local+token)
* [Influence of lifestyle on sleep loss](http://europepmc.org/abstract/med/11322717)
* [Lifestyle habits and sleep pattern spectrum](http://www.tandfonline.com/doi/abs/10.1080/07420520600650646)
* [Lifestyle and sleep health in the elderly](http://www.sciencedirect.com/science/article/pii/S0022399904000637)
* [Exercise's self-rated effect on sleep](http://jamanetwork.com/journals/jama/article-abstract/412611)
* [Epidemiology of exercise and sleep](http://onlinelibrary.wiley.com/doi/10.1111/j.1479-8425.2006.00235.x/full)
* [Exercise's effect on sleep of cancer patients](http://europepmc.org/abstract/med/12719744)
* [Effect of execise on adults with mild sleep complaints](https://academic.oup.com/biomedgerontology/article/63/9/997/692766/Effects-of-Moderate-Intensity-Exercise-on)
* [Effect of diet on sleep](http://www.sciencedirect.com/science/article/pii/S0271531712000632)
* [Effect of low carbohydrate diet on sleep](http://www.tandfonline.com/doi/abs/10.1179/147683008X301540)
* [Effect of high protein, low fat diet on sleep in obese adolescents](http://pediatrics.aappublications.org/content/101/1/61.short)
* [Ketogenic Diet Improves Sleep Quality in Children with Therapy-resistant Epilepsy](http://onlinelibrary.wiley.com/doi/10.1111/j.1528-1167.2006.00834.x/full)
* [EFFECT OF CAFFEINE ON SLEEP](http://onlinelibrary.wiley.com/doi/10.1111/j.1365-2125.1974.tb00237.x/abstract)
* [Caffeine's ability to sustain wakefulness at night](http://link.springer.com/article/10.1007%2FBF02244139?LI=true)
* [Dose-response effects of caffeine on sleep in rats](http://www.sciencedirect.com/science/article/pii/0006899387901417)
* [Effects of caffeine on sleep and cognition](https://books.google.co.uk/books?hl=en&lr=&id=W_WnBOrXT8wC&oi=fnd&pg=PA105&dq=effect+of+caffeine+on+sleep&ots=i3mZH2Hk-t&sig=A-UOo3f0TA5hG8AnaHMGF8oPVU8#v=onepage&q=effect%20of%20caffeine%20on%20sleep&f=false)
* [Heterocyclic amphetamine derivatives and caffeine on sleep](http://onlinelibrary.wiley.com/doi/10.1111/j.1365-2125.1980.tb05833.x/full)

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

## Future Work

App as an informer:

* Details of network stats

App as an active aid:

* Mini meditation exercises to be performed before bed (look to BreathEasy?)
* Suggestion for last coffee/activity of the day (potential with integrating with the previous coffee app?)
* Use haptic feedback on watch to slow the heart beat
* Alarm clock integration

## Misc
[Markdown cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
