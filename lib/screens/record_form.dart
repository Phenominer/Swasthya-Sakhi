import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/appstate.dart';

class RecordHealthForm extends StatefulWidget {
  const RecordHealthForm({super.key});

  @override
  State<RecordHealthForm> createState() => _RecordHealthFormState();
}

class _RecordHealthFormState extends State<RecordHealthForm> {
  // BASIC DETAILS
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // ADDRESS DETAILS
  final TextEditingController addressController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // CONDITION
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // VITALS
  final TextEditingController tempController = TextEditingController();
  final TextEditingController pulseController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  final TextEditingController spoController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String gender = "Female";

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Record Health Data",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Basic Details"),

            _inputField("Patient Name", nameController, Icons.person),
            _inputField(
              "Age",
              ageController,
              Icons.calendar_today,
              keyboard: TextInputType.number,
            ),
            _inputField(
              "Phone (optional)",
              phoneController,
              Icons.phone_android,
              keyboard: TextInputType.phone,
            ),

            const SizedBox(height: 10),
            _genderSelector(),

            const SizedBox(height: 25),
            _sectionTitle("Patient Address"),

            _inputField(
              "Full Address",
              addressController,
              Icons.home_rounded,
              multiline: true,
            ),
            _inputField(
              "Village / Locality",
              localityController,
              Icons.location_on_outlined,
            ),
            _inputField(
              "Landmark (optional)",
              landmarkController,
              Icons.map_outlined,
            ),

            _vitalInputRow([
              _vitalBox("Pincode", pincodeController),
              _vitalBox("District", districtController),
            ]),

            const SizedBox(height: 12),
            _inputField("State", stateController, Icons.flag_circle_rounded),

            const SizedBox(height: 25),
            _sectionTitle("Symptoms & Condition"),

            _inputField(
              "Symptoms",
              symptomsController,
              Icons.sick,
              multiline: true,
            ),
            _inputField(
              "Diagnosis (optional)",
              diagnosisController,
              Icons.medical_information,
              multiline: true,
            ),

            const SizedBox(height: 25),
            _sectionTitle("Vitals"),

            _vitalInputRow([
              _vitalBox("Temp (°C)", tempController),
              _vitalBox("Pulse", pulseController),
            ]),

            const SizedBox(height: 12),

            _vitalInputRow([
              _vitalBox("Blood Pressure", bpController),
              _vitalBox("SpO₂ (%)", spoController),
            ]),

            const SizedBox(height: 12),
            _vitalInputRow([_vitalBox("Weight (kg)", weightController)]),

            const SizedBox(height: 25),
            _sectionTitle("Additional Notes"),

            _inputField("Notes", notesController, Icons.notes, multiline: true),

            const SizedBox(height: 35),
            _submitButton(app),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // SUBMIT
  Widget _submitButton(AppState app) {
    return InkWell(
      onTap: () {
        if (nameController.text.trim().isEmpty ||
            ageController.text.trim().isEmpty ||
            addressController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Name, age & address are required")),
          );
          return;
        }

        // Determine patient status
        String status = "normal";
        final temp = double.tryParse(tempController.text) ?? 0;
        final spo = int.tryParse(spoController.text) ?? 100;

        if (spo < 90 || temp > 39) {
          status = "critical";
        } else if (spo < 95 || temp > 37.5) {
          status = "attention";
        }

        final patient = {
          "name": nameController.text.trim(),
          "age": int.tryParse(ageController.text.trim()) ?? 0,
          "gender": gender,
          "address": addressController.text.trim(),
          "village": localityController.text.trim(),
          "landmark": landmarkController.text.trim(),
          "pincode": pincodeController.text.trim(),
          "district": districtController.text.trim(),
          "state": stateController.text.trim(),

          "phone": phoneController.text.trim(),
          "symptoms": symptomsController.text.trim(),
          "diagnosis": diagnosisController.text.trim(),
          "notes": notesController.text.trim(),

          "temp": tempController.text.trim(),
          "pulse": pulseController.text.trim(),
          "bp": bpController.text.trim(),
          "spo2": spoController.text.trim(),
          "weight": weightController.text.trim(),

          "status": status,
          "lastVisit": DateTime.now().toIso8601String(),
        };

        app.addPatient(patient); // <-- CONNECTED HERE

        Navigator.pop(context);
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
            "Submit",
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

  //================ Widgets unchanged below ================//

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 10),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _inputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool multiline = false,
    TextInputType keyboard = TextInputType.text,
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
        maxLines: multiline ? 4 : 1,
        keyboardType: keyboard,
        cursorColor: Colors.blueAccent,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _genderSelector() {
    return Row(
      children: [
        _genderChip("Female"),
        const SizedBox(width: 10),
        _genderChip("Male"),
        const SizedBox(width: 10),
        _genderChip("Other"),
      ],
    );
  }

  Widget _genderChip(String value) {
    final selected = gender == value;

    return InkWell(
      onTap: () => setState(() => gender = value),
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

  Widget _vitalBox(String label, TextEditingController controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vitalInputRow(List<Widget> children) {
    return Row(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}
