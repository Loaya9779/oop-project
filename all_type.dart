import 'dart:io';

abstract class Event {
  String name;
  String place;
  DateTime time;
  String description;
  int availableTickets;

  Event({
    required this.name,
    required this.place,
    required this.time,
    required this.description,
    required this.availableTickets,
  });

  void bookTicket();
  void unbookTicket();
}

abstract class User {
  String id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  void performAction();
}

class Client extends User {
  String serialNumber;
  List<Event> attendedEvents = [];

  Client({
    required this.serialNumber,
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  void viewEvents() {
    if (attendedEvents.isEmpty) {
      print('No events attended.');
      return;
    }
    for (var event in attendedEvents) {
      print('${event.name} at ${event.place} on ${event.time}');
    }
  }

  @override
  void performAction() {
    print('Client $name is performing an action');
  }
}

class Admin extends User {
  List<User> users = [];
  List<Event> events = [];

  Admin({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  void addEventCategory(String category) {
    print('Category $category added');
  }

  void addEvent(Event event) {
    events.add(event);
    print('Event ${event.name} added');
  }

  void deleteEvent(Event event) {
    if (events.remove(event)) {
      print('Event ${event.name} deleted');
    } else {
      print('Event not found');
    }
  }

  void addUser(User user) {
    users.add(user);
    print('User ${user.name} added');
  }

  void removeUser(User user) {
    if (users.remove(user)) {
      print('User ${user.name} removed');
    } else {
      print('User not found');
    }
  }

  User? findUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Client? findClientByName(String name) {
    try {
      return users.firstWhere((user) => user is Client && user.name == name) as Client;
    } catch (e) {
      return null;
    }
  }

  Event? findEventByName(String name) {
    try {
      return events.firstWhere((event) => event.name == name);
    } catch (e) {
      return null;
    }
  }

  void searchUserByName(String name) {
    try {
      var user = users.firstWhere((user) => user.name == name);
      print('User found: ${user.name}, ID: ${user.id}, Email: ${user.email}');
    } catch (e) {
      print('User not found');
    }
  }

  void showAllUsers() {
    if (users.isEmpty) {
      print('No users available.');
    } else {
      for (var user in users) {
        print('User: ${user.name}, ID: ${user.id}, Email: ${user.email}');
      }
    }
  }

  void manageEvent(String action, Event event) {
    if (action == 'add') {
      addEvent(event);
    } else if (action == 'delete') {
      deleteEvent(event);
    } else {
      print('Invalid action for event');
    }
  }

  void manageUser(String action, User user) {
    if (action == 'add') {
      addUser(user);
    } else if (action == 'remove') {
      removeUser(user);
    } else {
      print('Invalid action for user');
    }
  }

  void showAllEvents() {
    if (events.isEmpty) {
      print('No events available.');
    } else {
      for (var event in events) {
        print(
            'Event: ${event.name}, Place: ${event.place}, Date: ${event.time}, Tickets Left: ${event.availableTickets}');
      }
    }
  }

  @override
  void performAction() {
    print('Admin $name is performing an action');
  }
}

class Employee extends User {
  List<Event> events = [];

  Employee({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  void addClient(Client client) {
    print('Client ${client.name} added');
  }

  void bookEvent(Client client, Event event) {
    if (event.availableTickets > 0) {
      event.bookTicket();
      client.attendedEvents.add(event);
      print('Booking ticket for ${client.name} to ${event.name}');
      print('Tickets remaining: ${event.availableTickets}');
    } else {
      print('No available tickets for event ${event.name}');
    }
  }

  void unbookEvent(Client client, Event event) {
    if (client.attendedEvents.contains(event)) {
      event.unbookTicket();
      client.attendedEvents.remove(event);
      print('Unbooking ticket for ${client.name} from ${event.name}');
      print('Tickets remaining: ${event.availableTickets}');
    } else {
      print('Client ${client.name} is not booked for ${event.name}');
    }
  }

  void manageEvent(String action, Event event) {
    if (action == 'add') {
      events.add(event);
      print('Event ${event.name} added by employee');
    } else if (action == 'remove') {
      events.remove(event);
      print('Event ${event.name} removed by employee');
    } else {
      print('Invalid action for event');
    }
  }

  @override
  void performAction() {
    print('Employee $name is performing an action');
  }
}

class ConcertEvent extends Event {
  ConcertEvent({
    required String name,
    required String place,
    required DateTime time,
    required String description,
    required int availableTickets,
  }) : super(
          name: name,
          place: place,
          time: time,
          description: description,
          availableTickets: availableTickets,
        );

  @override
  void bookTicket() {
    if (availableTickets > 0) {
      availableTickets--;
      print('Ticket booked for event $name');
    } else {
      throw Exception('No tickets available for event $name');
    }
  }

  @override
  void unbookTicket() {
    availableTickets++;
    print('Ticket unbooked for event $name');
  }
}

void main() {
  var admin = Admin(id: '1', name: 'Admin User', email: 'admin@example.com');
  var employee =
      Employee(id: '2', name: 'Employee User', email: 'employee@example.com');
  
  // Add the employee to admin's user list
  admin.addUser(employee);

  while (true) {
    print("\nChoose an action:");
    print("1: Add Event");
    print("2: Remove Event");
    print("3: Add User");
    print("4: Remove User");
    print("5: Search User by Name");
    print("6: Show All Users");
    print("7: Book Event for Client");
    print("8: Unbook Event for Client");
    print("9: Show All Events");
    print("10: Exit");

    String? action = stdin.readLineSync();
    if (action == null) continue;

    switch (action) {
      case '1': // Add Event
        {
          print("Enter event name:");
          String? name = stdin.readLineSync()?.trim();
          print("Enter event place:");
          String? place = stdin.readLineSync()?.trim();
          print("Enter event date (YYYY-MM-DD):");
          String? dateStr = stdin.readLineSync()?.trim();
          print("Enter number of available tickets:");
          String? ticketsStr = stdin.readLineSync()?.trim();
          print("Enter event description:");
          String? description = stdin.readLineSync()?.trim();

          if (name == null || name.isEmpty) {
            print("Event name cannot be empty");
            break;
          }
          if (place == null || place.isEmpty) {
            print("Event place cannot be empty");
            break;
          }
          if (description == null || description.isEmpty) {
            description = "No description";
          }

          DateTime? date;
          if (dateStr != null) {
            date = DateTime.tryParse(dateStr);
            if (date == null) {
              print("Invalid date format. Use YYYY-MM-DD");
              break;
            }
          } else {
            print("Date cannot be empty");
            break;
          }

          int availableTickets = 0;
          if (ticketsStr != null) {
            availableTickets = int.tryParse(ticketsStr) ?? 0;
            if (availableTickets <= 0) {
              print("Must have at least 1 ticket");
              break;
            }
          } else {
            print("Ticket count cannot be empty");
            break;
          }

          var event = ConcertEvent(
            name: name,
            place: place,
            time: date,
            description: description,
            availableTickets: availableTickets,
          );
          admin.manageEvent('add', event);
        }
        break;

      case '2': // Remove Event
        {
          if (admin.events.isEmpty) {
            print("No events available to remove");
            break;
          }
          
          print("Available events:");
          admin.showAllEvents();
          
          print("Enter event name to remove:");
          String? eventName = stdin.readLineSync()?.trim();
          
          if (eventName == null || eventName.isEmpty) {
            print("Event name cannot be empty");
            break;
          }
          
          Event? eventToRemove = admin.findEventByName(eventName);
          if (eventToRemove != null) {
            admin.manageEvent('delete', eventToRemove);
          } else {
            print("Event not found");
          }
        }
        break;

      case '3': // Add User
        {
          print("Enter user type (client/employee):");
          String? userType = stdin.readLineSync()?.trim()?.toLowerCase();
          print("Enter user name:");
          String? name = stdin.readLineSync()?.trim();
          print("Enter user email:");
          String? email = stdin.readLineSync()?.trim();

          if (userType == null || !['client', 'employee'].contains(userType)) {
            print("Invalid user type. Must be 'client' or 'employee'");
            break;
          }
          if (name == null || name.isEmpty) {
            print("Name cannot be empty");
            break;
          }
          if (email == null || email.isEmpty || !email.contains('@')) {
            print("Invalid email");
            break;
          }

          String id = DateTime.now().millisecondsSinceEpoch.toString();

          if (userType == 'client') {
            print("Enter client serial number:");
            String? serialNumber = stdin.readLineSync()?.trim();
            if (serialNumber == null || serialNumber.isEmpty) {
              print("Serial number cannot be empty");
              break;
            }
            var newClient = Client(
              serialNumber: serialNumber,
              id: id,
              name: name,
              email: email,
            );
            admin.addUser(newClient);
          } else {
            var newEmployee = Employee(
              id: id,
              name: name,
              email: email,
            );
            admin.addUser(newEmployee);
          }
        }
        break;

      case '4': // Remove User
        {
          if (admin.users.isEmpty) {
            print("No users available to remove");
            break;
          }
          
          print("Available users:");
          admin.showAllUsers();
          
          print("Enter user ID to remove:");
          String? userId = stdin.readLineSync()?.trim();
          
          if (userId == null || userId.isEmpty) {
            print("User ID cannot be empty");
            break;
          }
          
          User? userToRemove = admin.findUserById(userId);
          if (userToRemove != null) {
            admin.removeUser(userToRemove);
          } else {
            print("User not found");
          }
        }
        break;

      case '5': // Search User by Name
        {
          print("Enter user name to search:");
          String? userName = stdin.readLineSync()?.trim();
          if (userName == null || userName.isEmpty) {
            print("User name cannot be empty");
            break;
          }
          admin.searchUserByName(userName);
        }
        break;

      case '6': // Show All Users
        admin.showAllUsers();
        break;

      case '7': // Book Event for Client
        {
          if (admin.users.isEmpty) {
            print("No users available");
            break;
          }
          if (admin.events.isEmpty) {
            print("No events available");
            break;
          }
          
          print("Available clients:");
          admin.users.whereType<Client>().forEach((client) {
            print("${client.name} (ID: ${client.id})");
          });
          
          print("Enter client name:");
          String? clientName = stdin.readLineSync()?.trim();
          print("Available events:");
          admin.showAllEvents();
          print("Enter event name to book:");
          String? eventName = stdin.readLineSync()?.trim();

          if (clientName == null || clientName.isEmpty) {
            print("Client name cannot be empty");
            break;
          }
          if (eventName == null || eventName.isEmpty) {
            print("Event name cannot be empty");
            break;
          }

          Client? client = admin.findClientByName(clientName);
          Event? event = admin.findEventByName(eventName);

          if (client == null) {
            print("Client not found");
            break;
          }
          if (event == null) {
            print("Event not found");
            break;
          }

          try {
            employee.bookEvent(client, event);
          } catch (e) {
            print("Error booking event: ${e.toString()}");
          }
        }
        break;

      case '8': // Unbook Event for Client
        {
          if (admin.users.isEmpty) {
            print("No users available");
            break;
          }
          if (admin.events.isEmpty) {
            print("No events available");
            break;
          }
          
          print("Available clients:");
          admin.users.whereType<Client>().forEach((client) {
            print("${client.name} (ID: ${client.id})");
          });
          
          print("Enter client name:");
          String? clientName = stdin.readLineSync()?.trim();
          print("Available events:");
          admin.showAllEvents();
          print("Enter event name to unbook:");
          String? eventName = stdin.readLineSync()?.trim();

          if (clientName == null || clientName.isEmpty) {
            print("Client name cannot be empty");
            break;
          }
          if (eventName == null || eventName.isEmpty) {
            print("Event name cannot be empty");
            break;
          }

          Client? client = admin.findClientByName(clientName);
          Event? event = admin.findEventByName(eventName);

          if (client == null) {
            print("Client not found");
            break;
          }
          if (event == null) {
            print("Event not found");
            break;
          }

          try {
            employee.unbookEvent(client, event);
          } catch (e) {
            print("Error unbooking event: ${e.toString()}");
          }
        }
        break;

      case '9': // Show All Events
        admin.showAllEvents();
        break;

      case '10': // Exit
        print("Exiting the program...");
        return;

      default:
        print("Invalid action. Please choose 1-10");
        break;
    }
  }
}
