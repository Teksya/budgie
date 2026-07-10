import 'dart:async';
import 'dart:io';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/receipt_scanner.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/numeric_keypad.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Opens the editor for an existing transaction.
Future<void> openTransactionEditor(BuildContext context, Txn txn) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddTransactionPage(existing: txn),
      ),
    );

/// Full-screen form to add or edit a transaction: expense, income or transfer.
class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({
    this.initialType = TxnType.expense,
    this.existing,
    super.key,
  });

  final TxnType initialType;
  final Txn? existing;

  @override
  ConsumerState<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  late TxnType _type = widget.existing?.type ?? widget.initialType;
  late final _amount = TextEditingController(
    text: widget.existing == null
        ? ''
        : (widget.existing!.amountCents / 100).toStringAsFixed(2),
  );
  late final _note = TextEditingController(text: widget.existing?.note ?? '');
  late int? _categoryId = widget.existing?.categoryId;
  late int? _accountId = widget.existing?.accountId;
  late int? _toAccountId = widget.existing?.toAccountId;
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  late bool _incomeReceived =
      widget.existing?.incomeStatus != IncomeStatus.planned;
  late bool _shared = widget.existing?.sharedTotalCents != null;
  late final _total = TextEditingController(
    text: widget.existing?.sharedTotalCents == null
        ? ''
        : (widget.existing!.sharedTotalCents! / 100).toStringAsFixed(2),
  );
  late String? _receiptPath = widget.existing?.receiptPath;
  bool _saving = false;
  bool _scanning = false;
  Timer? _guessDebounce;
  bool _categoryTouched = false;

  bool get _editing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _note.addListener(_onNoteChanged);
  }

  /// Debounced: guess the category from the note, but never override a choice
  /// the user made by hand.
  void _onNoteChanged() {
    _guessDebounce?.cancel();
    _guessDebounce = Timer(const Duration(milliseconds: 450), () async {
      if (_categoryTouched || _type != TxnType.expense) return;
      final guess = await ref
          .read(transactionRepositoryProvider)
          .guessCategory(_note.text);
      if (guess != null && !_categoryTouched && mounted) {
        setState(() => _categoryId = guess);
      }
    });
  }

  @override
  void dispose() {
    _guessDebounce?.cancel();
    _amount.dispose();
    _note.dispose();
    _total.dispose();
    super.dispose();
  }

  Future<String?> _pickAndStore(
    ImageSource source, {
    double? maxWidth = 1600,
    int quality = 70,
  }) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: maxWidth,
      imageQuality: quality,
    );
    if (picked == null) return null;
    // Copy into the app's documents dir so it survives the picker cache.
    final dir = await getApplicationDocumentsDirectory();
    final receipts = Directory('${dir.path}/receipts');
    if (!receipts.existsSync()) receipts.createSync(recursive: true);
    final name = 'r_${_date.millisecondsSinceEpoch}_${picked.name}';
    final dest = await File(picked.path).copy('${receipts.path}/$name');
    return dest.path;
  }

  Future<void> _pickReceipt(ImageSource source) async {
    try {
      final path = await _pickAndStore(source);
      if (path != null && mounted) setState(() => _receiptPath = path);
    } on Object catch (_) {
      // Ignore: attaching a receipt is optional.
    }
  }

  /// Photograph or pick a receipt, read it on-device, and pre-fill the amount
  /// and date for the user to confirm.
  Future<void> _scanReceipt(ImageSource source) async {
    setState(() => _scanning = true);
    final scanner = ReceiptScanner();
    try {
      // Full resolution + high quality: small receipt text needs the pixels.
      final path = await _pickAndStore(source, maxWidth: null, quality: 92);
      if (path == null) return;
      final scan = await scanner.scan(path);
      if (!mounted) return;
      setState(() {
        _receiptPath = path;
        if (scan.date != null) _date = scan.date!;
      });

      if (scan.amounts.isNotEmpty) {
        final chosen = await showDialog<Money>(
          context: context,
          builder: (_) => _ScanResultDialog(scan: scan),
        );
        if (chosen != null && mounted) {
          setState(
            () => _amount.text = (chosen.cents / 100).toStringAsFixed(2),
          );
        }
      } else if (mounted) {
        // Nothing parsed — show whatever text was read so it's not a black box.
        await showDialog<void>(
          context: context,
          builder: (_) => _ScanEmptyDialog(rawText: scan.rawText),
        );
      }
    } on Object catch (_) {
      // Best-effort; nothing is committed without the user.
    } finally {
      await scanner.dispose();
      if (mounted) setState(() => _scanning = false);
    }
  }

  Money? get _parsedAmount => _parse(_amount);

  Money? _parse(TextEditingController c) {
    final value = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return Money.fromEuros(value);
  }

  bool get _valid {
    if (_parsedAmount == null || _accountId == null) return false;
    if (_type == TxnType.transfer) {
      return _toAccountId != null && _toAccountId != _accountId;
    }
    return true;
  }

  Future<void> _save() async {
    final amount = _parsedAmount;
    final accountId = _accountId;
    if (!_valid || amount == null || accountId == null) return;
    setState(() => _saving = true);
    final repo = ref.read(transactionRepositoryProvider);
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();
    final incomeStatus = _type == TxnType.income
        ? (_incomeReceived ? IncomeStatus.received : IncomeStatus.planned)
        : null;
    final categoryId = _type == TxnType.transfer ? null : _categoryId;
    final toAccountId = _type == TxnType.transfer ? _toAccountId : null;
    final total = _parse(_total);
    final sharedTotal =
        (_type == TxnType.expense && _shared && total != null && total > amount)
        ? total.cents
        : null;

    if (_editing) {
      await repo.update(
        widget.existing!.copyWith(
          date: _date,
          type: _type,
          amountCents: amount.cents,
          sharedTotalCents: Value(sharedTotal),
          categoryId: Value(categoryId),
          accountId: accountId,
          toAccountId: Value(toAccountId),
          note: Value(note),
          receiptPath: Value(_receiptPath),
          incomeStatus: Value(incomeStatus),
        ),
      );
    } else {
      final period = await ref.read(openPeriodProvider.future);
      await repo.add(
        TransactionsCompanion.insert(
          date: _date,
          type: _type,
          amountCents: amount.cents,
          sharedTotalCents: Value(sharedTotal),
          categoryId: Value(categoryId),
          accountId: accountId,
          toAccountId: Value(toAccountId),
          periodId: period.id,
          note: Value(note),
          receiptPath: Value(_receiptPath),
          incomeStatus: Value(incomeStatus),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final accounts = ref.watch(accountsProvider).value ?? const [];

    if (_accountId == null && accounts.isNotEmpty) {
      _accountId = accounts.first.id;
    }
    if (_type == TxnType.transfer &&
        _toAccountId == null &&
        accounts.length > 1) {
      _toAccountId = accounts.firstWhere((a) => a.id != _accountId).id;
    }

    final kind = _type == TxnType.expense
        ? CategoryKind.expense
        : CategoryKind.income;
    final leaves =
        categories.where((c) => c.kind == kind && c.parentId != null).toList();
    final pickable = leaves.isNotEmpty
        ? leaves
        : categories.where((c) => c.kind == kind).toList();

    // Float the categories the user actually uses to the front.
    final usage = ref.watch(categoryUsageProvider).value ?? const {};
    if (_type == TxnType.expense && usage.isNotEmpty) {
      pickable.sort((a, b) => (usage[b.id] ?? 0).compareTo(usage[a.id] ?? 0));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editing
              ? L.of(context).edit
              : switch (_type) {
                  TxnType.expense => L.of(context).newExpense,
                  TxnType.income => L.of(context).newIncome,
                  TxnType.transfer => L.of(context).moveMoney,
                },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl * 2,
        ),
        children: [
          _TypeToggle(
            type: _type,
            onChanged: (t) => setState(() {
              _type = t;
              _categoryId = null;
            }),
          ),
          if (_type == TxnType.expense && !_editing) ...[
            const SizedBox(height: AppSpacing.lg),
            _ScanButton(
              scanning: _scanning,
              onCamera: () => _scanReceipt(ImageSource.camera),
              onGallery: () => _scanReceipt(ImageSource.gallery),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          // Big display, driven by the keypad below — no system keyboard.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _amount.text.isEmpty ? '0' : _amount.text,
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: _amount.text.isEmpty
                    ? theme.colorScheme.onSurfaceVariant
                    : null,
              ),
            ),
          ),
          Center(
            child: Text(
              '€',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NumericKeypad(
            value: _amount.text,
            onChanged: (v) => setState(() => _amount.text = v),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_type == TxnType.transfer) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: ShapeDecoration(
                shape: AppShapes.card,
                color: theme.colorScheme.surfaceContainerHigh,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      L.of(context).transferInfo,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _TransferAccounts(
              accounts: accounts,
              fromId: _accountId,
              toId: _toAccountId,
              onFrom: (v) => setState(() => _accountId = v),
              onTo: (v) => setState(() => _toAccountId = v),
            ),
          ] else ...[
            Text(L.of(context).category, style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final c in pickable)
                  ChoiceChip(
                    avatar: Icon(
                      iconFor(c.iconKey),
                      size: 18,
                      color: Color(c.colorValue),
                    ),
                    label: Text(c.name),
                    selected: _categoryId == c.id,
                    onSelected: (_) => setState(() {
                      _categoryId = c.id;
                      _categoryTouched = true;
                    }),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  date: _date,
                  onChanged: (d) => setState(() => _date = d),
                ),
              ),
              if (accounts.length > 1 && _type != TxnType.transfer) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: _accountId,
                    decoration: InputDecoration(labelText: L.of(context).account),
                    items: [
                      for (final a in accounts)
                        DropdownMenuItem(value: a.id, child: Text(a.name)),
                    ],
                    onChanged: (v) => setState(() => _accountId = v),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _note,
            decoration: InputDecoration(labelText: L.of(context).noteOptional),
          ),
          if (_type == TxnType.expense) ...[
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(L.of(context).sharedExpense),
              subtitle: Text(
                L.of(context).sharedHint,
                style: theme.textTheme.bodySmall,
              ),
              value: _shared,
              onChanged: (v) => setState(() => _shared = v),
            ),
            if (_shared)
              TextField(
                controller: _total,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: L.of(context).sharedTotal,
                  suffixText: '€',
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            _ReceiptField(
              path: _receiptPath,
              onPick: _pickReceipt,
              onRemove: () => setState(() => _receiptPath = null),
            ),
          ],
          if (_type == TxnType.income) ...[
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(L.of(context).alreadyReceived),
              subtitle: Text(
                _incomeReceived
                    ? L.of(context).addedToBalance
                    : L.of(context).plannedNotReceived,
                style: theme.textTheme.bodySmall,
              ),
              value: _incomeReceived,
              onChanged: (v) => setState(() => _incomeReceived = v),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: (_valid && !_saving) ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_editing ? L.of(context).actionSave : L.of(context).actionAdd),
          ),
        ],
      ),
    );
  }
}

