import re

with open('lib/screens/market/crop_detail_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

# 1. Remove import
text = text.replace("import 'crop_history_chart_screen.dart';\n", "")
text = text.replace("import 'crop_history_chart_screen.dart';\r\n", "")

# 2. Remove actions block from AppBar
# Find actions: [ ... ],
text = re.sub(r'actions:\s*\[[\s\S]*?IconButton\([\s\S]*?Icons\.show_chart_rounded[\s\S]*?\),[\s\S]*?\],', '', text)

# 3. Remove 'View 7-Day Price Chart & Analytics' InkWell container
text = re.sub(r'InkWell\([\s\S]*?View 7-Day Price Chart & Analytics[\s\S]*?\),[\s\r\n]*const SizedBox\(height: 24\),', '', text)

# 4. Remove InkWell wrapper around Previous 7 Days Title Row
old_title_inkwell = re.search(r'InkWell\([\s\S]*?Previous 7 Days Prices[\s\S]*?\),[\s\r\n]*const SizedBox\(height: 14\),', text)
if old_title_inkwell:
    replacement = """Text(
                'Previous 7 Days Prices (${crop.priceUnit})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),"""
    text = text[:old_title_inkwell.start()] + replacement + text[old_title_inkwell.end():]

# 5. Remove InkWell wrapper around PriceTable
old_table_inkwell = re.search(r'InkWell\([\s\S]*?child:\s*PriceTable\(records:\s*crop\.history\),[\s\r\n]*\),', text)
if old_table_inkwell:
    text = text[:old_table_inkwell.start()] + "PriceTable(records: crop.history)," + text[old_table_inkwell.end():]

with open('lib/screens/market/crop_detail_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("crop_detail_screen.dart cleaned up successfully!")
