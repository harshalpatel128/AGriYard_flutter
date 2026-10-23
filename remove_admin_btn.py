import re

with open('lib/screens/auth/login_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# Remove import
text = text.replace("import '../admin/admin_navigation_screen.dart';\n", "")
text = text.replace("import '../admin/admin_navigation_screen.dart';\r\n", "")

# Remove actions: [ TextButton(...) ] block from AppBar
text = re.sub(r'actions:\s*\[[\s\S]*?AppStrings\.adminLabel[\s\S]*?\],', '', text)

with open('lib/screens/auth/login_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print('Login screen updated: Admin button removed.')
