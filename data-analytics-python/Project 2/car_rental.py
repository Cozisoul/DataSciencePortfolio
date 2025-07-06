import datetime

class CarRental:
    def __init__(self, available_cars=100):
        self.available_cars = available_cars
        self.hourly_rate = 10
        self.daily_rate = 70
        self.weekly_rate = 400
        # Optional: Add a dictionary to store car details
        # self.cars = {
        #     "Car1": {"make": "Toyota", "model": "Camry", "year": 2020},
        #     "Car2": {"make": "Honda", "model": "Civic", "year": 2021},
        #     # ... more cars
        # }

    def display_available_cars(self):
        print(f"Available cars: {self.available_cars}")

    def rent_hourly(self, num_cars):
        return self._rent_car(num_cars, "hourly")

    def rent_daily(self, num_cars):
        return self._rent_car(num_cars, "daily")

    def rent_weekly(self, num_cars):
        return self._rent_car(num_cars, "weekly")

    def _rent_car(self, num_cars, rental_type):
        if num_cars <= 0:
            return "Number of cars must be positive."
        if num_cars > self.available_cars:
            return "Not enough cars available."
        self.available_cars -= num_cars
        rental_time = datetime.datetime.now()
        return {"rental_time": rental_time, "rental_type": rental_type, "num_cars": num_cars}

    def return_car(self, rental_info):
        if not isinstance(rental_info, dict):
            return "Invalid rental information."

        rental_time = rental_info.get("rental_time")
        rental_type = rental_info.get("rental_type")
        num_cars = rental_info.get("num_cars")

        if not all([rental_time, rental_type, num_cars]):
            return "Missing rental information."

        if not isinstance(rental_time, datetime.datetime):
            return "Invalid rental time format."

        self.available_cars += num_cars
        bill = self.calculate_bill(rental_time, rental_type, num_cars)
        return bill

    def calculate_bill(self, rental_time, rental_type, num_cars):
        now = datetime.datetime.now()
        duration = now - rental_time
        duration_in_seconds = duration.total_seconds()

        if rental_type == "hourly":
            rate = self.hourly_rate
            bill = (duration_in_seconds / 3600) * rate * num_cars
        elif rental_type == "daily":
            rate = self.daily_rate
            bill = (duration_in_seconds / (3600 * 24)) * rate * num_cars
        elif rental_type == "weekly":
            rate = self.weekly_rate
            bill = (duration_in_seconds / (3600 * 24 * 7)) * rate * num_cars
        else:
            return "Invalid rental type."

        return bill

class Customer:
    def __init__(self, name=""):
            self.name = name  # Optional: Store customer name
            self.current_rental = None #store current rental

    def request_car(self, car_rental, rental_type, num_cars):
        if self.current_rental is not None:
            return "Customer already has a car rented. Please return it first."

        if rental_type == "hourly":
            rental_info = car_rental.rent_hourly(num_cars)
        elif rental_type == "daily":
            rental_info = car_rental.rent_daily(num_cars)
        elif rental_type == "weekly":
            rental_info = car_rental.rent_weekly(num_cars)
        else:
            return "Invalid rental type."

        if isinstance(rental_info, str): #Error message
            return rental_info

        self.current_rental = rental_info
        return rental_info

    def return_car(self, car_rental):
        if self.current_rental is None:
            return "No car rented to return."

        bill = car_rental.return_car(self.current_rental)
        self.current_rental = None
        return bill