import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/app_widgets.dart';

class ExamInterface extends StatefulWidget {
  final Map<String, dynamic>? examConfig;
  
  const ExamInterface({Key? key, this.examConfig}) : super(key: key);
  
  @override
  _ExamInterfaceState createState() => _ExamInterfaceState();
}

class _ExamInterfaceState extends State<ExamInterface> {
  int currentQuestionIndex = 2; // Starting at question 3 as shown in image
  List<String> selectedSubjects = ['USE OF ENGLISH', 'BIOLOGY', 'CHEMISTRY', 'PHYSICS'];
  String activeSubject = 'CHEMISTRY';
  
  // Timer related
  Timer? _timer;
  int totalMinutes = 119;
  int totalSeconds = 33;
  
  // Question navigation
  List<QuestionStatus> questionStatuses = [];
  
  // Sample question data
  Map<String, dynamic> currentQuestion = {
    'subject': 'CHEMISTRY',
    'questionNumber': 3,
    'question': 'The value of -18 °C on the Kelvin temperature scale is',
    'options': [
      {'label': 'A', 'text': '291'},
      {'label': 'B', 'text': '273'},
      {'label': 'C', 'text': '255'},
      {'label': 'D', 'text': '118'},
    ],
    'selectedAnswer': null,
  };
  
  bool showSubmitDialog = false;
  bool showCalculator = false;

