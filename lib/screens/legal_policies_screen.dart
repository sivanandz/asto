import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme.dart';

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textMain),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Back',
          ),
          title: const Text(
            'Legal Policies',
            style: TextStyle(
              color: AppTheme.textMain,
              fontFamily: 'Public Sans',
            ),
          ),
          bottom: const TabBar(
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textMuted,
            indicatorColor: AppTheme.primary,
            tabs: [
              Tab(text: 'Privacy Policy'),
              Tab(text: 'Terms of Service'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPolicyList(context, true),
            _buildPolicyList(context, false),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyList(BuildContext context, bool isPrivacy) {
    final policies = isPrivacy ? _privacyPolicies : _termsOfService;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: policies.length,
      itemBuilder: (context, index) {
        final policy = policies[index];
        return Card(
          color: AppTheme.surfaceContainerLow,
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.borderColor),
          ),
          child: ExpansionTile(
            title: Text(
              policy['region']!,
              style: const TextStyle(
                color: AppTheme.textMain,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconColor: AppTheme.primary,
            collapsedIconColor: AppTheme.textMuted,
            childrenPadding: const EdgeInsets.all(16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: policy['content']!,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(color: AppTheme.textMuted),
                  h1: const TextStyle(color: AppTheme.textMain),
                  h2: const TextStyle(color: AppTheme.textMain),
                  listBullet: const TextStyle(color: AppTheme.textMuted),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static const List<Map<String, String>> _privacyPolicies = [
    {
      'region': 'General (Global)',
      'content': '''
# Privacy Policy

**Effective Date:** January 1, 2024

We are committed to protecting your privacy. This General Privacy Policy applies to users worldwide unless superseded by regional specific policies below.

## Information We Collect
We collect minimal information necessary to provide you with an optimal experience. This may include device information and non-personally identifiable app usage data.

## How We Use Information
We use the collected information to improve our app performance, fix bugs, and analyze broad usage trends. We do not sell your personal data.
''',
    },
    {
      'region': 'European Union (GDPR)',
      'content': '''
# GDPR Privacy Notice

If you are a resident of the European Economic Area (EEA), you have certain data protection rights.

## Your Rights
*   **The right to access, update or to delete** the information we have on you.
*   **The right of rectification.** You have the right to have your information rectified if that information is inaccurate or incomplete.
*   **The right to object.** You have the right to object to our processing of your Personal Data.
*   **The right of restriction.** You have the right to request that we restrict the processing of your personal information.

We act as a Data Controller for your Personal Data.
''',
    },
    {
      'region': 'California, USA (CCPA)',
      'content': '''
# CCPA Privacy Notice

This section applies solely to all visitors, users, and others who reside in the State of California.

## Your Rights under CCPA
*   **Right to know** what personal information is being collected about you.
*   **Right to know** whether your personal information is sold or disclosed and to whom.
*   **Right to say no** to the sale of personal information (Right to Opt-Out).
*   **Right to delete** your personal information.
*   **Right to non-discrimination** for exercising your CCPA rights.
''',
    },
  ];

  static const List<Map<String, String>> _termsOfService = [
    {
      'region': 'General (Global)',
      'content': '''
# Terms of Service

**Effective Date:** January 1, 2024

By using our application, you agree to these terms. Please read them carefully.

## Use of Our Services
You must follow any policies made available to you within the Services. Do not misuse our Services. For example, do not interfere with our Services or try to access them using a method other than the interface and the instructions that we provide.

## Warranties and Disclaimers
We provide our Services using a commercially reasonable level of skill and care. However, we do not make any specific promises about the Services. THE SERVICES ARE PROVIDED "AS IS".
''',
    },
    {
      'region': 'European Union',
      'content': '''
# EU Terms of Service Addendum

For users residing in the European Union, the following terms apply in addition to the General Terms of Service.

## Liability
Nothing in these Terms limits liability for death or personal injury caused by our negligence or for our fraud or fraudulent misrepresentation. Our liability will be limited to the fullest extent permitted by applicable EU laws.
''',
    },
    {
      'region': 'United States',
      'content': '''
# US Terms of Service Addendum

## Dispute Resolution (Binding Arbitration)
If you reside in the United States, you and we agree that any dispute, claim, or controversy arising out of or relating to these Terms or the breach, termination, enforcement, interpretation, or validity thereof, will be settled by binding arbitration, and you waive your right to a jury trial.
''',
    },
  ];
}
