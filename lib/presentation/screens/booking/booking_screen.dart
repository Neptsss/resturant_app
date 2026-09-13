import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/core/constants/app_theme.dart';
import 'package:restaurant_app/domain/entities/restaurant.dart';
import 'package:restaurant_app/presentation/providers/booking_provider.dart';
import 'package:restaurant_app/presentation/widgets/custom_button.dart';
import 'package:restaurant_app/presentation/widgets/custom_form.dart';

class BookingScreen extends StatefulWidget {
  final Restaurant restaurant;
  const BookingScreen({super.key, required this.restaurant});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _seatsController = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _seatsController.dispose();
    super.dispose();
  }

  Future<void> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _emailController.text = user.email ?? '';
        _nameController.text = user.displayName ?? '';
      });
    }
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDate: _selectedDateTime,
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<BookingProvider>().createBooking(
        restaurantId: widget.restaurant.id.toString(),
        email: _emailController.text,
        name: _nameController.text,
        numberOfSeats: int.parse(_seatsController.text),
        dateTime: _selectedDateTime,
        userId: FirebaseAuth.instance.currentUser!.uid,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking created successfully!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Booking",
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: AppTheme.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.restaurant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.restaurant.address} ${widget.restaurant.city}',
                  style: TextStyle(fontSize: 16, color: AppTheme.grey),
                ),
                const SizedBox(height: 24),
                CustomForm(
                  controller: _emailController,
                  hintText: 'Email address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomForm(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomForm(
                  controller: _seatsController,
                  hintText: 'Number of seats',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your number pf seats';
                    }

                    final seats = int.tryParse(value);
                    if (seats == null || seats < 1) {
                      return 'Please enter a valid number';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomForm(
                  controller: TextEditingController(
                    text: _selectedDateTime.toString(),
                  ),
                  hintText: 'Date & Time',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter date and time';
                    }
                    return null;
                  },
                  onTap: _selectDateTime,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildBookingButton(),
    );
  }

  Widget _buildBookingButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Text(
              provider.errorMessage,
              style: TextStyle(color: AppTheme.error),
            );
          }
          return CustomButton(
            text: 'Confirm Booking',
            onPressed: _submitBooking,
          );
        },
      ),
    );
  }
}
