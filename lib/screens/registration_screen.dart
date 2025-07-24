import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  String selectedUserType = 'new'; // 'new' or 'corporate'
  String selectedCorporateType = 'new_registration'; // 'new_registration' or 'activate'
  
  // Form controllers
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _passcodeController = TextEditingController();
  
  String selectedGender = 'Male';
  List<String> selectedSubjects = [];
  String selectedExamType = 'JAMB';
  String selectedPlan = '5';
  
  final List<String> availableSubjects = [
    'AGRICULTURAL SCIENCE', 'CIVIC EDUCATION', 'ENGLISH LANGUAGE',
    'FINANCIAL ACCOUNTING', 'BIOLOGY', 'BIBLE KNOWLEDGE', 'CHEMISTRY',
    'COMMERCE', 'LIT. IN ENGLISH', 'COMPUTER STUDIES', 'MATHEMATICS',
    'BASIC WORKSHOP', 'PHYSICS', 'GEOGRAPHY', 'FRENCH', 'ECONOMICS',
    'FURTHER MATHEMATICS', 'ARABIC'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('FILLOP TECH (HANDS-ON CBT)'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Text(
                    'FILLOP TECH',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[300],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'SELECT TYPE',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // User Type Selection
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('New User Registration'),
                    value: 'new',
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Corporate (multiple user)'),
                    value: 'corporate',
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Corporate Sub-selection
            if (selectedUserType == 'corporate') ...[
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('New Registration'),
                      value: 'new_registration',
                      groupValue: selectedCorporateType,
                      onChanged: (value) {
                        setState(() {
                          selectedCorporateType = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Activated User'),
                      value: 'activate',
                      groupValue: selectedCorporateType,
                      onChanged: (value) {
                        setState(() {
                          selectedCorporateType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
            
            // Form Fields
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedUserType == 'new') 
                      _buildNewUserForm()
                    else if (selectedCorporateType == 'new_registration')
                      _buildCorporateForm()
                    else
                      _buildActivationForm(),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text(
                  selectedUserType == 'corporate' && selectedCorporateType == 'activate' 
                    ? 'ACTIVATE' 
                    : 'SUBMIT'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewUserForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('NEW USER REGISTRATION', 
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        
        _buildTextField('Email', _emailController, 'Enter your email'),
        SizedBox(height: 15),
        
        Row(
          children: [
            Expanded(child: _buildTextField('First Name', _nameController, 'First name')),
            SizedBox(width: 15),
            Expanded(child: _buildTextField('Surname', _surnameController, 'Surname')),
          ],
        ),
        SizedBox(height: 15),
        
        _buildTextField('Phone Number', _phoneController, 'Enter phone number'),
        SizedBox(height: 15),
        
        // Gender Selection
        Text('Gender:', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio<String>(
              value: 'Male',
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value!),
            ),
            Text('Male'),
            Radio<String>(
              value: 'Female',
              groupValue: selectedGender,
              onChanged: (value) => setState(() => selectedGender = value!),
            ),
            Text('Female'),
          ],
        ),
        SizedBox(height: 15),
        
        // Photo Upload Placeholder
        Text('Passport Photo:', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                Text('Upload Photo', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        
        _buildSubjectSelection(),
        SizedBox(height: 15),
        
        _buildExamTypeSelection(),
      ],
    );
  }

  Widget _buildCorporateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CORPORATE REGISTRATION', 
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        
        _buildTextField('Email', _emailController, 'Enter company email'),
        SizedBox(height: 15),
        
        _buildTextField('Company Name', _companyNameController, 'Enter company name'),
        SizedBox(height: 15),
        
        _buildTextField('Contact Phone', _phoneController, 'Enter contact number'),
        SizedBox(height: 15),
        
        // Company Logo Upload
        Text('Company Logo:', style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business, size: 40, color: Colors.grey),
                Text('Upload Logo', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        SizedBox(height: 15),
        
        // Plan Selection
        Text('Select Plan:', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(
          value: selectedPlan,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: ['5', '10', '20', '50', '100'].map((plan) {
            return DropdownMenuItem(
              value: plan,
              child: Text('$plan systems'),
            );
          }).toList(),
          onChanged: (value) => setState(() => selectedPlan = value!),
        ),
      ],
    );
  }

  Widget _buildActivationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ACTIVATION', 
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        
        Text('Enter your activation passcode:', 
             style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        
        TextField(
          controller: _passcodeController,
          decoration: InputDecoration(
            hintText: 'Enter passcode',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label + ':', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Subjects (maximum 5):', 
             style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: availableSubjects.length,
            itemBuilder: (context, index) {
              final subject = availableSubjects[index];
              return CheckboxListTile(
                title: Text(subject, style: TextStyle(fontSize: 12)),
                value: selectedSubjects.contains(subject),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true && selectedSubjects.length < 5) {
                      selectedSubjects.add(subject);
                    } else if (value == false) {
                      selectedSubjects.remove(subject);
                    }
                  });
                },
                dense: true,
              );
            },
          ),
        ),
        Text('Selected: ${selectedSubjects.length}/5', 
             style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildExamTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Exam Type:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          children: [
            Radio<String>(
              value: 'JAMB',
              groupValue: selectedExamType,
              onChanged: (value) => setState(() => selectedExamType = value!),
            ),
            Text('JAMB'),
            Radio<String>(
              value: 'WAEC',
              groupValue: selectedExamType,
              onChanged: (value) => setState(() => selectedExamType = value!),
            ),
            Text('WAEC'),
            Radio<String>(
              value: 'NECO',
              groupValue: selectedExamType,
              onChanged: (value) => setState(() => selectedExamType = value!),
            ),
            Text('NECO'),
          ],
        ),
      ],
    );
  }

  void _handleSubmit() {
    // Validation and submit logic
    if (selectedUserType == 'corporate' && selectedCorporateType == 'activate') {
      // Handle activation
      if (_passcodeController.text.isEmpty) {
        _showMessage('Please enter passcode');
        return;
      }
      // Validate passcode and navigate to exam interface
      _validatePasscode(_passcodeController.text);
    } else {
      // Handle registration
      if (_emailController.text.isEmpty) {
        _showMessage('Please enter email');
        return;
      }
      // Navigate to payment screen
      _navigateToPayment();
    }
  }

  void _validatePasscode(String passcode) {
    // This would connect to your backend
    if (passcode == '015209') { // Example validation
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExamInterface()),
      );
    } else {
      _showMessage('Invalid passcode');
    }
  }

  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen()),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Placeholder screens
class ExamInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exam Interface')),
      body: Center(child: Text('Exam Interface - Coming Soon')),
    );
  }
}

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Center(child: Text('Payment Screen - Coming Soon')),
    );
  }
}