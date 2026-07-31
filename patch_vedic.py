import re

with open('lib/screens/vedic_view_screen.dart', 'r') as f:
    content = f.read()

# Update state initialization
old_state = """class _VedicViewScreenState extends State<VedicViewScreen> {
  VedicChartStyle _selectedStyle = VedicChartStyle.northIndian;"""
new_state = """class _VedicViewScreenState extends State<VedicViewScreen> {
  VedicChartStyle? _selectedStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedStyle ??= context.read<AppProvider>().vedicChartStyle;
  }"""
if old_state in content:
    content = content.replace(old_state, new_state)

# Update build access
content = content.replace("isSelected: _selectedStyle == VedicChartStyle.northIndian", "isSelected: _selectedStyle == VedicChartStyle.northIndian")
# Note, actually the previous replace didn't change anything, so let's update toggle methods

old_toggles = """          _buildToggleButton(
            label: 'North Indian',
            isSelected: _selectedStyle == VedicChartStyle.northIndian,
            onPressed: () => setState(() => _selectedStyle = VedicChartStyle.northIndian),
          ),
          _buildToggleButton(
            label: 'South Indian',
            isSelected: _selectedStyle == VedicChartStyle.southIndian,
            onPressed: () => setState(() => _selectedStyle = VedicChartStyle.southIndian),
          ),"""

new_toggles = """          _buildToggleButton(
            label: 'North Indian',
            isSelected: _selectedStyle == VedicChartStyle.northIndian,
            onPressed: () {
              setState(() => _selectedStyle = VedicChartStyle.northIndian);
              context.read<AppProvider>().setVedicChartStyle(VedicChartStyle.northIndian);
            },
          ),
          _buildToggleButton(
            label: 'South Indian',
            isSelected: _selectedStyle == VedicChartStyle.southIndian,
            onPressed: () {
              setState(() => _selectedStyle = VedicChartStyle.southIndian);
              context.read<AppProvider>().setVedicChartStyle(VedicChartStyle.southIndian);
            },
          ),"""

if old_toggles in content:
    content = content.replace(old_toggles, new_toggles)

with open('lib/screens/vedic_view_screen.dart', 'w') as f:
    f.write(content)
