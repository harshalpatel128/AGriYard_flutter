import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../services/app_state.dart';
import '../../widgets/custom_button.dart';

class ContactHelpScreen extends StatefulWidget {
  const ContactHelpScreen({super.key});

  @override
  State<ContactHelpScreen> createState() => _ContactHelpScreenState();
}

class _ContactHelpScreenState extends State<ContactHelpScreen> {
  final Map<int, bool> _expandedFaqs = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  void _showFeedbackDialog() {
    final feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Send Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('We appreciate your feedback to improve AgriYard.'),
            const SizedBox(height: 12),
            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your issue or suggestion...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMedium)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you! Your feedback has been received.'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'How are the prices updated?',
        'a': 'Prices are updated daily from official APMC market yard records by authorized yard superintendents and verified traders.',
      },
      {
        'q': 'What is the price for?',
        'a': 'All crop prices displayed are benchmarked for standard 20 Kg bags (1 Man / Maund) as per Gujarat agricultural trade standards.',
      },
      {
        'q': 'How can I contact shop?',
        'a': 'You can tap on the green phone icon in the Shop Directory or Yard Detail pages to directly dial any registered trader or commission agent.',
      },
      {
        'q': 'Is the data 100% accurate?',
        'a': 'Yes, prices and arrivals are synced with APMC daily morning bulletin reports.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Contact & Help',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Helpline Number Card
              InkWell(
                onTap: () => AppState().makePhoneCall('+919624042246'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF7EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.phone_outlined, color: AppColors.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Helpline Number',
                            style: TextStyle(fontSize: 13, color: AppColors.textLight),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '+919624042246',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Email Support Card
              InkWell(
                onTap: () => AppState().sendEmail('support@agriyard.com'),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFF7EE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.mail_outline_rounded, color: AppColors.primaryGreen, size: 22),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Support',
                            style: TextStyle(fontSize: 13, color: AppColors.textLight),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'support@agriyard.com',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Frequently Asked Questions
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),

              // FAQ List
              ...List.generate(faqs.length, (idx) {
                final faq = faqs[idx];
                final isExp = _expandedFaqs[idx] ?? false;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expandedFaqs[idx] = !isExp;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                faq['q']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              isExp ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textLight,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExp) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, right: 16),
                        child: Text(
                          faq['a']!,
                          style: const TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.4),
                        ),
                      ),
                    ],
                    const Divider(color: AppColors.borderLight, height: 1),
                  ],
                );
              }),

              const SizedBox(height: 36),

              // Send Feedback CTA
              CustomPrimaryButton(
                text: 'Send Feedback',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: _showFeedbackDialog,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
