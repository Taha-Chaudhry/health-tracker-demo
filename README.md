# Health Tracker

An iOS app that shows users their health data easily. Used to showcase modern SwiftUI design.


## Powered by:
- CoreData **(Database)**
- WireMock **(Test Data)**
- MVVM Architecture


# Preview

<img width="1423" alt="Screenshot 2024-09-25 at 3 24 33 PM" src="https://github.com/user-attachments/assets/71d3b63b-ed16-4459-87d1-db3c5da48821">

<img width="1045" alt="Screenshot 2024-09-30 at 4 21 01 PM" src="https://github.com/user-attachments/assets/661d743f-4899-436f-a92f-b737753447c3">

<img width="1044" alt="Screenshot 2024-09-30 at 3 46 07 PM" src="https://github.com/user-attachments/assets/c34e2dc0-44ce-4366-8966-b55601a55081">

## Todo
- Widgets
- Live Activities


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
