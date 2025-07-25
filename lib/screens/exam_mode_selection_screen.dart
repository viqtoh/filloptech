import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class ExamModeSelectionScreen extends StatefulWidget {
  @override
  _ExamModeSelectionScreenState createState() => _ExamModeSelectionScreenState();
}

class _ExamModeSelectionScreenState extends State<ExamModeSelectionScreen> {
  String selectedMode = '';
  String selectedExamType = 'JAMB';
  String selectedSource = '';
  int selectedMinutes = 120;
  
  final List<String> examSources = [
    '2025 UTME Questions',
    '2024 UTME Questions', 
    '2023 UTME Questions',
    '2022 UTME Questions',
    'Practice Questions',
    'Mock Exam Questions'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppTopBar(
            title: 'FILLOP TECH (HANDS-ON CBT)',
            showBackButton: true,
            onBackPressed: () {
                Navigator.pushReplacementNamed(context, '/');
            },
          ),
          
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Row(
                children: [
                  // Main content area
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeHeader(),
                          SizedBox(height: 30),
                          _buildModeSelection(),
                          if (selectedMode.isNotEmpty) ...[
                            SizedBox(height: 20),
                            _buildExamTypeSelection(),
                            SizedBox(height: 20),
                            _buildAdditionalSettings(),
                            SizedBox(height: 30),
                            _buildActionButtons(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  // User profile sidebar
                  _buildUserProfileSidebar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WELCOME!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.green[700],
          ),
        ),
        SizedBox(height: 10),
        SectionTitle(
          title: 'CHOOSE MODE',
          subtitle: 'Select your preferred exam mode to continue',
        ),
      ],
    );
  }

  Widget _buildModeSelection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exam Mode:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(child: _buildModeButton('TIMED EXAMS', Colors.blue[600]!)),
              SizedBox(width: 15),
              Expanded(child: _buildModeButton('UNTIMED EXAMS', Colors.green[600]!)),
              SizedBox(width: 15),
              Expanded(child: _buildModeButton('STUDY', Colors.orange[600]!)),
              SizedBox(width: 15),
              Expanded(child: _buildModeButton('NEWS', Colors.purple[600]!)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(String mode, Color color) {
    bool isSelected = selectedMode == mode;
    
    return Container(
      height: 80,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedMode = mode;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? color : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isSelected ? 8 : 2,
        ),
        child: Text(
          mode,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExamTypeSelection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Exam Type:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          AppRadioGroup<String>(
            title: 'Question Type',
            value: selectedExamType,
            options: [
              RadioOption(value: 'JAMB', label: 'JAMB'),
              RadioOption(value: 'WAEC', label: 'WAEC'),
              RadioOption(value: 'OTHER', label: 'OTHER'),
            ],
            onChanged: (value) {
              setState(() {
                selectedExamType = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalSettings() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exam Settings:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          // Source of Questions
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Source of Questions:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                hint: Text('Click this drop down'),
                value: selectedSource.isEmpty ? null : selectedSource,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: examSources.map((source) {
                  return DropdownMenuItem(
                    value: source,
                    child: Text(source),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSource = value!;
                  });
                },
              ),
            ],
          ),
          
          SizedBox(height: 15),
          
          // Timer setting (only for timed exams)
          if (selectedMode == 'TIMED EXAMS') ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Minutes:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Container(
                  width: 150,
                  child: DropdownButtonFormField<int>(
                    value: selectedMinutes,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [30, 60, 90, 120, 150, 180].map((minutes) {
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text('$minutes minutes'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMinutes = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton(
          text: 'CANCEL',
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.grey[600],
        ),
        SizedBox(width: 20),
        AppButton(
          text: 'NEXT',
          onPressed: selectedSource.isNotEmpty ? _handleNext : null,
          backgroundColor: Colors.blue[800],
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildUserProfileSidebar() {
    return Container(
      width: 280,
      color: Colors.blue[100],
      child: Column(
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.all(20),
            child: AppLogo(size: 80),
          ),
          
          // User details section
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: AppCard(
                backgroundColor: Colors.blue[50],
                child: Column(
                  children: [
                    Text(
                      'Your Details...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Profile photo placeholder
                    Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    SizedBox(height: 15),
                    
                    Text(
                      'Daniel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    Text(
                      'Ezekiel Sunday',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      'Passcode:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    Text(
                      '015209',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Logout button
                    AppButton(
                      text: 'Log out',
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/');
                      },
                      backgroundColor: Colors.red[600],
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() {
    // Create exam configuration
    Map<String, dynamic> examConfig = {
      'mode': selectedMode,
      'examType': selectedExamType,
      'source': selectedSource,
      'minutes': selectedMode == 'TIMED EXAMS' ? selectedMinutes : null,
    };
    
    // Navigate to instructions screen
    Navigator.pushNamed(
      context, 
      '/exam-instructions',
      arguments: examConfig,
    );
  }
}