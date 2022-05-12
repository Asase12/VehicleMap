# VehicleMap

- The app fetches a list of vehicles from the url: 
https://takehometest-production-takehometest.s3.eu-central-1.amazonaws.com/public/take_home_test_data.json

- Shows the vehicle list on the mapView. If there are many vehicles close to each other, they will be grouped into a cluster

- Then asks for location permission. 
If location permission is enabled, it shows the closest vehicle to the user. You can see vehicle detail info within the bottom info bar

- Tap on the vehicle map annotation, so you can see the vehicle's detail info. Detail info includes the vehicle title, type (e-scooter, e-bike. e-moped), battery level, vehicle image and distance from user location

- Refresh button updates the vehicle list. Resets vehicle selection
