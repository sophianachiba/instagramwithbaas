# Instragram with Back end as a service (BaaS)

This project showcase how to build a lighter version of instagram using BaaS techologies such as Parse.  
This means no back end code was written but only front end.  
Your Parse server can be running anywhere but I would recommend aws + bitnami (more info below).  
Similarly, the same can be built with Firebase.  
Also notifications were added using OneSignal.  


## The features available
* Login / sign up.  
* Pictures upload.  
* Likes + notifications.   
* Instragram like icons.  

## Tools used
* Xcode: app is developed in Swift.  
* Parse: as back end server.  
* AWS: to host Parse.  
* One signal: for app nofitications.  
* Sktech: to design/create icons.  

## Run the app
1- Check out the code locally.  
2- Create your parse server: https://bitnami.com/stack/parse/cloud/aws.  
3- update your ParseClientConfiguration in the AppDelegate file.  
4- Run the app!  
  
Bonus: Nofitications  
5- create an account with OneSignal.  
6- Update OneSignal.initWithLaunchOptions in the AppDelegate file.  

This is obviously not a production app but I hope this helps you understand how BaaS work as well as some foundamental of app developement.
