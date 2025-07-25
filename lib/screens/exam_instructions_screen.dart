import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';
import 'exam_interface.dart';

class ExamInstructionsScreen extends StatefulWidget {
  final Map<String, dynamic>? examConfig;
  
  const ExamInstructionsScreen({Key? key, this.examConfig}) : super(key: key);
  
  @override
  _ExamInstructionsScreenState createState() => _ExamInstructionsScreenState();
}

class _ExamInstructionsScreenState extends State<ExamInstructionsScreen> {
  List<String> selectedSubjects = ['USE OF ENGLISH', 'BIOLOGY', 'CHEMISTRY', 'PHYSICS'];
  String activeSubject = 'CHEMISTRY';
  
  // Timer for display (120 minutes = 120.00 min)
  int displayMinutes = 120;
  int displaySeconds = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Row(
              children: [
                // Main instructions area
                Expanded(
                  flex: 3,
                  child: _buildInstructionsArea(),
                ),
                // User profile sidebar
                _buildUserProfileSidebar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[800]!, Colors.blue[600]!],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Back button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              SizedBox(width: 20),
              
              // Subject tabs
              Expanded(
                child: Row(
                  children: selectedSubjects.map((subject) {
                    bool isActive = subject == activeSubject;
                    Color bgColor = isActive 
                      ? (subject == 'CHEMISTRY' ? Colors.green[600]! : Colors.blue[700]!)
                      : Colors.blue[700]!;
                    
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              activeSubject = subject;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bgColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: Text(
                            subject,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              SizedBox(width: 20),
              
              // Calculator button
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Text('Calculator', style: TextStyle(fontSize: 12)),
                  onPressed: () {
                    // Calculator functionality can be added here
                  },
                ),
              ),
              
              SizedBox(width: 15),
              
              // Timer display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 18),
                    SizedBox(width: 5),
                    Text(
                      '$displayMinutes.${displaySeconds.toString().padLeft(2, '0')} min',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsArea() {
    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with Instructions title and EXAM MODE badge
            Row(
              children: [
                Text(
                  'Instructions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'EXAM MODE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 30),
            
            // Instructions content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main instructions text
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInstructionText(),
                      ],
                    ),
                  ),
                  
                  SizedBox(width: 30),
                  
                  // Keyboard usage guide
                  Expanded(
                    child: _buildKeyboardUsageGuide(),
                  ),
                ],
              ),
            ),
            
            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionText() {
    return Expanded(
      child: SingleChildScrollView(
        child: Text(
          '''The Buyer shall provide an LPO that will last for three weeks interval.
The LPO shall be raised with the name Masterpiece Energies Ltd (The Seller)
The Buyer shall provide a Bank Guarantee or a Post-Dated Cheque equivalent to the value of the Purchase Order.

Payment shall be made via e-payment to the Seller's designated account. The Seller reserves the right to suspend further deliveries if payments are outstanding beyond the due date.

Any disputes on invoices must be raised within 5 business days from the date of receipt.

PRODUCT QUALITY & LIABILITY
The Seller guarantees that the AGO supplied meets the specifications listed in Clause 3. In case of any quality dispute, a sample shall be analyzed by a mutually agreed independent laboratory at the instance and cost to the Buyer. If the product is found to be non-compliant, the Seller shall replace the defective product.

8. FORCE MAJEURE
Neither Party shall be held liable for failure to perform obligations due to circumstances beyond their reasonable control, including but not limited to: Government regulations or restrictions, Natural disasters, wars, or acts of terrorism, Strikes, protests, or industrial actions, Shortage of raw materials or fuel supply interruptions''',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardUsageGuide() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.pink[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Keyboard Usage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          
          ..._buildKeyboardShortcuts(),
        ],
      ),
    );
  }

  List<Widget> _buildKeyboardShortcuts() {
    final shortcuts = [
      {'key': 'A', 'desc': 'Select option A', 'color': Colors.black},
      {'key': 'B', 'desc': 'Select option B', 'color': Colors.black},
      {'key': 'C', 'desc': 'Select option C', 'color': Colors.black},
      {'key': 'D', 'desc': 'Select option D', 'color': Colors.black},
      {'key': 'N', 'desc': 'Next/Forward', 'color': Colors.black},
      {'key': 'P', 'desc': 'Previous/Back', 'color': Colors.black},
      {'key': '↑', 'desc': 'Move up', 'color': Colors.black},
      {'key': '↓', 'desc': 'Move down', 'color': Colors.black},
      {'key': 'S', 'desc': 'Submit/End Exam', 'color': Colors.orange[600]!},
      {'key': 'Y', 'desc': 'Confirm/End Exam', 'color': Colors.orange[600]!},
    ];

    return shortcuts.map((shortcut) {
      return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: shortcut['color'] as Color,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  shortcut['key'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              '– ${shortcut['desc']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to exam interface
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamInterface(examConfig: widget.examConfig),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'START EXAM',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          SizedBox(width: 20),
          
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSidebar() {
    return Container(
      width: 280,
      color: Colors.blue[100],
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: AppLogo(size: 80),
          ),
          
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
                    
                    // User photo placeholder
                    Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          'assets/images/user_photo.jpg', // You can replace with actual image
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey[600],
                            );
                          },
                        ),
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
                    
                    // FILLOP TECH branding
                    Text(
                      'FILLOP TECH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    Text(
                      'simplifying your tech world',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
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
}