  @override
  void initState() {
    super.initState();
    _initializeQuestionGrid();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeQuestionGrid() {
    // Initialize 40 questions with different statuses
    questionStatuses = List.generate(40, (index) {
      if (index < 2) return QuestionStatus.attempted;
      if (index == 2) return QuestionStatus.current;
      return QuestionStatus.unanswered;
    });
  }

  void _startTimer() {
    if (widget.examConfig?['mode'] == 'TIMED EXAMS') {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (totalSeconds > 0) {
            totalSeconds--;
          } else if (totalMinutes > 0) {
            totalMinutes--;
            totalSeconds = 59;
          } else {
            // Time up
            timer.cancel();
            _showTimeUpDialog();
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Row(
                  children: [
                    // Main exam area
                    Expanded(
                      flex: 3,
                      child: _buildExamArea(),
                    ),
                    // User profile sidebar
                    _buildUserProfileSidebar(),
                  ],
                ),
              ),
            ],
          ),
          
          // Submit confirmation dialog
          if (showSubmitDialog) _buildSubmitDialog(),
          
          // Calculator overlay
          if (showCalculator) _buildCalculatorOverlay(),
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
                    setState(() {
                      showCalculator = !showCalculator;
                    });
                  },
                ),
              ),
              
              SizedBox(width: 15),
              
              // Timer
              if (widget.examConfig?['mode'] == 'TIMED EXAMS')
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
                        '$totalMinutes.${totalSeconds.toString().padLeft(2, '0')} min',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              
              SizedBox(width: 15),
              
              // Submit button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showSubmitDialog = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamArea() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          // Question area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject and question number
                  Row(
                    children: [
                      Text(
                        activeSubject,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[600],
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
                  
                  SizedBox(height: 10),
                  
                  Text(
                    'Question ${currentQuestion['questionNumber']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Question text
                  Text(
                    currentQuestion['question'],
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Answer options
                  ...currentQuestion['options'].map<Widget>((option) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: [
                          Text(
                            '(${option['label']})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          Radio(
                            value: option['label'],
                            groupValue: currentQuestion['selectedAnswer'],
                            onChanged: (value) {
                              setState(() {
                                currentQuestion['selectedAnswer'] = value;
                                // Update question status to attempted
                                questionStatuses[currentQuestionIndex] = QuestionStatus.attempted;
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          Text(
                            option['text'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // Navigation area
          _buildNavigationArea(),
        ],
      ),
    );
  }

  Widget _buildNavigationArea() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Previous and Next buttons with question grid
          Row(
            children: [
              // Previous button
              ElevatedButton(
                onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
                child: Text('PREVIOUS'),
              ),
              
              SizedBox(width: 20),
              
              // Question grid
              Expanded(
                child: _buildQuestionGrid(),
              ),
              
              SizedBox(width: 20),
              
              // Next button
              ElevatedButton(
                onPressed: currentQuestionIndex < 39 ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                ),
                child: Text('NEXT'),
              ),
            ],
          ),
          
          SizedBox(height: 15),
          
          // Info section
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'INFO',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Attempted ${_getAttemptedCount()} of 40',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(width: 20),
              Text(
                'Random question selection. Extract of 2025 UTME questions',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionGrid() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(40, (index) {
        QuestionStatus status = questionStatuses[index];
        Color backgroundColor;
        Color textColor = Colors.white;
        
        switch (status) {
          case QuestionStatus.current:
            backgroundColor = Colors.green[600]!;
            break;
          case QuestionStatus.attempted:
            backgroundColor = Colors.red[600]!;
            break;
          case QuestionStatus.unanswered:
            backgroundColor = Colors.orange[600]!;
            break;
        }
        
        return GestureDetector(
          onTap: () => _goToQuestion(index),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }),
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

  Widget _buildSubmitDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 400,
          child: AppCard(
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Text(
                    'Submit Exams',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
                
                Text(
                  'Are you sure you want to submit this Exams?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[700],
                  ),
                ),
                
                SizedBox(height: 30),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showSubmitDialog = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text('No'),
                    ),
                    ElevatedButton(
                      onPressed: _submitExam,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text('Yes'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalculatorOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 300,
          height: 400,
          child: AppCard(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                // Calculator header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          showCalculator = false;
                        });
                      },
                    ),
                  ],
                ),
                
                // Calculator display
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 10),
                
                // Calculator buttons (simplified)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      'C', '÷', '×', '⌫',
                      '7', '8', '9', '-',
                      '4', '5', '6', '+',
                      '1', '2', '3', '=',
                      '0', '.', '', '',
                    ].map((text) {
                      if (text.isEmpty) return SizedBox();
                      
                      Color buttonColor = Colors.grey[300]!;
                      if ('+-×÷='.contains(text)) buttonColor = Colors.blue[100]!;
                      if (text == 'C' || text == '⌫') buttonColor = Colors.red[100]!;
                      
                      return ElevatedButton(
                        onPressed: () {
                          // Calculator logic would go here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        questionStatuses[currentQuestionIndex] = QuestionStatus.attempted;
        currentQuestionIndex--;
        questionStatuses[currentQuestionIndex] = QuestionStatus.current;
        _loadQuestion(currentQuestionIndex);
      });
    }
  }

  void _nextQuestion() {
    if (currentQuestionIndex < 39) {
      setState(() {
        questionStatuses[currentQuestionIndex] = QuestionStatus.attempted;
        currentQuestionIndex++;
        questionStatuses[currentQuestionIndex] = QuestionStatus.current;
        _loadQuestion(currentQuestionIndex);
      });
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      questionStatuses[currentQuestionIndex] = QuestionStatus.attempted;
      currentQuestionIndex = index;
      questionStatuses[currentQuestionIndex] = QuestionStatus.current;
      _loadQuestion(currentQuestionIndex);
    });
  }

  void _loadQuestion(int index) {
    // This would load the actual question data
    // For now, just update the question number
    currentQuestion['questionNumber'] = index + 1;
  }

  int _getAttemptedCount() {
    return questionStatuses.where((status) => 
      status == QuestionStatus.attempted || status == QuestionStatus.current
    ).length;
  }

  void _submitExam() {
    setState(() {
      showSubmitDialog = false;
    });
    
    // Navigate to results screen (to be created)
    Navigator.pushReplacementNamed(context, '/exam-results');
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Time Up!'),
        content: Text('Your exam time has ended. Your answers will be submitted automatically.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

enum QuestionStatus {
  current,
  attempted,
  unanswered,
}