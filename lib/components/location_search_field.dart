import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';
import '../theme.dart';

class LocationSearchField extends StatefulWidget {
  final LocationModel? initialLocation;
  final ValueChanged<LocationModel?> onLocationSelected;
  final String label;
  final String hint;

  const LocationSearchField({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.label = 'BIRTH LOCATION',
    this.hint = 'Search for city...',
  });

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  List<LocationModel> _suggestions = [];
  bool _isLoading = false;
  bool _showSuggestions = false;
  LocationModel? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
    if (_selectedLocation != null) {
      _controller.text = _selectedLocation!.formattedAddress;
    }
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  Future<void> _onSearchChanged(String query) async {
    if (query.length < 2) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await LocationService.searchLocations(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _showSuggestions = results.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onLocationSelected(LocationModel location) {
    setState(() {
      _selectedLocation = location;
      _controller.text = location.formattedAddress;
      _showSuggestions = false;
    });
    widget.onLocationSelected(location);
    _focusNode.unfocus();
  }

  void _clearSelection() {
    setState(() {
      _selectedLocation = null;
      _controller.clear();
      _suggestions = [];
      _showSuggestions = false;
    });
    widget.onLocationSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppTheme.textMuted,
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        
        // Search Field
        CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppTheme.textMuted.withOpacity(0.5)),
              prefixIcon: const Icon(
                Symbols.location_on,
                color: AppTheme.textMuted,
              ),
              suffixIcon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    )
                  : _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Symbols.close,
                            color: AppTheme.textMuted,
                          ),
                          tooltip: 'Clear search',
                          onPressed: _clearSelection,
                        )
                      : null,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        
        // Suggestions Dropdown
        if (_showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final location = _suggestions[index];
                return InkWell(
                  onTap: () => _onLocationSelected(location),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Symbols.location_on,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.shortName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                location.formattedAddress,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textMuted,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${location.latitude.toStringAsFixed(2)}, ${location.longitude.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.textMuted,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        
        // Selected Location Info
        if (_selectedLocation != null && !_showSuggestions)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                const Icon(
                  Symbols.check_circle,
                  color: AppTheme.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lon: ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.primary,
                      ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}