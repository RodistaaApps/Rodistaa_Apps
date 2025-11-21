import 'package:flutter/material.dart';

class KYCDetailsScreen extends StatefulWidget {
  const KYCDetailsScreen({Key? key}) : super(key: key);

  @override
  State<KYCDetailsScreen> createState() => _KYCDetailsScreenState();
}

class _KYCDetailsScreenState extends State<KYCDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _businessController = TextEditingController();
  final _gstController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _businessController.dispose();
    _gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFC90D0D),
        elevation: 0,
        title: const Text(
          'KYC Verification',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC90D0D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC90D0D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complete Your KYC',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC90D0D),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Verify your identity to unlock all features',
                            style: TextStyle(
                              fontFamily: 'Times New Roman',
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Details
              const Text(
                'Personal Details',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC90D0D),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name (as per Aadhaar)',
                icon: Icons.person,
                hint: 'Enter your full name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _aadhaarController,
                label: 'Aadhaar Number',
                icon: Icons.credit_card,
                hint: 'XXXX-XXXX-XXXX',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _panController,
                label: 'PAN Number',
                icon: Icons.badge,
                hint: 'ABCDE1234F',
              ),
              const SizedBox(height: 32),

              // Business Details (Optional)
              const Text(
                'Business Details (Optional)',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC90D0D),
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _businessController,
                label: 'Business Name',
                icon: Icons.business,
                hint: 'Enter business name',
                required: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _gstController,
                label: 'GST Number',
                icon: Icons.assignment,
                hint: 'Enter GST number',
                required: false,
              ),
              const SizedBox(height: 32),

              // Document Upload Section
              const Text(
                'Documents',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC90D0D),
                ),
              ),
              const SizedBox(height: 16),
              _buildDocumentUpload('Aadhaar Card', Icons.upload_file),
              const SizedBox(height: 12),
              _buildDocumentUpload('PAN Card', Icons.upload_file),
              const SizedBox(height: 12),
              _buildDocumentUpload('Business Registration (Optional)', Icons.upload_file),
              const SizedBox(height: 40),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitKYC,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC90D0D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit KYC',
                    style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    bool required = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Times New Roman'),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontFamily: 'Times New Roman',
          color: Color(0xFFC90D0D),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Times New Roman',
          color: Colors.grey.shade400,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFC90D0D)),
        filled: true,
        fillColor: const Color(0xFFC90D0D).withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC90D0D), width: 2),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildDocumentUpload(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC90D0D).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFC90D0D).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFC90D0D)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'File picker coming soon!',
                    style: TextStyle(fontFamily: 'Times New Roman'),
                  ),
                  backgroundColor: Color(0xFFC90D0D),
                ),
              );
            },
            child: const Text(
              'Upload',
              style: TextStyle(
                fontFamily: 'Times New Roman',
                color: Color(0xFFC90D0D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitKYC() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFC90D0D),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'Success!',
                style: TextStyle(
                  fontFamily: 'Times New Roman',
                  color: Color(0xFFC90D0D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your KYC has been submitted successfully!\n\nOur team will verify your documents within 24-48 hours.',
            style: TextStyle(fontFamily: 'Times New Roman'),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true); // Return true to indicate KYC completed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC90D0D),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontFamily: 'Times New Roman',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

