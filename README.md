# Health Tracker

An iOS app that shows users their health data easily. Used to showcase modern SwiftUI design.


## Powered by:
- CoreData **(Database)**
- WireMock **(Test Data)**
- MVVM Architecture




## Test Data
By default, test data is taken from the `mockUserData.json` file:
```json
{
    "user": {
        "name": "Taha Chaudhry",
        "age": 17,
        "weight": 60,
        "sex": "Male",
        "activity": {
            "name": "Running",
            "averageHeartbeat": 90,
            "caloriesBurned": 173,
            "timeElapsed": 468
        },
        "foodLog": {
            "caloriesConsumed": 850,
            "mealsHad": 3,
            "items": [
                {
                    "name": "Apple",
                    "calories": 200
                },
                {
                    "name": "Orange",
                    "calories": 150
                },
                {
                    "name": "Banana",
                    "calories": 500
                }
            ]
        },
        "vitals": {
            "bloodPressure": 120,
            "breathingRate": 16,
            "caloriesBurned": 173,
            "heartbeat": 90,
            "temperature": 36
        }
    }
}

```

### Wiremock
Alternatively, use test data from **WireMock** using a Docker container:
```bash
docker run -it --rm \
  -p 8080:8080 \
  --name wiremock \
  -v PATH/TO/WireMockData:/home/wiremock \
  wiremock/wiremock:3.9.1
```



<img width="1423" alt="Screenshot 2024-09-25 at 3 24 33 PM" src="https://github.com/user-attachments/assets/71d3b63b-ed16-4459-87d1-db3c5da48821">

### Todo
- Widgets
- Live Activities
