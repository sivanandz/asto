import re

with open('lib/screens/vedic_view_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("position.planet.displayName,", "position.planet.name.capitalize(),")

with open('lib/screens/vedic_view_screen.dart', 'w') as f:
    f.write(content)
