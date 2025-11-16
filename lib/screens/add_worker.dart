import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class AddWorkerForm extends StatefulWidget {
  const AddWorkerForm({super.key});

  @override
  State<AddWorkerForm> createState() => _AddWorkerFormState();
}

class _AddWorkerFormState extends State<AddWorkerForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController organisationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController workerIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String role = "Field Worker";

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Add Worker", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section("Worker Information"),

            _field("Full Name", nameController, Icons.person),
            _field(
              "Phone Number",
              phoneController,
              Icons.phone,
              type: TextInputType.phone,
            ),
            _field("Organisation", organisationController, Icons.apartment),
            _field(
              "Area / District",
              areaController,
              Icons.location_city_rounded,
            ),

            const SizedBox(height: 10),
            _roleSelector(),

            _section("System Details"),
            _field("Worker ID", workerIdController, Icons.badge_outlined),
            _field(
              "Temporary Password",
              passwordController,
              Icons.lock_outline_rounded,
            ),

            const SizedBox(height: 25),
            _submitButton(app),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /* -------------------------------------------
                SECTION TITLE
  -------------------------------------------- */
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /* -------------------------------------------
                TEXT FIELD
  -------------------------------------------- */
  Widget _field(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),

      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.blueAccent,

        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /* -------------------------------------------
                  ROLE SELECTOR
  -------------------------------------------- */
  Widget _roleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Role",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            _roleChip("Field Worker"),
            const SizedBox(width: 10),
            _roleChip("Supervisor"),
          ],
        ),
      ],
    );
  }

  Widget _roleChip(String value) {
    final selected = (role == value);

    return InkWell(
      onTap: () => setState(() => role = value),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent.withOpacity(0.3) : Colors.white12,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.blueAccent
                : Colors.white.withOpacity(0.15),
          ),
        ),

        child: Text(
          value,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /* -------------------------------------------
               SUBMIT BUTTON
    Adds worker to AppState
  -------------------------------------------- */
  Widget _submitButton(AppState app) {
    return InkWell(
      onTap: () {
        if (nameController.text.isEmpty ||
            phoneController.text.isEmpty ||
            workerIdController.text.isEmpty ||
            passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all fields")),
          );
          return;
        }

        app.allWorkers.add({
          "name": nameController.text.trim(),
          "phone": phoneController.text.trim(),
          "organisation": organisationController.text.trim(),
          "area": areaController.text.trim(),
          "role": role,
          "id": workerIdController.text.trim(),
          "password": passwordController.text.trim(),
        });

        app.totalWorkers++;
        app.notifyListeners();

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Worker added successfully")),
        );
      },

      borderRadius: BorderRadius.circular(16),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E3A8A).withOpacity(0.9),
              const Color(0xFF3B82F6).withOpacity(0.85),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: const Center(
          child: Text(
            "Create Worker",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
