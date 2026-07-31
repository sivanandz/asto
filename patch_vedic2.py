import re

with open('lib/screens/vedic_view_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("style: _selectedStyle,", "style: _selectedStyle!,")

with open('lib/screens/vedic_view_screen.dart', 'w') as f:
    f.write(content)