/// Lets the user pick the real total from every amount the OCR found — much
/// more reliable than guessing a single one.
class _ScanResultDialog extends StatelessWidget {
  const _ScanResultDialog({required this.scan});

  final ReceiptScan scan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(L.of(context).whichAmount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            L.of(context).tapReceiptTotal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final amount in scan.amounts)
                ActionChip(
                  label: Text(amount.format()),
                  backgroundColor: amount == scan.guess
                      ? theme.colorScheme.primaryContainer
                      : null,
                  onPressed: () => Navigator.pop(context, amount),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(L.of(context).enterManually),
        ),
      ],
    );
  }
}

/// Shown when OCR read no amount, exposing the raw text so the problem is
/// visible instead of a silent failure.
class _ScanEmptyDialog extends StatelessWidget {
  const _ScanEmptyDialog({required this.rawText});

  final String rawText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasText = rawText.trim().isNotEmpty;
    return AlertDialog(
      title: Text(L.of(context).amountNotFound),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasText
                  ? L.of(context).receiptReadNoTotal
                  : L.of(context).cannotReadReceipt,
              style: theme.textTheme.bodyMedium,
            ),
            if (hasText) ...[
              const SizedBox(height: AppSpacing.md),
              Text(L.of(context).textRead, style: theme.textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  rawText,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

/// Prominent "scan a receipt" entry with a camera and a gallery choice.
class _ScanButton extends StatelessWidget {
  const _ScanButton({
    required this.scanning,
    required this.onCamera,
    required this.onGallery,
  });

  final bool scanning;
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: ShapeDecoration(
        shape: AppShapes.card,
        color: scheme.secondaryContainer,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.document_scanner_outlined, color: scheme.onSecondaryContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              scanning ? L.of(context).readingReceipt : L.of(context).scanReceipt,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: scheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (scanning)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            IconButton(
              onPressed: onCamera,
              icon: const Icon(Icons.photo_camera_outlined),
              tooltip: L.of(context).takePhoto,
            ),
            IconButton(
              onPressed: onGallery,
              icon: const Icon(Icons.photo_library_outlined),
              tooltip: L.of(context).fromGallery,
            ),
          ],
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final TxnType type;
  final ValueChanged<TxnType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TxnType>(
      segments: [
        ButtonSegment(
          value: TxnType.expense,
          icon: const Icon(Icons.south_west),
          label: Text(L.of(context).expense),
        ),
        ButtonSegment(
          value: TxnType.income,
          icon: const Icon(Icons.north_east),
          label: Text(L.of(context).income),
        ),
        ButtonSegment(
          value: TxnType.transfer,
          icon: const Icon(Icons.swap_horiz),
          label: Text(L.of(context).transferShort),
        ),
      ],
      selected: {type},
      onSelectionChanged: (s) => onChanged(s.first),
      showSelectedIcon: false,
    );
  }
}

class _TransferAccounts extends StatelessWidget {
  const _TransferAccounts({
    required this.accounts,
    required this.fromId,
    required this.toId,
    required this.onFrom,
    required this.onTo,
  });

  final List<Account> accounts;
  final int? fromId;
  final int? toId;
  final ValueChanged<int?> onFrom;
  final ValueChanged<int?> onTo;

  @override
  Widget build(BuildContext context) {
    if (accounts.length < 2) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            L.of(context).needSecondAccount,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: fromId,
            decoration: InputDecoration(labelText: L.of(context).from),
            items: [
              for (final a in accounts)
                DropdownMenuItem(value: a.id, child: Text(a.name)),
            ],
            onChanged: onFrom,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Icon(Icons.arrow_forward),
        ),
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: toId,
            decoration: InputDecoration(labelText: L.of(context).to),
            items: [
              for (final a in accounts)
                DropdownMenuItem(value: a.id, child: Text(a.name)),
            ],
            onChanged: onTo,
          ),
        ),
      ],
    );
  }
}

class _ReceiptField extends StatelessWidget {
  const _ReceiptField({
    required this.path,
    required this.onPick,
    required this.onRemove,
  });

  final String? path;
  final ValueChanged<ImageSource> onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (path != null) {
      return Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.file(
              File(path!),
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Expanded(child: Text('Ticket joint')),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            tooltip: 'Retirer',
          ),
        ],
      );
    }
    return Row(
      children: [
        Icon(Icons.receipt_long_outlined, color: scheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: Text('Photo du ticket')),
        IconButton(
          onPressed: () => onPick(ImageSource.camera),
          icon: const Icon(Icons.photo_camera_outlined),
          tooltip: 'Prendre une photo',
        ),
        IconButton(
          onPressed: () => onPick(ImageSource.gallery),
          icon: const Icon(Icons.photo_library_outlined),
          tooltip: 'Choisir dans la galerie',
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onChanged});

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: L.of(context).date),
        child: Text(DateFormat('d MMM y', 'fr_FR').format(date)),
      ),
    );
  }
}
