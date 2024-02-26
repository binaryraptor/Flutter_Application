// main.dart
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService =
      ApiService('http://localhost:8082/api/customers');
  late Future<List<Customer>> customers;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    customers = _fetchCustomers();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<List<Customer>> _fetchCustomers() async {
    try {
      // Get access token by signing in
      final accessToken = await apiService.signIn(
        User(
          username: 'susan', // Update with your credentials
          password: 'fun123',
        ),
      );

      // Fetch customers using the obtained access token
      return apiService.getCustomers(accessToken);
    } catch (e) {
      // Handle sign-in or API call errors
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: FutureBuilder<List<Customer>>(
        future: customers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var customer = snapshot.data![index];
                return ListTile(
                  title: Text('${customer.firstName} ${customer.lastName}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${customer.id}'),
                      Text('Email: ${customer.email}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
