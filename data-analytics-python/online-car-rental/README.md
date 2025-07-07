# Project 3: Online Car Rental Platform (OOP)

### Overview
This project is a console-based car rental platform built using Object-Oriented Programming (OOP) in Python. It simulates a real-world rental service where customers can view available cars, rent them on an hourly, daily, or weekly basis, and receive an automatically calculated bill upon return. The project emphasizes clean, modular code design and the practical application of OOP principles.

### Tools Used
- **Language:** Python 3.x
- **IDE:** Jupyter Notebook
- **Modules:** `datetime` (for handling rental time and billing calculations)

### Key Skills
- **Object-Oriented Programming (OOP):**
- Designing classes (`CarRental`, `Customer`) and objects.
- Encapsulation of data and methods.
- Creating modular and reusable code.
- **Software Design:** Decomposing a problem statement into logical classes and functions.
- **Application Logic:** Managing inventory (state), handling user input, and performing time-based calculations.
- **Modularity:** The core logic is built in a separate `car_rental.py` module, which is then imported and used by the main application script.

### Screenshots
*A screenshot of the running application's main menu and user interaction would go here.*

**(Example Placeholder)**
Welcome to the Online Car Rental Platform! Please enter your name: Alex

--- Main Menu ---

View available cars
Rent a car
Return a car
Exit Enter your choice (1-4): 2
--- Rent a Car --- Rental options: hourly - Rent by the hour daily - Rent by the day weekly - Rent by the week Enter rental type (hourly/daily/weekly): hourly How many cars would you like to rent? 3 [SUCCESS] Rental started at 2025-07-06 20:00:08. Enjoy your ride!


### Key Learnings
- **OOP Design:** Gained practical experience in structuring a program around objects, which makes the code more organized, scalable, and easier to maintain.
- **State Management:** Learned to manage the state of an application (e.g., car inventory) within a class, ensuring that data is modified only through defined methods.
- **Modularity:** Understood the importance of separating core business logic (the `CarRental` module) from the user interface (the main script), which allows for easier testing and future updates (e.g., adding a GUI).

### Future Improvements
- **Data Persistence:** Implement a system to save and load the rental inventory and customer data to a file (e.g., CSV, JSON) or a database (e.g., SQLite), so the application's state is not lost on exit.
- **Graphical User Interface (GUI):** Replace the console-based menu with a graphical interface using a library like Tkinter, PyQt, or a web framework like Flask.
- **Expanded Features:** Add more complexity, such as different car types with different pricing, user accounts with rental history, and late-fee calculations.
