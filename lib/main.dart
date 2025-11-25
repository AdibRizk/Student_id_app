import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'id_generator.dart';
import 'id_type.dart';

void main() {
  runApp(StudentIDApp());
}

// Main App Widget
class StudentIDApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student ID Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StudentIDHomePage(),
    );
  }
}

// Home Page Widget
class StudentIDHomePage extends StatefulWidget {
  @override
  _StudentIDHomePageState createState() => _StudentIDHomePageState();
}

class _StudentIDHomePageState extends State<StudentIDHomePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _birthDate;
  IDType? _selectedMajor;

  final IDGenerator _idGenerator = IDGenerator();
  String _generatedID = "";
  List<String> _history = [];
  final List<IDType> _majors = IDType.values;

  // Function to pick birth date
  void _pickBirthDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _birthDate = date;
      });
    }
  }

  // Function to generate ID
  void _generateID() {
    if (_selectedMajor == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a major')));
      return;
    }

    // Generate the ID
    String id = _idGenerator.generateID(_selectedMajor!);

    // Save to history and clear inputs
    setState(() {
      _generatedID = id;
      _history.insert(0, id); // newest first
      _nameController.clear();
      _phoneController.clear();
      _birthDate = null;
      _selectedMajor = null;
    });
  }

  // Copy to clipboard
  void _copyID() {
    if (_generatedID.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedID));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID copied to clipboard')),
      );
    }
  }

  String _majorToString(IDType major) {
    switch (major) {
      case IDType.computerScience:
        return 'Computer Science';
      case IDType.engineering:
        return 'Engineering';
      case IDType.mathematics:
        return 'Mathematics';
      case IDType.physics:
        return 'Physics';
      case IDType.biology:
        return 'Biology';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Student ID Generator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Full Name
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                  labelText: 'Full Name', border: OutlineInputBorder()),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _generateID(), // Enter key triggers generation
            ),
            SizedBox(height: 12),

            // Phone
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                  labelText: 'Phone Number', border: OutlineInputBorder()),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => _generateID(),
            ),
            SizedBox(height: 12),

            // Birth Date picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    _birthDate == null
                        ? 'Select Birth Date'
                        : 'Birth Date: ${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                  ),
                ),
                TextButton(
                  child: Text('Pick Date'),
                  onPressed: _pickBirthDate,
                ),
              ],
            ),
            SizedBox(height: 12),

            // Major Dropdown
            DropdownButtonFormField<IDType>(
              value: _selectedMajor,
              items: _majors
                  .map((major) => DropdownMenuItem(
                value: major,
                child: Text(_majorToString(major)),
              ))
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedMajor = value;
              }),
              decoration: InputDecoration(
                labelText: 'Select Major',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Generate button
            ElevatedButton(
              onPressed: _generateID,
              child: Text('Generate Student ID'),
            ),
            SizedBox(height: 20),

            // Display generated ID + copy button
            if (_generatedID.isNotEmpty)
              Column(
                children: [
                  SelectableText(
                    _generatedID,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: _copyID,
                    icon: Icon(Icons.copy),
                    label: Text('Copy ID'),
                  ),
                ],
              ),

            SizedBox(height: 20),
            Divider(),
            Text(
              'Generated IDs History',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            _history.isEmpty
                ? Text('No IDs generated yet')
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_history[index]));
              },
            ),
          ],
        ),
      ),
    );
  }
}
