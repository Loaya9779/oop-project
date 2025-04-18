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
    for (var event in attendedEvents) {
      print(event.name);
    }
  }

  @override
  void performAction() {
    print('Client is performing an action');
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
    events.remove(event);
    print('Event ${event.name} deleted');
  }

  void addUser(User user) {
    users.add(user);
    print('User ${user.name} added');
  }

  void removeUser(User user) {
    users.remove(user);
    print('User ${user.name} removed');
  }

  void searchUserByName(String name) {
    var user = users.firstWhere(
      (user) => user.name == name,
      orElse: () => throw Exception('User not found'),
    );
    print('User found: ${user.name}, ID: ${user.id}, Email: ${user.email}');
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
    print('Admin is performing an action');
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
    event.unbookTicket();
    client.attendedEvents.remove(event);
    print('Unbooking ticket for ${client.name} from ${event.name}');
    print('Tickets remaining: ${event.availableTickets}');
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
    print('Employee is performing an action');
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
      print('No tickets available for event $name');
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
    if (action == null) return;

    if (action == '1') {
      print("Enter event name:");
      String? name = stdin.readLineSync();
      print("Enter event place:");
      String? place = stdin.readLineSync();
      print("Enter event date (YYYY-MM-DD):");
      String? dateStr = stdin.readLineSync();
      print("Enter number of available tickets:");
      String? ticketsStr = stdin.readLineSync();
      DateTime? date;
      int availableTickets = 0;

      if (dateStr != null) {
        date = DateTime.tryParse(dateStr);
        if (date == null) {
          print("Invalid date format.");
          continue;
        }
      }

      if (ticketsStr != null) {
        availableTickets = int.tryParse(ticketsStr) ?? 0;
        if (availableTickets <= 0) {
          print("Invalid number of tickets.");
          continue;
        }
      }

      if (name != null && place != null && date != null) {
        var event = ConcertEvent(
          name: name,
          place: place,
          time: date,
          description: 'Concert Event Description',
          availableTickets: availableTickets,
        );
        admin.manageEvent('add', event);
      } else {
        print("Invalid event details.");
      }
    } else if (action == '7') {
      print("Enter client name:");
      String? clientName = stdin.readLineSync();
      print("Enter event name to book:");
      String? eventName = stdin.readLineSync();

      if (clientName != null && eventName != null) {
        try {
          var event = admin.events.firstWhere(
            (e) => e.name == eventName,
            orElse: () => throw Exception('Event not found'),
          );
          var client = Client(
            serialNumber: '12345',
            id: 'c1',
            name: clientName,
            email: '$clientName@example.com',
          );
          employee.bookEvent(client, event);
        } catch (e) {
          print(e);
        }
      } else {
        print("Invalid client or event details.");
      }
    } else if (action == '9') {
      admin.showAllEvents();
    } else if (action == '10') {
      print("Exiting the program...");
      break;
    } else {
      print("Invalid action.");
    }
  }
}
