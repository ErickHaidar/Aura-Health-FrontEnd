import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurahealth/screens/edit_profile_screen.dart';
import 'package:aurahealth/models/user.dart';

void main() {
  testWidgets('EditProfileScreen shows CircleAvatar and responds to image selection structure', (WidgetTester tester) async {
    final user = User(id: 1, name: 'Test User', email: 'test@example.com');
    
    await tester.pumpWidget(MaterialApp(
      home: EditProfileScreen(user: user),
    ));

    // Verify CircleAvatar is present
    final avatarFinder = find.byType(CircleAvatar);
    expect(avatarFinder, findsOneWidget);
    
    final CircleAvatar avatar = tester.widget(avatarFinder);
    // Initially should not be a FileImage
    expect(avatar.backgroundImage is! FileImage, true);
  });
}
