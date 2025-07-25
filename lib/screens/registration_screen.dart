import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
  bool _isLoading = false;
  String? _uploadedPhotoName;
  String? _uploadedLogoName;
  
  final List<String> availableSubjects = [
    'AGRICULTURAL SCIENCE', 'CIVIC EDUCATION', 'ENGLISH LANGUAGE',
    'FINANCIAL ACCOUNTING', 'BIOLOGY', 'BIBLE KNOWLEDGE', 'CHEMISTRY',
    'COMMERCE', 'LIT. IN ENGLISH', 'COMPUTER STUDIES', 'MATHEMATICS',
    'BASIC WORKSHOP', 'PHYSICS', 'GEOGRAPHY', 'FRENCH', 'ECONOMICS',
    'FURTHER MATHEMATICS', 'ARABIC'
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: _getLoadingMessage(),
        child: Column(
          children: [
            // Using our custom AppTopBar
            AppTopBar(
              title: 'FILLOP TECH (HANDS-ON CBT)',
              showBackButton: true,
            ),
            
            // Main content
            Expanded(
              child: Container(
                color: Colors.grey[100],
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with logo
                      _buildHeader(),
                      
                      SizedBox(height: 20),
                      
                      // User type selection
                      _buildUserTypeSelection(),
                      
                      SizedBox(height: 20),
                      
                      // Corporate sub-selection
                      if (selectedUserType == 'corporate') ...[
                        _buildCorporateTypeSelection(),
                        SizedBox(height: 20),
                      ],
                      
                      // Form content
                      AppCard(
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
                      
                      SizedBox(height: 30),
                      
                      // Submit button
                      Center(
                        child: AppButton(
                          text: selectedUserType == 'corporate' && selectedCorporateType == 'activate' 
                            ? 'ACTIVATE' 
                            : 'SUBMIT',
                          onPressed: _handleSubmit,
                          isLoading: _isLoading,
                          width: 200,
                        ),
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Login link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          child: Text(
                            'Already have an account? Login here',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FILLOP TECH',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[300],
                ),
              ),
              SizedBox(height: 10),
              SectionTitle(
                title: 'SELECT TYPE',
                subtitle: 'Choose your registration type',
              ),
            ],
          ),
        ),
        AppLogo(size: 80),
      ],
    );
  }

  Widget _buildUserTypeSelection() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: AppRadioGroup<String>(
        title: 'User Type',
        value: selectedUserType,
        options: [
          RadioOption(value: 'new', label: 'New User'),
          RadioOption(value: 'corporate', label: 'Corporate'),
        ],
        onChanged: (value) {
          setState(() {
            selectedUserType = value!;
          });
        },
      ),
    );
  }

  Widget _buildCorporateTypeSelection() {
    return AppCard(
      padding: EdgeInsets.all(16),
      child: AppRadioGroup<String>(
        title: 'Corporate Type',
        value: selectedCorporateType,
        options: [
          RadioOption(value: 'new_registration', label: 'New Registration'),
          RadioOption(value: 'activate', label: 'Activate User'),
        ],
        onChanged: (value) {
          setState(() {
            selectedCorporateType = value!;
          });
        },
      ),
    );
  }

  Widget _buildNewUserForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'NEW USER REGISTRATION'),
        
        AppTextField(
          label: 'Email',
          hint: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        
        SizedBox(height: 15),
        
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'First Name',
                hint: 'First name',
                controller: _nameController,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: AppTextField(
                label: 'Surname',
                hint: 'Surname',
                controller: _surnameController,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 15),
        
        AppTextField(
          label: 'Phone Number',
          hint: 'Enter phone number',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        
        SizedBox(height: 15),
        
        AppRadioGroup<String>(
          title: 'Gender',
          value: selectedGender,
          options: [
            RadioOption(value: 'Male', label: 'Male'),
            RadioOption(value: 'Female', label: 'Female'),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
        ),
        
        SizedBox(height: 15),
        
        FileUploadWidget(
          label: 'Passport Photo',
          hint: 'Upload Photo',
          icon: Icons.camera_alt,
          fileName: _uploadedPhotoName,
          onTap: _handlePhotoUpload,
        ),
        
        SizedBox(height: 15),
        
        _buildSubjectSelection(),
        
        SizedBox(height: 15),
        
        AppRadioGroup<String>(
          title: 'Exam Type',
          value: selectedExamType,
          options: [
            RadioOption(value: 'JAMB', label: 'JAMB'),
            RadioOption(value: 'WAEC', label: 'WAEC'),
            RadioOption(value: 'NECO', label: 'NECO'),
          ],
          onChanged: (value) {
            setState(() {
              selectedExamType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildCorporateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(title: 'CORPORATE REGISTRATION'),
        
        AppTextField(
          label: 'Email',
          hint: 'Enter company email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        
        SizedBox(height: 15),
        
        AppTextField(
          label: 'Company Name',
          hint: 'Enter company name',
          controller: _companyNameController,
        ),
        
        SizedBox(height: 15),
        
        AppTextField(
          label: 'Contact Phone',
          hint: 'Enter contact number',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
        
        SizedBox(height: 15),
        
        FileUploadWidget(
          label: 'Company Logo',
          hint: 'Upload Logo',
          icon: Icons.business,
          fileName: _uploadedLogoName,
          onTap: _handleLogoUpload,
        ),
        
        SizedBox(height: 15),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Plan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPlan,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
        ),
      ],
    );
  }

  Widget _buildActivationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'ACTIVATION',
          subtitle: 'Enter your activation passcode to continue',
        ),
        
        AppTextField(
          label: 'Activation Passcode',
          hint: 'Enter passcode',
          controller: _passcodeController,
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
      ],
    );
  }

  Widget _buildSubjectSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Subjects (maximum 5):',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: availableSubjects.length,
            itemBuilder: (context, index) {
              final subject = availableSubjects[index];
              return CheckboxListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 12),
                ),
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
        
        SizedBox(height: 5),
        
        Text(
          'Selected: ${selectedSubjects.length}/5',
          style: TextStyle(
            color: selectedSubjects.length == 5 ? Colors.green[600] : Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _handlePhotoUpload() {
    // TODO: Implement image picker
    setState(() {
      _uploadedPhotoName = 'passport_photo.jpg';
    });
    _showMessage('Photo upload functionality will be implemented');
  }

  void _handleLogoUpload() {
    // TODO: Implement image picker
    setState(() {
      _uploadedLogoName = 'company_logo.png';
    });
    _showMessage('Logo upload functionality will be implemented');
  }

  String _getLoadingMessage() {
    if (selectedUserType == 'corporate' && selectedCorporateType == 'activate') {
      return 'Validating passcode...';
    }
    return 'Processing registration...';
  }

  void _handleSubmit() async {
    // Basic validation
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    if (selectedUserType == 'corporate' && selectedCorporateType == 'activate') {
      // Handle activation
      _validatePasscode(_passcodeController.text.trim());
    } else {
      // Handle registration - navigate to payment
      _showMessage('Registration successful! Payment screen coming soon.');
      // TODO: Navigate to payment screen
      // Navigator.pushNamed(context, '/payment');
    }
  }

  bool _validateForm() {
    if (selectedUserType == 'corporate' && selectedCorporateType == 'activate') {
      if (_passcodeController.text.trim().isEmpty) {
        _showMessage('Please enter your activation passcode');
        return false;
      }
    } else {
      if (_emailController.text.trim().isEmpty) {
        _showMessage('Please enter your email address');
        return false;
      }
      
      if (selectedUserType == 'new') {
        if (_nameController.text.trim().isEmpty || _surnameController.text.trim().isEmpty) {
          _showMessage('Please enter your full name');
          return false;
        }
        if (selectedSubjects.isEmpty) {
          _showMessage('Please select at least one subject');
          return false;
        }
      } else {
        if (_companyNameController.text.trim().isEmpty) {
          _showMessage('Please enter your company name');
          return false;
        }
      }
      
      if (_phoneController.text.trim().isEmpty) {
        _showMessage('Please enter your phone number');
        return false;
      }
    }
    
    return true;
  }

  void _validatePasscode(String passcode) {
    // This would connect to your backend
    if (passcode == '015209') {
      _showMessage('Activation successful! Exam interface coming soon.');
      // TODO: Navigate to exam interface
      // Navigator.pushReplacementNamed(context, '/exam');
    } else {
      _showMessage('Invalid passcode. Please check and try again.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('successful') ? Colors.green[600] : Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}