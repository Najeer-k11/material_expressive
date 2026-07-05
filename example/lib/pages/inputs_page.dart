import 'package:flutter/material.dart';
import 'package:material_expressive/material_expressive.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  var _sliderVal = 0.4;
  var _switchOn = true;
  var _checkA = true;
  var _checkB = false;
  var _radio = 0;
  DateTime? _date;
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Inputs')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section('Slider', [
            Text(
              'Expressive slider — capsule thumb, thick active track',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Slider(
              value: _sliderVal,
              onChanged: (v) => setState(() => _sliderVal = v),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _sliderVal,
              divisions: 10,
              label: (_sliderVal * 100).round().toString(),
              onChanged: (v) => setState(() => _sliderVal = v),
            ),
          ]),

          _Section('Wavy Progress', [
            WavyLinearProgressIndicator(
              value: _sliderVal,
              color: scheme.primary,
            ),
            const SizedBox(height: 12),
            WavyLinearProgressIndicator(color: scheme.secondary),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WavyCircularProgressIndicator(value: _sliderVal),
                WavyCircularProgressIndicator(color: scheme.secondary),
                ContainedLoadingIndicator(size: 48, color: scheme.tertiary),
              ],
            ),
          ]),

          _Section('Switch', [
            SwitchListTile(
              title: const Text('Expressive Switch'),
              subtitle: const Text('Colored track, icon thumb'),
              value: _switchOn,
              onChanged: (v) => setState(() => _switchOn = v),
            ),
          ]),

          _Section('Checkbox', [
            CheckboxListTile(
              title: const Text('Rounded checkbox'),
              value: _checkA,
              onChanged: (v) => setState(() => _checkA = v ?? false),
            ),
            CheckboxListTile(
              title: const Text('Unchecked state'),
              value: _checkB,
              onChanged: (v) => setState(() => _checkB = v ?? false),
            ),
          ]),

          _Section('Radio', [
            RadioGroup<int>(
              groupValue: _radio,
              onChanged: (v) => setState(() => _radio = v ?? 0),
              child: Column(
                children: ['Option A', 'Option B', 'Option C']
                    .asMap()
                    .entries
                    .map(
                      (e) => RadioListTile<int>(
                        title: Text(e.value),
                        value: e.key,
                      ),
                    )
                    .toList(),
              ),
            ),
          ]),

          const _Section('Text Fields', [
            TextField(
              decoration: InputDecoration(
                labelText: 'Filled field',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: 'With suffix',
                suffixIcon: Icon(Icons.visibility),
              ),
            ),
          ]),

          _Section('Date & Time Pickers', [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _date == null
                          ? 'Pick Date'
                          : '${_date!.day}/${_date!.month}/${_date!.year}',
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _time == null ? 'Pick Time' : _time!.format(context),
                    ),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => _time = picked);
                    },
                  ),
                ),
              ],
            ),
          ]),

          _Section('Dialogs & Sheets', [
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => showExpressiveDialog(
                    context: context,
                    builder: (_) => ExpressiveAlertDialog(
                      icon: const Icon(Icons.delete_outline),
                      title: const Text('Delete item?'),
                      content: const Text('This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Dialog'),
                ),
                OutlinedButton(
                  onPressed: () => showExpressiveBottomSheet(
                    context: context,
                    snap: true,
                    snapSizes: const [0.3, 0.6],
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bottom Sheet',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          const Text('Spring-based drag with snap points.'),
                        ],
                      ),
                    ),
                  ),
                  child: const Text('Bottom Sheet'),
                ),
                OutlinedButton(
                  onPressed: () => showExpressiveSnackBar(
                    context,
                    message: 'Changes saved',
                    icon: Icons.check_circle,
                    actionLabel: 'Undo',
                    onAction: () {},
                  ),
                  child: const Text('Snackbar'),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.children);
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}
