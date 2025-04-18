import 'dart:io';

class Event {
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

  void bookTicket() {
    if (availableTickets > 0) {
      availableTickets--;
      print('Ticket booked for event $name');
    } else {
      print('No tickets available for event $name');
    }
  }

  void unbookTicket() {
    availableTickets++;
    print('Ticket unbooked for event $name');
  }

  void showDetails() {
    print(
        'Event: $name, Place: $place, Time: $time, Tickets Left: $availableTickets');
  }
}

class User {
  String id;
  String name;
  String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  void performAction() {
    print('$name is performing an action');
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

  void addEvent(Event event) {
    events.add(event);
    print('Event ${event.name} added by Admin');
  }

  void deleteEvent(Event event) {
    events.remove(event);
    print('Event ${event.name} deleted by Admin');
  }

  void addUser(User user) {
    users.add(user);
    print('User ${user.name} added by Admin');
  }

  void removeUser(User user) {
    users.remove(user);
    print('User ${user.name} removed by Admin');
  }

  @override
  void performAction() {
    print('Admin $name is performing an administrative action');
  }

  void showAllEvents() {
    if (events.isEmpty) {
      print('No events available.');
    } else {
      print('All available events:');
      for (var event in events) {
        event.showDetails();
      }
    }
  }
}

class Employee extends User {
  List<Event> events = [];

  Employee({
    required String id,
    required String name,
    required String email,
  }) : super(id: id, name: name, email: email);

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
    if (events.isEmpty) {
      print('No events available.');
    } else {
      print('All available events for Employee $name:');
      for (var event in events) {
        event.showDetails();
      }
    }
  }
}

class Client {
  String serialNumber;
  String name;
  List<Event> attendedEvents;

  Client({
    required this.serialNumber,
    required this.name,
    required this.attendedEvents,
  });

  void viewEvents() {
    print('Events attended by $name:');
    for (var event in attendedEvents) {
      print(event.name);
    }
  }

  void performAction() {
    print('Client $name is viewing events');
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
    super.bookTicket();
    print('Special handling for booking a concert ticket for $name');
  }

  @override
  void showDetails() {
    super.showDetails();
    print('This is a concert event!');
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
    super.bookTicket();
    print('Festival-specific booking behavior for event $name');
  }

  @override
  void showDetails() {
    super.showDetails();
    print('This is a festival event!');
  }
}

void main() {
  var admin = Admin(id: '1', name: 'Admin User', email: 'admin@example.com');
  var employee =
      Employee(id: '2', name: 'Employee User', email: 'employee@example.com');

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
    print("3: Show All Events");
    print("4: Book Event for Client");
    print("5: Exit");

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
          description: 'Event Description',
          availableTickets: availableTickets,
        );
        admin.addEvent(event);
      } else {
        print("Invalid event details.");
      }
    } else if (action == '4') {
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
              serialNumber: '12345', name: clientName, attendedEvents: []);
          employee.bookEvent(client, event);
        } catch (e) {
          print(e);
        }
      } else {
        print("Invalid client or event details.");
      }
    } else if (action == '3') {
      admin.showAllEvents();
    } else if (action == '5') {
      print("Exiting the program...");
      break;
    } else {
      print("Invalid action.");
    }
  }
}
