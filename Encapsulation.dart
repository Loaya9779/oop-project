import 'dart:io';

abstract class Event {
  String _name;
  String _place;
  DateTime _time;
  String _description;
  int _availableTickets;

  Event({
    required String name,
    required String place,
    required DateTime time,
    required String description,
    required int availableTickets,
  })  : _name = name,
        _place = place,
        _time = time,
        _description = description,
        _availableTickets = availableTickets;

  String get name => _name;
  String get place => _place;
  DateTime get time => _time;
  String get description => _description;
  int get availableTickets => _availableTickets;

  set name(String name) => _name = name;
  set place(String place) => _place = place;
  set time(DateTime time) => _time = time;
  set description(String description) => _description = description;
  set availableTickets(int availableTickets) => _availableTickets = availableTickets;

  void bookTicket();
  void unbookTicket();
  void showDetails();
}

class User {
  String _id;
  String _name;
  String _email;

  User({
    required String id,
    required String name,
    required String email,
  })  : _id = id,
        _name = name,
        _email = email;

  String get id => _id;
  String get name => _name;
  String get email => _email;

  set id(String id) => _id = id;
  set name(String name) => _name = name;
  set email(String email) => _email = email;

  void performAction() {
    print('$_name is performing an action');
  }
}

class Admin extends User {
  List<User> _users = [];
  List<Event> _events = [];

  Admin({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  List<User> get users => _users;
  List<Event> get events => _events;

  set users(List<User> users) => _users = users;
  set events(List<Event> events) => _events = events;

  void addEvent(Event event) {
    _events.add(event);
    print('Event ${event.name} added by Admin');
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    print('Event ${event.name} deleted by Admin');
  }

  void addUser(User user) {
    _users.add(user);
    print('User ${user.name} added by Admin');
  }

  void removeUser(User user) {
    _users.remove(user);
    print('User ${user.name} removed by Admin');
  }

  void showAllUsers() {
    if (_users.isEmpty) {
      print('No users available.');
    } else {
      print('All users:');
      for (var user in _users) {
        print('User: ${user.name}, ID: ${user.id}, Email: ${user.email}');
      }
    }
  }

  void showAllEvents() {
    if (_events.isEmpty) {
      print('No events available.');
    } else {
      print('All available events:');
      for (var event in _events) {
        event.showDetails();
      }
    }
  }

  @override
  void performAction() {
    print('Admin $name is performing an administrative action');
  }
}

class Employee extends User {
  List<Event> _events = [];

  Employee({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

  List<Event> get events => _events;

  set events(List<Event> events) => _events = events;

  void bookEvent(Client client, Event event) {
    event.bookTicket();
    print('Booking ticket for ${client.name} to ${event.name}');
  }

  void unbookEvent(Client client, Event event) {
    event.unbookTicket();
    print('Unbooking ticket for ${client.name} from ${event.name}');
  }

  @override
  void performAction() {
    print('Employee $name is performing an action');
  }

  void showAllEvents() {
    if (_events.isEmpty) {
      print('No events available.');
    } else {
      print('All available events for Employee $name:');
      for (var event in _events) {
        event.showDetails();
      }
    }
  }
}

class Client {
  String _serialNumber;
  String _name;
  List<Event> _attendedEvents;

  Client({
    required String serialNumber,
    required String name,
    required List<Event> attendedEvents,
  })  : _serialNumber = serialNumber,
        _name = name,
        _attendedEvents = attendedEvents;

  String get serialNumber => _serialNumber;
  String get name => _name;
  List<Event> get attendedEvents => _attendedEvents;

  set serialNumber(String serialNumber) => _serialNumber = serialNumber;
  set name(String name) => _name = name;
  set attendedEvents(List<Event> attendedEvents) => _attendedEvents = attendedEvents;

  void viewEvents() {
    print('Events attended by $_name:');
    for (var event in _attendedEvents) {
      print(event.name);
    }
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
      print('Concert ticket booked for $name');
    } else {
      print('No tickets available for concert $name');
    }
  }

  @override
  void unbookTicket() {
    availableTickets++;
    print('Concert ticket unbooked for $name');
  }

  @override
  void showDetails() {
    print('Concert Event: $name, Place: $place, Date: $time, Tickets Left: $availableTickets');
  }
}

class FestivalEvent extends Event {
  FestivalEvent({
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
      print('Festival ticket booked for $name');
    } else {
      print('No tickets available for festival $name');
    }
  }

  @override
  void unbookTicket() {
    availableTickets++;
    print('Festival ticket unbooked for $name');
  }

  @override
  void showDetails() {
    print('Festival Event: $name, Place: $place, Date: $time, Tickets Left: $availableTickets');
  }
}

void main() {
  var admin = Admin(id: '1', name: 'Admin User', email: 'admin@example.com');
  var employee = Employee(id: '2', name: 'Employee User', email: 'employee@example.com');

  var concert = ConcertEvent(
    name: 'Rock Concert',
    place: 'Stadium',
    time: DateTime(2025, 5, 15, 19, 30),
    description: 'A thrilling rock concert!',
    availableTickets: 100,
  );

  var festival = FestivalEvent(
    name: 'Music Festival',
    place: 'City Park',
    time: DateTime(2025, 6, 20, 14, 0),
    description: 'An exciting music festival with multiple artists.',
    availableTickets: 150,
  );

  admin.addEvent(concert);
  admin.addEvent(festival);

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
      print("Enter event details to add:");

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
          print("Invalid date format. Please use YYYY-MM-DD.");
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
        admin.addEvent(event);
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
          var client = Client(serialNumber: '12345', name: clientName, attendedEvents: []);
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
