// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _initialBalanceCentsMeta =
      const VerificationMeta('initialBalanceCents');
  @override
  late final GeneratedColumn<int> initialBalanceCents = GeneratedColumn<int>(
    'initial_balance_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('wallet'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    initialBalanceCents,
    iconKey,
    colorValue,
    archived,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('initial_balance_cents')) {
      context.handle(
        _initialBalanceCentsMeta,
        initialBalanceCents.isAcceptableOrUnknown(
          data['initial_balance_cents']!,
          _initialBalanceCentsMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $AccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      initialBalanceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}initial_balance_cents'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final String name;
  final AccountType type;
  final int initialBalanceCents;
  final String iconKey;
  final int? colorValue;
  final bool archived;
  final int sortOrder;
  final DateTime createdAt;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.initialBalanceCents,
    required this.iconKey,
    this.colorValue,
    required this.archived,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['initial_balance_cents'] = Variable<int>(initialBalanceCents);
    map['icon_key'] = Variable<String>(iconKey);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['archived'] = Variable<bool>(archived);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialBalanceCents: Value(initialBalanceCents),
      iconKey: Value(iconKey),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      archived: Value(archived),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $AccountsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      initialBalanceCents: serializer.fromJson<int>(
        json['initialBalanceCents'],
      ),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      archived: serializer.fromJson<bool>(json['archived']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $AccountsTable.$convertertype.toJson(type),
      ),
      'initialBalanceCents': serializer.toJson<int>(initialBalanceCents),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int?>(colorValue),
      'archived': serializer.toJson<bool>(archived),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith({
    int? id,
    String? name,
    AccountType? type,
    int? initialBalanceCents,
    String? iconKey,
    Value<int?> colorValue = const Value.absent(),
    bool? archived,
    int? sortOrder,
    DateTime? createdAt,
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    archived: archived ?? this.archived,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialBalanceCents: data.initialBalanceCents.present
          ? data.initialBalanceCents.value
          : this.initialBalanceCents,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      archived: data.archived.present ? data.archived.value : this.archived,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalanceCents: $initialBalanceCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    initialBalanceCents,
    iconKey,
    colorValue,
    archived,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialBalanceCents == this.initialBalanceCents &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.archived == this.archived &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<int> initialBalanceCents;
  final Value<String> iconKey;
  final Value<int?> colorValue;
  final Value<bool> archived;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialBalanceCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountType type,
    this.initialBalanceCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.archived = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? initialBalanceCents,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<bool>? archived,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialBalanceCents != null)
        'initial_balance_cents': initialBalanceCents,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (archived != null) 'archived': archived,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<AccountType>? type,
    Value<int>? initialBalanceCents,
    Value<String>? iconKey,
    Value<int?>? colorValue,
    Value<bool>? archived,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalanceCents: initialBalanceCents ?? this.initialBalanceCents,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      archived: archived ?? this.archived,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $AccountsTable.$convertertype.toSql(type.value),
      );
    }
    if (initialBalanceCents.present) {
      map['initial_balance_cents'] = Variable<int>(initialBalanceCents.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalanceCents: $initialBalanceCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('archived: $archived, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CategoryKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CategoryKind>($CategoriesTable.$converterkind);
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tag'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    parentId,
    iconKey,
    colorValue,
    isSystem,
    sortOrder,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $CategoriesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CategoryKind, String, String> $converterkind =
      const EnumNameConverter<CategoryKind>(CategoryKind.values);
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final CategoryKind kind;

  /// One level of nesting only: a child never has children of its own.
  final int? parentId;
  final String iconKey;
  final int colorValue;

  /// System categories cannot be deleted (e.g. "Non catégorisé"), only renamed.
  final bool isSystem;
  final int sortOrder;
  final bool archived;
  const Category({
    required this.id,
    required this.name,
    required this.kind,
    this.parentId,
    required this.iconKey,
    required this.colorValue,
    required this.isSystem,
    required this.sortOrder,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['icon_key'] = Variable<String>(iconKey);
    map['color_value'] = Variable<int>(colorValue);
    map['is_system'] = Variable<bool>(isSystem);
    map['sort_order'] = Variable<int>(sortOrder);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      iconKey: Value(iconKey),
      colorValue: Value(colorValue),
      isSystem: Value(isSystem),
      sortOrder: Value(sortOrder),
      archived: Value(archived),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $CategoriesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      parentId: serializer.fromJson<int?>(json['parentId']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $CategoriesTable.$converterkind.toJson(kind),
      ),
      'parentId': serializer.toJson<int?>(parentId),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int>(colorValue),
      'isSystem': serializer.toJson<bool>(isSystem),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    CategoryKind? kind,
    Value<int?> parentId = const Value.absent(),
    String? iconKey,
    int? colorValue,
    bool? isSystem,
    int? sortOrder,
    bool? archived,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    parentId: parentId.present ? parentId.value : this.parentId,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue ?? this.colorValue,
    isSystem: isSystem ?? this.isSystem,
    sortOrder: sortOrder ?? this.sortOrder,
    archived: archived ?? this.archived,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    parentId,
    iconKey,
    colorValue,
    isSystem,
    sortOrder,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.parentId == this.parentId &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.isSystem == this.isSystem &&
          other.sortOrder == this.sortOrder &&
          other.archived == this.archived);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<CategoryKind> kind;
  final Value<int?> parentId;
  final Value<String> iconKey;
  final Value<int> colorValue;
  final Value<bool> isSystem;
  final Value<int> sortOrder;
  final Value<bool> archived;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.parentId = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required CategoryKind kind,
    this.parentId = const Value.absent(),
    this.iconKey = const Value.absent(),
    required int colorValue,
    this.isSystem = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       colorValue = Value(colorValue);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? parentId,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<bool>? isSystem,
    Expression<int>? sortOrder,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (parentId != null) 'parent_id': parentId,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (isSystem != null) 'is_system': isSystem,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archived != null) 'archived': archived,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<CategoryKind>? kind,
    Value<int?>? parentId,
    Value<String>? iconKey,
    Value<int>? colorValue,
    Value<bool>? isSystem,
    Value<int>? sortOrder,
    Value<bool>? archived,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      parentId: parentId ?? this.parentId,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      isSystem: isSystem ?? this.isSystem,
      sortOrder: sortOrder ?? this.sortOrder,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $CategoriesTable.$converterkind.toSql(kind.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('parentId: $parentId, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('isSystem: $isSystem, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingEntry extends DataClass implements Insertable<SettingEntry> {
  final String key;
  final String value;
  const SettingEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(key: Value(key), value: Value(value));
  }

  factory SettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingEntry copyWith({String? key, String? value}) =>
      SettingEntry(key: key ?? this.key, value: value ?? this.value);
  SettingEntry copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeriodsTable extends Periods with TableInfo<$PeriodsTable, Period> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PeriodStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PeriodStatus>($PeriodsTable.$converterstatus);
  static const VerificationMeta _carryOverInCentsMeta = const VerificationMeta(
    'carryOverInCents',
  );
  @override
  late final GeneratedColumn<int> carryOverInCents = GeneratedColumn<int>(
    'carry_over_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carryOverManualCentsMeta =
      const VerificationMeta('carryOverManualCents');
  @override
  late final GeneratedColumn<int> carryOverManualCents = GeneratedColumn<int>(
    'carry_over_manual_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<DateTime> closedAt = GeneratedColumn<DateTime>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    status,
    carryOverInCents,
    carryOverManualCents,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Period> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('carry_over_in_cents')) {
      context.handle(
        _carryOverInCentsMeta,
        carryOverInCents.isAcceptableOrUnknown(
          data['carry_over_in_cents']!,
          _carryOverInCentsMeta,
        ),
      );
    }
    if (data.containsKey('carry_over_manual_cents')) {
      context.handle(
        _carryOverManualCentsMeta,
        carryOverManualCents.isAcceptableOrUnknown(
          data['carry_over_manual_cents']!,
          _carryOverManualCentsMeta,
        ),
      );
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {startDate},
  ];
  @override
  Period map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Period(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      status: $PeriodsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      carryOverInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carry_over_in_cents'],
      )!,
      carryOverManualCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carry_over_manual_cents'],
      ),
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}closed_at'],
      ),
    );
  }

  @override
  $PeriodsTable createAlias(String alias) {
    return $PeriodsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PeriodStatus, String, String> $converterstatus =
      const EnumNameConverter<PeriodStatus>(PeriodStatus.values);
}

class Period extends DataClass implements Insertable<Period> {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final PeriodStatus status;

  /// Computed leftover from the previous period, positive or negative.
  final int carryOverInCents;

  /// When set, overrides [carryOverInCents] and stops the recompute cascade —
  /// this is how a mis-typed amount in an old month gets corrected without
  /// rewriting history.
  final int? carryOverManualCents;
  final DateTime? closedAt;
  const Period({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.carryOverInCents,
    this.carryOverManualCents,
    this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    {
      map['status'] = Variable<String>(
        $PeriodsTable.$converterstatus.toSql(status),
      );
    }
    map['carry_over_in_cents'] = Variable<int>(carryOverInCents);
    if (!nullToAbsent || carryOverManualCents != null) {
      map['carry_over_manual_cents'] = Variable<int>(carryOverManualCents);
    }
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<DateTime>(closedAt);
    }
    return map;
  }

  PeriodsCompanion toCompanion(bool nullToAbsent) {
    return PeriodsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: Value(endDate),
      status: Value(status),
      carryOverInCents: Value(carryOverInCents),
      carryOverManualCents: carryOverManualCents == null && nullToAbsent
          ? const Value.absent()
          : Value(carryOverManualCents),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory Period.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Period(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      status: $PeriodsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      carryOverInCents: serializer.fromJson<int>(json['carryOverInCents']),
      carryOverManualCents: serializer.fromJson<int?>(
        json['carryOverManualCents'],
      ),
      closedAt: serializer.fromJson<DateTime?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'status': serializer.toJson<String>(
        $PeriodsTable.$converterstatus.toJson(status),
      ),
      'carryOverInCents': serializer.toJson<int>(carryOverInCents),
      'carryOverManualCents': serializer.toJson<int?>(carryOverManualCents),
      'closedAt': serializer.toJson<DateTime?>(closedAt),
    };
  }

  Period copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    PeriodStatus? status,
    int? carryOverInCents,
    Value<int?> carryOverManualCents = const Value.absent(),
    Value<DateTime?> closedAt = const Value.absent(),
  }) => Period(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    status: status ?? this.status,
    carryOverInCents: carryOverInCents ?? this.carryOverInCents,
    carryOverManualCents: carryOverManualCents.present
        ? carryOverManualCents.value
        : this.carryOverManualCents,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
  );
  Period copyWithCompanion(PeriodsCompanion data) {
    return Period(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      status: data.status.present ? data.status.value : this.status,
      carryOverInCents: data.carryOverInCents.present
          ? data.carryOverInCents.value
          : this.carryOverInCents,
      carryOverManualCents: data.carryOverManualCents.present
          ? data.carryOverManualCents.value
          : this.carryOverManualCents,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Period(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('carryOverInCents: $carryOverInCents, ')
          ..write('carryOverManualCents: $carryOverManualCents, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    status,
    carryOverInCents,
    carryOverManualCents,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Period &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.status == this.status &&
          other.carryOverInCents == this.carryOverInCents &&
          other.carryOverManualCents == this.carryOverManualCents &&
          other.closedAt == this.closedAt);
}

class PeriodsCompanion extends UpdateCompanion<Period> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<PeriodStatus> status;
  final Value<int> carryOverInCents;
  final Value<int?> carryOverManualCents;
  final Value<DateTime?> closedAt;
  const PeriodsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.status = const Value.absent(),
    this.carryOverInCents = const Value.absent(),
    this.carryOverManualCents = const Value.absent(),
    this.closedAt = const Value.absent(),
  });
  PeriodsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    required PeriodStatus status,
    this.carryOverInCents = const Value.absent(),
    this.carryOverManualCents = const Value.absent(),
    this.closedAt = const Value.absent(),
  }) : startDate = Value(startDate),
       endDate = Value(endDate),
       status = Value(status);
  static Insertable<Period> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? status,
    Expression<int>? carryOverInCents,
    Expression<int>? carryOverManualCents,
    Expression<DateTime>? closedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (status != null) 'status': status,
      if (carryOverInCents != null) 'carry_over_in_cents': carryOverInCents,
      if (carryOverManualCents != null)
        'carry_over_manual_cents': carryOverManualCents,
      if (closedAt != null) 'closed_at': closedAt,
    });
  }

  PeriodsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<PeriodStatus>? status,
    Value<int>? carryOverInCents,
    Value<int?>? carryOverManualCents,
    Value<DateTime?>? closedAt,
  }) {
    return PeriodsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      carryOverInCents: carryOverInCents ?? this.carryOverInCents,
      carryOverManualCents: carryOverManualCents ?? this.carryOverManualCents,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PeriodsTable.$converterstatus.toSql(status.value),
      );
    }
    if (carryOverInCents.present) {
      map['carry_over_in_cents'] = Variable<int>(carryOverInCents.value);
    }
    if (carryOverManualCents.present) {
      map['carry_over_manual_cents'] = Variable<int>(
        carryOverManualCents.value,
      );
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<DateTime>(closedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('status: $status, ')
          ..write('carryOverInCents: $carryOverInCents, ')
          ..write('carryOverManualCents: $carryOverManualCents, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Txn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxnType>($TransactionsTable.$convertertype);
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sharedTotalCentsMeta = const VerificationMeta(
    'sharedTotalCents',
  );
  @override
  late final GeneratedColumn<int> sharedTotalCents = GeneratedColumn<int>(
    'shared_total_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _toAccountIdMeta = const VerificationMeta(
    'toAccountId',
  );
  @override
  late final GeneratedColumn<int> toAccountId = GeneratedColumn<int>(
    'to_account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IncomeStatus?, String>
  incomeStatus = GeneratedColumn<String>(
    'income_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<IncomeStatus?>($TransactionsTable.$converterincomeStatusn);
  static const VerificationMeta _recurrenceIdMeta = const VerificationMeta(
    'recurrenceId',
  );
  @override
  late final GeneratedColumn<int> recurrenceId = GeneratedColumn<int>(
    'recurrence_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    type,
    amountCents,
    sharedTotalCents,
    categoryId,
    accountId,
    toAccountId,
    periodId,
    note,
    receiptPath,
    incomeStatus,
    recurrenceId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Txn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('shared_total_cents')) {
      context.handle(
        _sharedTotalCentsMeta,
        sharedTotalCents.isAcceptableOrUnknown(
          data['shared_total_cents']!,
          _sharedTotalCentsMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
        _toAccountIdMeta,
        toAccountId.isAcceptableOrUnknown(
          data['to_account_id']!,
          _toAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_id')) {
      context.handle(
        _recurrenceIdMeta,
        recurrenceId.isAcceptableOrUnknown(
          data['recurrence_id']!,
          _recurrenceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Txn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Txn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: $TransactionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      sharedTotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shared_total_cents'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      toAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_account_id'],
      ),
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      incomeStatus: $TransactionsTable.$converterincomeStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}income_status'],
        ),
      ),
      recurrenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrence_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnType, String, String> $convertertype =
      const EnumNameConverter<TxnType>(TxnType.values);
  static JsonTypeConverter2<IncomeStatus, String, String>
  $converterincomeStatus = const EnumNameConverter<IncomeStatus>(
    IncomeStatus.values,
  );
  static JsonTypeConverter2<IncomeStatus?, String?, String?>
  $converterincomeStatusn = JsonTypeConverter2.asNullable(
    $converterincomeStatus,
  );
}

class Txn extends DataClass implements Insertable<Txn> {
  final int id;
  final DateTime date;
  final TxnType type;

  /// Always the amount actually borne by the user. For a shared expense this
  /// is *my share*, not the bill total.
  final int amountCents;

  /// The full bill when the expense was split; informational only.
  final int? sharedTotalCents;
  final int? categoryId;
  final int accountId;

  /// Destination account, transfers only.
  final int? toAccountId;
  final int periodId;
  final String? note;
  final String? receiptPath;

  /// Incomes only: planned vs actually received.
  final IncomeStatus? incomeStatus;

  /// The recurrence that generated this transaction, if any. Used to avoid
  /// materialising a recurring salary twice in the same period. Added in v2.
  final int? recurrenceId;
  final DateTime createdAt;
  const Txn({
    required this.id,
    required this.date,
    required this.type,
    required this.amountCents,
    this.sharedTotalCents,
    this.categoryId,
    required this.accountId,
    this.toAccountId,
    required this.periodId,
    this.note,
    this.receiptPath,
    this.incomeStatus,
    this.recurrenceId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type),
      );
    }
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || sharedTotalCents != null) {
      map['shared_total_cents'] = Variable<int>(sharedTotalCents);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['account_id'] = Variable<int>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<int>(toAccountId);
    }
    map['period_id'] = Variable<int>(periodId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || incomeStatus != null) {
      map['income_status'] = Variable<String>(
        $TransactionsTable.$converterincomeStatusn.toSql(incomeStatus),
      );
    }
    if (!nullToAbsent || recurrenceId != null) {
      map['recurrence_id'] = Variable<int>(recurrenceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      amountCents: Value(amountCents),
      sharedTotalCents: sharedTotalCents == null && nullToAbsent
          ? const Value.absent()
          : Value(sharedTotalCents),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      periodId: Value(periodId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      incomeStatus: incomeStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(incomeStatus),
      recurrenceId: recurrenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceId),
      createdAt: Value(createdAt),
    );
  }

  factory Txn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Txn(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: $TransactionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      sharedTotalCents: serializer.fromJson<int?>(json['sharedTotalCents']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      toAccountId: serializer.fromJson<int?>(json['toAccountId']),
      periodId: serializer.fromJson<int>(json['periodId']),
      note: serializer.fromJson<String?>(json['note']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      incomeStatus: $TransactionsTable.$converterincomeStatusn.fromJson(
        serializer.fromJson<String?>(json['incomeStatus']),
      ),
      recurrenceId: serializer.fromJson<int?>(json['recurrenceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(
        $TransactionsTable.$convertertype.toJson(type),
      ),
      'amountCents': serializer.toJson<int>(amountCents),
      'sharedTotalCents': serializer.toJson<int?>(sharedTotalCents),
      'categoryId': serializer.toJson<int?>(categoryId),
      'accountId': serializer.toJson<int>(accountId),
      'toAccountId': serializer.toJson<int?>(toAccountId),
      'periodId': serializer.toJson<int>(periodId),
      'note': serializer.toJson<String?>(note),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'incomeStatus': serializer.toJson<String?>(
        $TransactionsTable.$converterincomeStatusn.toJson(incomeStatus),
      ),
      'recurrenceId': serializer.toJson<int?>(recurrenceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Txn copyWith({
    int? id,
    DateTime? date,
    TxnType? type,
    int? amountCents,
    Value<int?> sharedTotalCents = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    int? accountId,
    Value<int?> toAccountId = const Value.absent(),
    int? periodId,
    Value<String?> note = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
    Value<IncomeStatus?> incomeStatus = const Value.absent(),
    Value<int?> recurrenceId = const Value.absent(),
    DateTime? createdAt,
  }) => Txn(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    amountCents: amountCents ?? this.amountCents,
    sharedTotalCents: sharedTotalCents.present
        ? sharedTotalCents.value
        : this.sharedTotalCents,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId ?? this.accountId,
    toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
    periodId: periodId ?? this.periodId,
    note: note.present ? note.value : this.note,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    incomeStatus: incomeStatus.present ? incomeStatus.value : this.incomeStatus,
    recurrenceId: recurrenceId.present ? recurrenceId.value : this.recurrenceId,
    createdAt: createdAt ?? this.createdAt,
  );
  Txn copyWithCompanion(TransactionsCompanion data) {
    return Txn(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      sharedTotalCents: data.sharedTotalCents.present
          ? data.sharedTotalCents.value
          : this.sharedTotalCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId: data.toAccountId.present
          ? data.toAccountId.value
          : this.toAccountId,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      note: data.note.present ? data.note.value : this.note,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      incomeStatus: data.incomeStatus.present
          ? data.incomeStatus.value
          : this.incomeStatus,
      recurrenceId: data.recurrenceId.present
          ? data.recurrenceId.value
          : this.recurrenceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Txn(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('sharedTotalCents: $sharedTotalCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('periodId: $periodId, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('incomeStatus: $incomeStatus, ')
          ..write('recurrenceId: $recurrenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    type,
    amountCents,
    sharedTotalCents,
    categoryId,
    accountId,
    toAccountId,
    periodId,
    note,
    receiptPath,
    incomeStatus,
    recurrenceId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Txn &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.amountCents == this.amountCents &&
          other.sharedTotalCents == this.sharedTotalCents &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.periodId == this.periodId &&
          other.note == this.note &&
          other.receiptPath == this.receiptPath &&
          other.incomeStatus == this.incomeStatus &&
          other.recurrenceId == this.recurrenceId &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Txn> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<TxnType> type;
  final Value<int> amountCents;
  final Value<int?> sharedTotalCents;
  final Value<int?> categoryId;
  final Value<int> accountId;
  final Value<int?> toAccountId;
  final Value<int> periodId;
  final Value<String?> note;
  final Value<String?> receiptPath;
  final Value<IncomeStatus?> incomeStatus;
  final Value<int?> recurrenceId;
  final Value<DateTime> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.sharedTotalCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.periodId = const Value.absent(),
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.incomeStatus = const Value.absent(),
    this.recurrenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required TxnType type,
    required int amountCents,
    this.sharedTotalCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int accountId,
    this.toAccountId = const Value.absent(),
    required int periodId,
    this.note = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.incomeStatus = const Value.absent(),
    this.recurrenceId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : date = Value(date),
       type = Value(type),
       amountCents = Value(amountCents),
       accountId = Value(accountId),
       periodId = Value(periodId);
  static Insertable<Txn> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<int>? amountCents,
    Expression<int>? sharedTotalCents,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<int>? toAccountId,
    Expression<int>? periodId,
    Expression<String>? note,
    Expression<String>? receiptPath,
    Expression<String>? incomeStatus,
    Expression<int>? recurrenceId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (amountCents != null) 'amount_cents': amountCents,
      if (sharedTotalCents != null) 'shared_total_cents': sharedTotalCents,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (periodId != null) 'period_id': periodId,
      if (note != null) 'note': note,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (incomeStatus != null) 'income_status': incomeStatus,
      if (recurrenceId != null) 'recurrence_id': recurrenceId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<TxnType>? type,
    Value<int>? amountCents,
    Value<int?>? sharedTotalCents,
    Value<int?>? categoryId,
    Value<int>? accountId,
    Value<int?>? toAccountId,
    Value<int>? periodId,
    Value<String?>? note,
    Value<String?>? receiptPath,
    Value<IncomeStatus?>? incomeStatus,
    Value<int?>? recurrenceId,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      amountCents: amountCents ?? this.amountCents,
      sharedTotalCents: sharedTotalCents ?? this.sharedTotalCents,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      periodId: periodId ?? this.periodId,
      note: note ?? this.note,
      receiptPath: receiptPath ?? this.receiptPath,
      incomeStatus: incomeStatus ?? this.incomeStatus,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $TransactionsTable.$convertertype.toSql(type.value),
      );
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (sharedTotalCents.present) {
      map['shared_total_cents'] = Variable<int>(sharedTotalCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<int>(toAccountId.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (incomeStatus.present) {
      map['income_status'] = Variable<String>(
        $TransactionsTable.$converterincomeStatusn.toSql(incomeStatus.value),
      );
    }
    if (recurrenceId.present) {
      map['recurrence_id'] = Variable<int>(recurrenceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('amountCents: $amountCents, ')
          ..write('sharedTotalCents: $sharedTotalCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('periodId: $periodId, ')
          ..write('note: $note, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('incomeStatus: $incomeStatus, ')
          ..write('recurrenceId: $recurrenceId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DebtsTable extends Debts with TableInfo<$DebtsTable, Debt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DebtKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DebtKind>($DebtsTable.$converterkind);
  static const VerificationMeta _principalCentsMeta = const VerificationMeta(
    'principalCents',
  );
  @override
  late final GeneratedColumn<int> principalCents = GeneratedColumn<int>(
    'principal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingCentsMeta = const VerificationMeta(
    'remainingCents',
  );
  @override
  late final GeneratedColumn<int> remainingCents = GeneratedColumn<int>(
    'remaining_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentCentsMeta = const VerificationMeta(
    'installmentCents',
  );
  @override
  late final GeneratedColumn<int> installmentCents = GeneratedColumn<int>(
    'installment_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _installmentsTotalMeta = const VerificationMeta(
    'installmentsTotal',
  );
  @override
  late final GeneratedColumn<int> installmentsTotal = GeneratedColumn<int>(
    'installments_total',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installmentsPaidMeta = const VerificationMeta(
    'installmentsPaid',
  );
  @override
  late final GeneratedColumn<int> installmentsPaid = GeneratedColumn<int>(
    'installments_paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _annualRateBpsMeta = const VerificationMeta(
    'annualRateBps',
  );
  @override
  late final GeneratedColumn<int> annualRateBps = GeneratedColumn<int>(
    'annual_rate_bps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _settledMeta = const VerificationMeta(
    'settled',
  );
  @override
  late final GeneratedColumn<bool> settled = GeneratedColumn<bool>(
    'settled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("settled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    principalCents,
    remainingCents,
    installmentCents,
    installmentsTotal,
    installmentsPaid,
    annualRateBps,
    startDate,
    endDate,
    settled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Debt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('principal_cents')) {
      context.handle(
        _principalCentsMeta,
        principalCents.isAcceptableOrUnknown(
          data['principal_cents']!,
          _principalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalCentsMeta);
    }
    if (data.containsKey('remaining_cents')) {
      context.handle(
        _remainingCentsMeta,
        remainingCents.isAcceptableOrUnknown(
          data['remaining_cents']!,
          _remainingCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingCentsMeta);
    }
    if (data.containsKey('installment_cents')) {
      context.handle(
        _installmentCentsMeta,
        installmentCents.isAcceptableOrUnknown(
          data['installment_cents']!,
          _installmentCentsMeta,
        ),
      );
    }
    if (data.containsKey('installments_total')) {
      context.handle(
        _installmentsTotalMeta,
        installmentsTotal.isAcceptableOrUnknown(
          data['installments_total']!,
          _installmentsTotalMeta,
        ),
      );
    }
    if (data.containsKey('installments_paid')) {
      context.handle(
        _installmentsPaidMeta,
        installmentsPaid.isAcceptableOrUnknown(
          data['installments_paid']!,
          _installmentsPaidMeta,
        ),
      );
    }
    if (data.containsKey('annual_rate_bps')) {
      context.handle(
        _annualRateBpsMeta,
        annualRateBps.isAcceptableOrUnknown(
          data['annual_rate_bps']!,
          _annualRateBpsMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('settled')) {
      context.handle(
        _settledMeta,
        settled.isAcceptableOrUnknown(data['settled']!, _settledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $DebtsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      principalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_cents'],
      )!,
      remainingCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_cents'],
      )!,
      installmentCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_cents'],
      )!,
      installmentsTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installments_total'],
      ),
      installmentsPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installments_paid'],
      )!,
      annualRateBps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}annual_rate_bps'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      settled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}settled'],
      )!,
    );
  }

  @override
  $DebtsTable createAlias(String alias) {
    return $DebtsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DebtKind, String, String> $converterkind =
      const EnumNameConverter<DebtKind>(DebtKind.values);
}

class Debt extends DataClass implements Insertable<Debt> {
  final int id;
  final String name;
  final DebtKind kind;
  final int principalCents;
  final int remainingCents;
  final int installmentCents;
  final int? installmentsTotal;
  final int installmentsPaid;

  /// Annual rate in basis points (3.75 % → 375). Integer, like every other
  /// number that must not drift.
  final int annualRateBps;
  final DateTime startDate;
  final DateTime? endDate;
  final bool settled;
  const Debt({
    required this.id,
    required this.name,
    required this.kind,
    required this.principalCents,
    required this.remainingCents,
    required this.installmentCents,
    this.installmentsTotal,
    required this.installmentsPaid,
    required this.annualRateBps,
    required this.startDate,
    this.endDate,
    required this.settled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($DebtsTable.$converterkind.toSql(kind));
    }
    map['principal_cents'] = Variable<int>(principalCents);
    map['remaining_cents'] = Variable<int>(remainingCents);
    map['installment_cents'] = Variable<int>(installmentCents);
    if (!nullToAbsent || installmentsTotal != null) {
      map['installments_total'] = Variable<int>(installmentsTotal);
    }
    map['installments_paid'] = Variable<int>(installmentsPaid);
    map['annual_rate_bps'] = Variable<int>(annualRateBps);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['settled'] = Variable<bool>(settled);
    return map;
  }

  DebtsCompanion toCompanion(bool nullToAbsent) {
    return DebtsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      principalCents: Value(principalCents),
      remainingCents: Value(remainingCents),
      installmentCents: Value(installmentCents),
      installmentsTotal: installmentsTotal == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentsTotal),
      installmentsPaid: Value(installmentsPaid),
      annualRateBps: Value(annualRateBps),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      settled: Value(settled),
    );
  }

  factory Debt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debt(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $DebtsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      principalCents: serializer.fromJson<int>(json['principalCents']),
      remainingCents: serializer.fromJson<int>(json['remainingCents']),
      installmentCents: serializer.fromJson<int>(json['installmentCents']),
      installmentsTotal: serializer.fromJson<int?>(json['installmentsTotal']),
      installmentsPaid: serializer.fromJson<int>(json['installmentsPaid']),
      annualRateBps: serializer.fromJson<int>(json['annualRateBps']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      settled: serializer.fromJson<bool>(json['settled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $DebtsTable.$converterkind.toJson(kind),
      ),
      'principalCents': serializer.toJson<int>(principalCents),
      'remainingCents': serializer.toJson<int>(remainingCents),
      'installmentCents': serializer.toJson<int>(installmentCents),
      'installmentsTotal': serializer.toJson<int?>(installmentsTotal),
      'installmentsPaid': serializer.toJson<int>(installmentsPaid),
      'annualRateBps': serializer.toJson<int>(annualRateBps),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'settled': serializer.toJson<bool>(settled),
    };
  }

  Debt copyWith({
    int? id,
    String? name,
    DebtKind? kind,
    int? principalCents,
    int? remainingCents,
    int? installmentCents,
    Value<int?> installmentsTotal = const Value.absent(),
    int? installmentsPaid,
    int? annualRateBps,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? settled,
  }) => Debt(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    principalCents: principalCents ?? this.principalCents,
    remainingCents: remainingCents ?? this.remainingCents,
    installmentCents: installmentCents ?? this.installmentCents,
    installmentsTotal: installmentsTotal.present
        ? installmentsTotal.value
        : this.installmentsTotal,
    installmentsPaid: installmentsPaid ?? this.installmentsPaid,
    annualRateBps: annualRateBps ?? this.annualRateBps,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    settled: settled ?? this.settled,
  );
  Debt copyWithCompanion(DebtsCompanion data) {
    return Debt(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      principalCents: data.principalCents.present
          ? data.principalCents.value
          : this.principalCents,
      remainingCents: data.remainingCents.present
          ? data.remainingCents.value
          : this.remainingCents,
      installmentCents: data.installmentCents.present
          ? data.installmentCents.value
          : this.installmentCents,
      installmentsTotal: data.installmentsTotal.present
          ? data.installmentsTotal.value
          : this.installmentsTotal,
      installmentsPaid: data.installmentsPaid.present
          ? data.installmentsPaid.value
          : this.installmentsPaid,
      annualRateBps: data.annualRateBps.present
          ? data.annualRateBps.value
          : this.annualRateBps,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      settled: data.settled.present ? data.settled.value : this.settled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debt(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('principalCents: $principalCents, ')
          ..write('remainingCents: $remainingCents, ')
          ..write('installmentCents: $installmentCents, ')
          ..write('installmentsTotal: $installmentsTotal, ')
          ..write('installmentsPaid: $installmentsPaid, ')
          ..write('annualRateBps: $annualRateBps, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('settled: $settled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    kind,
    principalCents,
    remainingCents,
    installmentCents,
    installmentsTotal,
    installmentsPaid,
    annualRateBps,
    startDate,
    endDate,
    settled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debt &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.principalCents == this.principalCents &&
          other.remainingCents == this.remainingCents &&
          other.installmentCents == this.installmentCents &&
          other.installmentsTotal == this.installmentsTotal &&
          other.installmentsPaid == this.installmentsPaid &&
          other.annualRateBps == this.annualRateBps &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.settled == this.settled);
}

class DebtsCompanion extends UpdateCompanion<Debt> {
  final Value<int> id;
  final Value<String> name;
  final Value<DebtKind> kind;
  final Value<int> principalCents;
  final Value<int> remainingCents;
  final Value<int> installmentCents;
  final Value<int?> installmentsTotal;
  final Value<int> installmentsPaid;
  final Value<int> annualRateBps;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> settled;
  const DebtsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.principalCents = const Value.absent(),
    this.remainingCents = const Value.absent(),
    this.installmentCents = const Value.absent(),
    this.installmentsTotal = const Value.absent(),
    this.installmentsPaid = const Value.absent(),
    this.annualRateBps = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.settled = const Value.absent(),
  });
  DebtsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DebtKind kind,
    required int principalCents,
    required int remainingCents,
    this.installmentCents = const Value.absent(),
    this.installmentsTotal = const Value.absent(),
    this.installmentsPaid = const Value.absent(),
    this.annualRateBps = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.settled = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind),
       principalCents = Value(principalCents),
       remainingCents = Value(remainingCents),
       startDate = Value(startDate);
  static Insertable<Debt> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<int>? principalCents,
    Expression<int>? remainingCents,
    Expression<int>? installmentCents,
    Expression<int>? installmentsTotal,
    Expression<int>? installmentsPaid,
    Expression<int>? annualRateBps,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? settled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (principalCents != null) 'principal_cents': principalCents,
      if (remainingCents != null) 'remaining_cents': remainingCents,
      if (installmentCents != null) 'installment_cents': installmentCents,
      if (installmentsTotal != null) 'installments_total': installmentsTotal,
      if (installmentsPaid != null) 'installments_paid': installmentsPaid,
      if (annualRateBps != null) 'annual_rate_bps': annualRateBps,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (settled != null) 'settled': settled,
    });
  }

  DebtsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DebtKind>? kind,
    Value<int>? principalCents,
    Value<int>? remainingCents,
    Value<int>? installmentCents,
    Value<int?>? installmentsTotal,
    Value<int>? installmentsPaid,
    Value<int>? annualRateBps,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? settled,
  }) {
    return DebtsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      principalCents: principalCents ?? this.principalCents,
      remainingCents: remainingCents ?? this.remainingCents,
      installmentCents: installmentCents ?? this.installmentCents,
      installmentsTotal: installmentsTotal ?? this.installmentsTotal,
      installmentsPaid: installmentsPaid ?? this.installmentsPaid,
      annualRateBps: annualRateBps ?? this.annualRateBps,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      settled: settled ?? this.settled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $DebtsTable.$converterkind.toSql(kind.value),
      );
    }
    if (principalCents.present) {
      map['principal_cents'] = Variable<int>(principalCents.value);
    }
    if (remainingCents.present) {
      map['remaining_cents'] = Variable<int>(remainingCents.value);
    }
    if (installmentCents.present) {
      map['installment_cents'] = Variable<int>(installmentCents.value);
    }
    if (installmentsTotal.present) {
      map['installments_total'] = Variable<int>(installmentsTotal.value);
    }
    if (installmentsPaid.present) {
      map['installments_paid'] = Variable<int>(installmentsPaid.value);
    }
    if (annualRateBps.present) {
      map['annual_rate_bps'] = Variable<int>(annualRateBps.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (settled.present) {
      map['settled'] = Variable<bool>(settled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('principalCents: $principalCents, ')
          ..write('remainingCents: $remainingCents, ')
          ..write('installmentCents: $installmentCents, ')
          ..write('installmentsTotal: $installmentsTotal, ')
          ..write('installmentsPaid: $installmentsPaid, ')
          ..write('annualRateBps: $annualRateBps, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('settled: $settled')
          ..write(')'))
        .toString();
  }
}

class $RecurrencesTable extends Recurrences
    with TableInfo<$RecurrencesTable, Recurrence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TxnType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TxnType>($RecurrencesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<RecurrenceNature, String> nature =
      GeneratedColumn<String>(
        'nature',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RecurrenceNature>($RecurrencesTable.$converternature);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _estimatedAmountCentsMeta =
      const VerificationMeta('estimatedAmountCents');
  @override
  late final GeneratedColumn<int> estimatedAmountCents = GeneratedColumn<int>(
    'estimated_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isVariableMeta = const VerificationMeta(
    'isVariable',
  );
  @override
  late final GeneratedColumn<bool> isVariable = GeneratedColumn<bool>(
    'is_variable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_variable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Frequency>($RecurrencesTable.$converterfrequency);
  static const VerificationMeta _dueDayOfMonthMeta = const VerificationMeta(
    'dueDayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dueDayOfMonth = GeneratedColumn<int>(
    'due_day_of_month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
    'debt_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES debts (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    nature,
    categoryId,
    accountId,
    estimatedAmountCents,
    isVariable,
    frequency,
    dueDayOfMonth,
    startDate,
    endDate,
    active,
    debtId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recurrence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('estimated_amount_cents')) {
      context.handle(
        _estimatedAmountCentsMeta,
        estimatedAmountCents.isAcceptableOrUnknown(
          data['estimated_amount_cents']!,
          _estimatedAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedAmountCentsMeta);
    }
    if (data.containsKey('is_variable')) {
      context.handle(
        _isVariableMeta,
        isVariable.isAcceptableOrUnknown(data['is_variable']!, _isVariableMeta),
      );
    }
    if (data.containsKey('due_day_of_month')) {
      context.handle(
        _dueDayOfMonthMeta,
        dueDayOfMonth.isAcceptableOrUnknown(
          data['due_day_of_month']!,
          _dueDayOfMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dueDayOfMonthMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurrence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recurrence(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $RecurrencesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      nature: $RecurrencesTable.$converternature.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nature'],
        )!,
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      estimatedAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_amount_cents'],
      )!,
      isVariable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_variable'],
      )!,
      frequency: $RecurrencesTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      dueDayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day_of_month'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_id'],
      ),
    );
  }

  @override
  $RecurrencesTable createAlias(String alias) {
    return $RecurrencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TxnType, String, String> $convertertype =
      const EnumNameConverter<TxnType>(TxnType.values);
  static JsonTypeConverter2<RecurrenceNature, String, String> $converternature =
      const EnumNameConverter<RecurrenceNature>(RecurrenceNature.values);
  static JsonTypeConverter2<Frequency, String, String> $converterfrequency =
      const EnumNameConverter<Frequency>(Frequency.values);
}

class Recurrence extends DataClass implements Insertable<Recurrence> {
  final int id;
  final String name;
  final TxnType type;
  final RecurrenceNature nature;
  final int? categoryId;
  final int accountId;
  final int estimatedAmountCents;

  /// Electricity and water swing month to month: the estimate is a placeholder
  /// until the real bill arrives.
  final bool isVariable;
  final Frequency frequency;
  final int dueDayOfMonth;
  final DateTime startDate;
  final DateTime? endDate;
  final bool active;
  final int? debtId;
  const Recurrence({
    required this.id,
    required this.name,
    required this.type,
    required this.nature,
    this.categoryId,
    required this.accountId,
    required this.estimatedAmountCents,
    required this.isVariable,
    required this.frequency,
    required this.dueDayOfMonth,
    required this.startDate,
    this.endDate,
    required this.active,
    this.debtId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>(
        $RecurrencesTable.$convertertype.toSql(type),
      );
    }
    {
      map['nature'] = Variable<String>(
        $RecurrencesTable.$converternature.toSql(nature),
      );
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['account_id'] = Variable<int>(accountId);
    map['estimated_amount_cents'] = Variable<int>(estimatedAmountCents);
    map['is_variable'] = Variable<bool>(isVariable);
    {
      map['frequency'] = Variable<String>(
        $RecurrencesTable.$converterfrequency.toSql(frequency),
      );
    }
    map['due_day_of_month'] = Variable<int>(dueDayOfMonth);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || debtId != null) {
      map['debt_id'] = Variable<int>(debtId);
    }
    return map;
  }

  RecurrencesCompanion toCompanion(bool nullToAbsent) {
    return RecurrencesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      nature: Value(nature),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: Value(accountId),
      estimatedAmountCents: Value(estimatedAmountCents),
      isVariable: Value(isVariable),
      frequency: Value(frequency),
      dueDayOfMonth: Value(dueDayOfMonth),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      active: Value(active),
      debtId: debtId == null && nullToAbsent
          ? const Value.absent()
          : Value(debtId),
    );
  }

  factory Recurrence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recurrence(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $RecurrencesTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      nature: $RecurrencesTable.$converternature.fromJson(
        serializer.fromJson<String>(json['nature']),
      ),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      accountId: serializer.fromJson<int>(json['accountId']),
      estimatedAmountCents: serializer.fromJson<int>(
        json['estimatedAmountCents'],
      ),
      isVariable: serializer.fromJson<bool>(json['isVariable']),
      frequency: $RecurrencesTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      dueDayOfMonth: serializer.fromJson<int>(json['dueDayOfMonth']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      active: serializer.fromJson<bool>(json['active']),
      debtId: serializer.fromJson<int?>(json['debtId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(
        $RecurrencesTable.$convertertype.toJson(type),
      ),
      'nature': serializer.toJson<String>(
        $RecurrencesTable.$converternature.toJson(nature),
      ),
      'categoryId': serializer.toJson<int?>(categoryId),
      'accountId': serializer.toJson<int>(accountId),
      'estimatedAmountCents': serializer.toJson<int>(estimatedAmountCents),
      'isVariable': serializer.toJson<bool>(isVariable),
      'frequency': serializer.toJson<String>(
        $RecurrencesTable.$converterfrequency.toJson(frequency),
      ),
      'dueDayOfMonth': serializer.toJson<int>(dueDayOfMonth),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'active': serializer.toJson<bool>(active),
      'debtId': serializer.toJson<int?>(debtId),
    };
  }

  Recurrence copyWith({
    int? id,
    String? name,
    TxnType? type,
    RecurrenceNature? nature,
    Value<int?> categoryId = const Value.absent(),
    int? accountId,
    int? estimatedAmountCents,
    bool? isVariable,
    Frequency? frequency,
    int? dueDayOfMonth,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? active,
    Value<int?> debtId = const Value.absent(),
  }) => Recurrence(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    nature: nature ?? this.nature,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId ?? this.accountId,
    estimatedAmountCents: estimatedAmountCents ?? this.estimatedAmountCents,
    isVariable: isVariable ?? this.isVariable,
    frequency: frequency ?? this.frequency,
    dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    active: active ?? this.active,
    debtId: debtId.present ? debtId.value : this.debtId,
  );
  Recurrence copyWithCompanion(RecurrencesCompanion data) {
    return Recurrence(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      nature: data.nature.present ? data.nature.value : this.nature,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      estimatedAmountCents: data.estimatedAmountCents.present
          ? data.estimatedAmountCents.value
          : this.estimatedAmountCents,
      isVariable: data.isVariable.present
          ? data.isVariable.value
          : this.isVariable,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dueDayOfMonth: data.dueDayOfMonth.present
          ? data.dueDayOfMonth.value
          : this.dueDayOfMonth,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      active: data.active.present ? data.active.value : this.active,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recurrence(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nature: $nature, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('estimatedAmountCents: $estimatedAmountCents, ')
          ..write('isVariable: $isVariable, ')
          ..write('frequency: $frequency, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('active: $active, ')
          ..write('debtId: $debtId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    type,
    nature,
    categoryId,
    accountId,
    estimatedAmountCents,
    isVariable,
    frequency,
    dueDayOfMonth,
    startDate,
    endDate,
    active,
    debtId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurrence &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.nature == this.nature &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.estimatedAmountCents == this.estimatedAmountCents &&
          other.isVariable == this.isVariable &&
          other.frequency == this.frequency &&
          other.dueDayOfMonth == this.dueDayOfMonth &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.active == this.active &&
          other.debtId == this.debtId);
}

class RecurrencesCompanion extends UpdateCompanion<Recurrence> {
  final Value<int> id;
  final Value<String> name;
  final Value<TxnType> type;
  final Value<RecurrenceNature> nature;
  final Value<int?> categoryId;
  final Value<int> accountId;
  final Value<int> estimatedAmountCents;
  final Value<bool> isVariable;
  final Value<Frequency> frequency;
  final Value<int> dueDayOfMonth;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> active;
  final Value<int?> debtId;
  const RecurrencesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.nature = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.estimatedAmountCents = const Value.absent(),
    this.isVariable = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dueDayOfMonth = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.active = const Value.absent(),
    this.debtId = const Value.absent(),
  });
  RecurrencesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TxnType type,
    required RecurrenceNature nature,
    this.categoryId = const Value.absent(),
    required int accountId,
    required int estimatedAmountCents,
    this.isVariable = const Value.absent(),
    required Frequency frequency,
    required int dueDayOfMonth,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.active = const Value.absent(),
    this.debtId = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       nature = Value(nature),
       accountId = Value(accountId),
       estimatedAmountCents = Value(estimatedAmountCents),
       frequency = Value(frequency),
       dueDayOfMonth = Value(dueDayOfMonth),
       startDate = Value(startDate);
  static Insertable<Recurrence> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? nature,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<int>? estimatedAmountCents,
    Expression<bool>? isVariable,
    Expression<String>? frequency,
    Expression<int>? dueDayOfMonth,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? active,
    Expression<int>? debtId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (nature != null) 'nature': nature,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (estimatedAmountCents != null)
        'estimated_amount_cents': estimatedAmountCents,
      if (isVariable != null) 'is_variable': isVariable,
      if (frequency != null) 'frequency': frequency,
      if (dueDayOfMonth != null) 'due_day_of_month': dueDayOfMonth,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (active != null) 'active': active,
      if (debtId != null) 'debt_id': debtId,
    });
  }

  RecurrencesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<TxnType>? type,
    Value<RecurrenceNature>? nature,
    Value<int?>? categoryId,
    Value<int>? accountId,
    Value<int>? estimatedAmountCents,
    Value<bool>? isVariable,
    Value<Frequency>? frequency,
    Value<int>? dueDayOfMonth,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? active,
    Value<int?>? debtId,
  }) {
    return RecurrencesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      nature: nature ?? this.nature,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      estimatedAmountCents: estimatedAmountCents ?? this.estimatedAmountCents,
      isVariable: isVariable ?? this.isVariable,
      frequency: frequency ?? this.frequency,
      dueDayOfMonth: dueDayOfMonth ?? this.dueDayOfMonth,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      active: active ?? this.active,
      debtId: debtId ?? this.debtId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $RecurrencesTable.$convertertype.toSql(type.value),
      );
    }
    if (nature.present) {
      map['nature'] = Variable<String>(
        $RecurrencesTable.$converternature.toSql(nature.value),
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (estimatedAmountCents.present) {
      map['estimated_amount_cents'] = Variable<int>(estimatedAmountCents.value);
    }
    if (isVariable.present) {
      map['is_variable'] = Variable<bool>(isVariable.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $RecurrencesTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (dueDayOfMonth.present) {
      map['due_day_of_month'] = Variable<int>(dueDayOfMonth.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrencesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('nature: $nature, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('estimatedAmountCents: $estimatedAmountCents, ')
          ..write('isVariable: $isVariable, ')
          ..write('frequency: $frequency, ')
          ..write('dueDayOfMonth: $dueDayOfMonth, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('active: $active, ')
          ..write('debtId: $debtId')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceInstancesTable extends RecurrenceInstances
    with TableInfo<$RecurrenceInstancesTable, RecurrenceInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recurrenceIdMeta = const VerificationMeta(
    'recurrenceId',
  );
  @override
  late final GeneratedColumn<int> recurrenceId = GeneratedColumn<int>(
    'recurrence_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurrences (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedAmountCentsMeta =
      const VerificationMeta('estimatedAmountCents');
  @override
  late final GeneratedColumn<int> estimatedAmountCents = GeneratedColumn<int>(
    'estimated_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualAmountCentsMeta = const VerificationMeta(
    'actualAmountCents',
  );
  @override
  late final GeneratedColumn<int> actualAmountCents = GeneratedColumn<int>(
    'actual_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InstanceStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<InstanceStatus>(
        $RecurrenceInstancesTable.$converterstatus,
      );
  static const VerificationMeta _paidDateMeta = const VerificationMeta(
    'paidDate',
  );
  @override
  late final GeneratedColumn<DateTime> paidDate = GeneratedColumn<DateTime>(
    'paid_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recurrenceId,
    periodId,
    label,
    dueDate,
    estimatedAmountCents,
    actualAmountCents,
    status,
    paidDate,
    transactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceInstance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recurrence_id')) {
      context.handle(
        _recurrenceIdMeta,
        recurrenceId.isAcceptableOrUnknown(
          data['recurrence_id']!,
          _recurrenceIdMeta,
        ),
      );
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('estimated_amount_cents')) {
      context.handle(
        _estimatedAmountCentsMeta,
        estimatedAmountCents.isAcceptableOrUnknown(
          data['estimated_amount_cents']!,
          _estimatedAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedAmountCentsMeta);
    }
    if (data.containsKey('actual_amount_cents')) {
      context.handle(
        _actualAmountCentsMeta,
        actualAmountCents.isAcceptableOrUnknown(
          data['actual_amount_cents']!,
          _actualAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('paid_date')) {
      context.handle(
        _paidDateMeta,
        paidDate.isAcceptableOrUnknown(data['paid_date']!, _paidDateMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {recurrenceId, dueDate},
  ];
  @override
  RecurrenceInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceInstance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recurrenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrence_id'],
      ),
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      estimatedAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_amount_cents'],
      )!,
      actualAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_amount_cents'],
      ),
      status: $RecurrenceInstancesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      paidDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_date'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
    );
  }

  @override
  $RecurrenceInstancesTable createAlias(String alias) {
    return $RecurrenceInstancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InstanceStatus, String, String> $converterstatus =
      const EnumNameConverter<InstanceStatus>(InstanceStatus.values);
}

class RecurrenceInstance extends DataClass
    implements Insertable<RecurrenceInstance> {
  final int id;
  final int? recurrenceId;
  final int periodId;

  /// Copied from the recurrence so renaming it later does not rewrite history.
  final String label;
  final DateTime dueDate;
  final int estimatedAmountCents;

  /// Null until the real bill is known. The budget engine prefers this.
  final int? actualAmountCents;
  final InstanceStatus status;
  final DateTime? paidDate;
  final int? transactionId;
  const RecurrenceInstance({
    required this.id,
    this.recurrenceId,
    required this.periodId,
    required this.label,
    required this.dueDate,
    required this.estimatedAmountCents,
    this.actualAmountCents,
    required this.status,
    this.paidDate,
    this.transactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || recurrenceId != null) {
      map['recurrence_id'] = Variable<int>(recurrenceId);
    }
    map['period_id'] = Variable<int>(periodId);
    map['label'] = Variable<String>(label);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['estimated_amount_cents'] = Variable<int>(estimatedAmountCents);
    if (!nullToAbsent || actualAmountCents != null) {
      map['actual_amount_cents'] = Variable<int>(actualAmountCents);
    }
    {
      map['status'] = Variable<String>(
        $RecurrenceInstancesTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || paidDate != null) {
      map['paid_date'] = Variable<DateTime>(paidDate);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    return map;
  }

  RecurrenceInstancesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceInstancesCompanion(
      id: Value(id),
      recurrenceId: recurrenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceId),
      periodId: Value(periodId),
      label: Value(label),
      dueDate: Value(dueDate),
      estimatedAmountCents: Value(estimatedAmountCents),
      actualAmountCents: actualAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(actualAmountCents),
      status: Value(status),
      paidDate: paidDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paidDate),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory RecurrenceInstance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceInstance(
      id: serializer.fromJson<int>(json['id']),
      recurrenceId: serializer.fromJson<int?>(json['recurrenceId']),
      periodId: serializer.fromJson<int>(json['periodId']),
      label: serializer.fromJson<String>(json['label']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      estimatedAmountCents: serializer.fromJson<int>(
        json['estimatedAmountCents'],
      ),
      actualAmountCents: serializer.fromJson<int?>(json['actualAmountCents']),
      status: $RecurrenceInstancesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      paidDate: serializer.fromJson<DateTime?>(json['paidDate']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recurrenceId': serializer.toJson<int?>(recurrenceId),
      'periodId': serializer.toJson<int>(periodId),
      'label': serializer.toJson<String>(label),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'estimatedAmountCents': serializer.toJson<int>(estimatedAmountCents),
      'actualAmountCents': serializer.toJson<int?>(actualAmountCents),
      'status': serializer.toJson<String>(
        $RecurrenceInstancesTable.$converterstatus.toJson(status),
      ),
      'paidDate': serializer.toJson<DateTime?>(paidDate),
      'transactionId': serializer.toJson<int?>(transactionId),
    };
  }

  RecurrenceInstance copyWith({
    int? id,
    Value<int?> recurrenceId = const Value.absent(),
    int? periodId,
    String? label,
    DateTime? dueDate,
    int? estimatedAmountCents,
    Value<int?> actualAmountCents = const Value.absent(),
    InstanceStatus? status,
    Value<DateTime?> paidDate = const Value.absent(),
    Value<int?> transactionId = const Value.absent(),
  }) => RecurrenceInstance(
    id: id ?? this.id,
    recurrenceId: recurrenceId.present ? recurrenceId.value : this.recurrenceId,
    periodId: periodId ?? this.periodId,
    label: label ?? this.label,
    dueDate: dueDate ?? this.dueDate,
    estimatedAmountCents: estimatedAmountCents ?? this.estimatedAmountCents,
    actualAmountCents: actualAmountCents.present
        ? actualAmountCents.value
        : this.actualAmountCents,
    status: status ?? this.status,
    paidDate: paidDate.present ? paidDate.value : this.paidDate,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
  );
  RecurrenceInstance copyWithCompanion(RecurrenceInstancesCompanion data) {
    return RecurrenceInstance(
      id: data.id.present ? data.id.value : this.id,
      recurrenceId: data.recurrenceId.present
          ? data.recurrenceId.value
          : this.recurrenceId,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      label: data.label.present ? data.label.value : this.label,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      estimatedAmountCents: data.estimatedAmountCents.present
          ? data.estimatedAmountCents.value
          : this.estimatedAmountCents,
      actualAmountCents: data.actualAmountCents.present
          ? data.actualAmountCents.value
          : this.actualAmountCents,
      status: data.status.present ? data.status.value : this.status,
      paidDate: data.paidDate.present ? data.paidDate.value : this.paidDate,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceInstance(')
          ..write('id: $id, ')
          ..write('recurrenceId: $recurrenceId, ')
          ..write('periodId: $periodId, ')
          ..write('label: $label, ')
          ..write('dueDate: $dueDate, ')
          ..write('estimatedAmountCents: $estimatedAmountCents, ')
          ..write('actualAmountCents: $actualAmountCents, ')
          ..write('status: $status, ')
          ..write('paidDate: $paidDate, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recurrenceId,
    periodId,
    label,
    dueDate,
    estimatedAmountCents,
    actualAmountCents,
    status,
    paidDate,
    transactionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceInstance &&
          other.id == this.id &&
          other.recurrenceId == this.recurrenceId &&
          other.periodId == this.periodId &&
          other.label == this.label &&
          other.dueDate == this.dueDate &&
          other.estimatedAmountCents == this.estimatedAmountCents &&
          other.actualAmountCents == this.actualAmountCents &&
          other.status == this.status &&
          other.paidDate == this.paidDate &&
          other.transactionId == this.transactionId);
}

class RecurrenceInstancesCompanion extends UpdateCompanion<RecurrenceInstance> {
  final Value<int> id;
  final Value<int?> recurrenceId;
  final Value<int> periodId;
  final Value<String> label;
  final Value<DateTime> dueDate;
  final Value<int> estimatedAmountCents;
  final Value<int?> actualAmountCents;
  final Value<InstanceStatus> status;
  final Value<DateTime?> paidDate;
  final Value<int?> transactionId;
  const RecurrenceInstancesCompanion({
    this.id = const Value.absent(),
    this.recurrenceId = const Value.absent(),
    this.periodId = const Value.absent(),
    this.label = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.estimatedAmountCents = const Value.absent(),
    this.actualAmountCents = const Value.absent(),
    this.status = const Value.absent(),
    this.paidDate = const Value.absent(),
    this.transactionId = const Value.absent(),
  });
  RecurrenceInstancesCompanion.insert({
    this.id = const Value.absent(),
    this.recurrenceId = const Value.absent(),
    required int periodId,
    required String label,
    required DateTime dueDate,
    required int estimatedAmountCents,
    this.actualAmountCents = const Value.absent(),
    required InstanceStatus status,
    this.paidDate = const Value.absent(),
    this.transactionId = const Value.absent(),
  }) : periodId = Value(periodId),
       label = Value(label),
       dueDate = Value(dueDate),
       estimatedAmountCents = Value(estimatedAmountCents),
       status = Value(status);
  static Insertable<RecurrenceInstance> custom({
    Expression<int>? id,
    Expression<int>? recurrenceId,
    Expression<int>? periodId,
    Expression<String>? label,
    Expression<DateTime>? dueDate,
    Expression<int>? estimatedAmountCents,
    Expression<int>? actualAmountCents,
    Expression<String>? status,
    Expression<DateTime>? paidDate,
    Expression<int>? transactionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recurrenceId != null) 'recurrence_id': recurrenceId,
      if (periodId != null) 'period_id': periodId,
      if (label != null) 'label': label,
      if (dueDate != null) 'due_date': dueDate,
      if (estimatedAmountCents != null)
        'estimated_amount_cents': estimatedAmountCents,
      if (actualAmountCents != null) 'actual_amount_cents': actualAmountCents,
      if (status != null) 'status': status,
      if (paidDate != null) 'paid_date': paidDate,
      if (transactionId != null) 'transaction_id': transactionId,
    });
  }

  RecurrenceInstancesCompanion copyWith({
    Value<int>? id,
    Value<int?>? recurrenceId,
    Value<int>? periodId,
    Value<String>? label,
    Value<DateTime>? dueDate,
    Value<int>? estimatedAmountCents,
    Value<int?>? actualAmountCents,
    Value<InstanceStatus>? status,
    Value<DateTime?>? paidDate,
    Value<int?>? transactionId,
  }) {
    return RecurrenceInstancesCompanion(
      id: id ?? this.id,
      recurrenceId: recurrenceId ?? this.recurrenceId,
      periodId: periodId ?? this.periodId,
      label: label ?? this.label,
      dueDate: dueDate ?? this.dueDate,
      estimatedAmountCents: estimatedAmountCents ?? this.estimatedAmountCents,
      actualAmountCents: actualAmountCents ?? this.actualAmountCents,
      status: status ?? this.status,
      paidDate: paidDate ?? this.paidDate,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recurrenceId.present) {
      map['recurrence_id'] = Variable<int>(recurrenceId.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (estimatedAmountCents.present) {
      map['estimated_amount_cents'] = Variable<int>(estimatedAmountCents.value);
    }
    if (actualAmountCents.present) {
      map['actual_amount_cents'] = Variable<int>(actualAmountCents.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $RecurrenceInstancesTable.$converterstatus.toSql(status.value),
      );
    }
    if (paidDate.present) {
      map['paid_date'] = Variable<DateTime>(paidDate.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceInstancesCompanion(')
          ..write('id: $id, ')
          ..write('recurrenceId: $recurrenceId, ')
          ..write('periodId: $periodId, ')
          ..write('label: $label, ')
          ..write('dueDate: $dueDate, ')
          ..write('estimatedAmountCents: $estimatedAmountCents, ')
          ..write('actualAmountCents: $actualAmountCents, ')
          ..write('status: $status, ')
          ..write('paidDate: $paidDate, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _limitCentsMeta = const VerificationMeta(
    'limitCents',
  );
  @override
  late final GeneratedColumn<int> limitCents = GeneratedColumn<int>(
    'limit_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolloverMeta = const VerificationMeta(
    'rollover',
  );
  @override
  late final GeneratedColumn<bool> rollover = GeneratedColumn<bool>(
    'rollover',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rollover" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _rolloverInCentsMeta = const VerificationMeta(
    'rolloverInCents',
  );
  @override
  late final GeneratedColumn<int> rolloverInCents = GeneratedColumn<int>(
    'rollover_in_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    periodId,
    categoryId,
    limitCents,
    rollover,
    rolloverInCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('limit_cents')) {
      context.handle(
        _limitCentsMeta,
        limitCents.isAcceptableOrUnknown(data['limit_cents']!, _limitCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_limitCentsMeta);
    }
    if (data.containsKey('rollover')) {
      context.handle(
        _rolloverMeta,
        rollover.isAcceptableOrUnknown(data['rollover']!, _rolloverMeta),
      );
    }
    if (data.containsKey('rollover_in_cents')) {
      context.handle(
        _rolloverInCentsMeta,
        rolloverInCents.isAcceptableOrUnknown(
          data['rollover_in_cents']!,
          _rolloverInCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {periodId, categoryId},
  ];
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      limitCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}limit_cents'],
      )!,
      rollover: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rollover'],
      )!,
      rolloverInCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rollover_in_cents'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final int id;
  final int periodId;
  final int categoryId;
  final int limitCents;

  /// Unspent money rolls into next month's envelope.
  final bool rollover;
  final int rolloverInCents;
  const Budget({
    required this.id,
    required this.periodId,
    required this.categoryId,
    required this.limitCents,
    required this.rollover,
    required this.rolloverInCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['period_id'] = Variable<int>(periodId);
    map['category_id'] = Variable<int>(categoryId);
    map['limit_cents'] = Variable<int>(limitCents);
    map['rollover'] = Variable<bool>(rollover);
    map['rollover_in_cents'] = Variable<int>(rolloverInCents);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      periodId: Value(periodId),
      categoryId: Value(categoryId),
      limitCents: Value(limitCents),
      rollover: Value(rollover),
      rolloverInCents: Value(rolloverInCents),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<int>(json['id']),
      periodId: serializer.fromJson<int>(json['periodId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      limitCents: serializer.fromJson<int>(json['limitCents']),
      rollover: serializer.fromJson<bool>(json['rollover']),
      rolloverInCents: serializer.fromJson<int>(json['rolloverInCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'periodId': serializer.toJson<int>(periodId),
      'categoryId': serializer.toJson<int>(categoryId),
      'limitCents': serializer.toJson<int>(limitCents),
      'rollover': serializer.toJson<bool>(rollover),
      'rolloverInCents': serializer.toJson<int>(rolloverInCents),
    };
  }

  Budget copyWith({
    int? id,
    int? periodId,
    int? categoryId,
    int? limitCents,
    bool? rollover,
    int? rolloverInCents,
  }) => Budget(
    id: id ?? this.id,
    periodId: periodId ?? this.periodId,
    categoryId: categoryId ?? this.categoryId,
    limitCents: limitCents ?? this.limitCents,
    rollover: rollover ?? this.rollover,
    rolloverInCents: rolloverInCents ?? this.rolloverInCents,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      limitCents: data.limitCents.present
          ? data.limitCents.value
          : this.limitCents,
      rollover: data.rollover.present ? data.rollover.value : this.rollover,
      rolloverInCents: data.rolloverInCents.present
          ? data.rolloverInCents.value
          : this.rolloverInCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitCents: $limitCents, ')
          ..write('rollover: $rollover, ')
          ..write('rolloverInCents: $rolloverInCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    periodId,
    categoryId,
    limitCents,
    rollover,
    rolloverInCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.periodId == this.periodId &&
          other.categoryId == this.categoryId &&
          other.limitCents == this.limitCents &&
          other.rollover == this.rollover &&
          other.rolloverInCents == this.rolloverInCents);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<int> id;
  final Value<int> periodId;
  final Value<int> categoryId;
  final Value<int> limitCents;
  final Value<bool> rollover;
  final Value<int> rolloverInCents;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.periodId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.limitCents = const Value.absent(),
    this.rollover = const Value.absent(),
    this.rolloverInCents = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int periodId,
    required int categoryId,
    required int limitCents,
    this.rollover = const Value.absent(),
    this.rolloverInCents = const Value.absent(),
  }) : periodId = Value(periodId),
       categoryId = Value(categoryId),
       limitCents = Value(limitCents);
  static Insertable<Budget> custom({
    Expression<int>? id,
    Expression<int>? periodId,
    Expression<int>? categoryId,
    Expression<int>? limitCents,
    Expression<bool>? rollover,
    Expression<int>? rolloverInCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (periodId != null) 'period_id': periodId,
      if (categoryId != null) 'category_id': categoryId,
      if (limitCents != null) 'limit_cents': limitCents,
      if (rollover != null) 'rollover': rollover,
      if (rolloverInCents != null) 'rollover_in_cents': rolloverInCents,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? id,
    Value<int>? periodId,
    Value<int>? categoryId,
    Value<int>? limitCents,
    Value<bool>? rollover,
    Value<int>? rolloverInCents,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      periodId: periodId ?? this.periodId,
      categoryId: categoryId ?? this.categoryId,
      limitCents: limitCents ?? this.limitCents,
      rollover: rollover ?? this.rollover,
      rolloverInCents: rolloverInCents ?? this.rolloverInCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (limitCents.present) {
      map['limit_cents'] = Variable<int>(limitCents.value);
    }
    if (rollover.present) {
      map['rollover'] = Variable<bool>(rollover.value);
    }
    if (rolloverInCents.present) {
      map['rollover_in_cents'] = Variable<int>(rolloverInCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('periodId: $periodId, ')
          ..write('categoryId: $categoryId, ')
          ..write('limitCents: $limitCents, ')
          ..write('rollover: $rollover, ')
          ..write('rolloverInCents: $rolloverInCents')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTable extends SavingsGoals
    with TableInfo<$SavingsGoalsTable, SavingsGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetCentsMeta = const VerificationMeta(
    'targetCents',
  );
  @override
  late final GeneratedColumn<int> targetCents = GeneratedColumn<int>(
    'target_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _monthlyPlannedCentsMeta =
      const VerificationMeta('monthlyPlannedCents');
  @override
  late final GeneratedColumn<int> monthlyPlannedCents = GeneratedColumn<int>(
    'monthly_planned_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('target'),
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    targetCents,
    targetDate,
    accountId,
    monthlyPlannedCents,
    iconKey,
    archived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_cents')) {
      context.handle(
        _targetCentsMeta,
        targetCents.isAcceptableOrUnknown(
          data['target_cents']!,
          _targetCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetCentsMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('monthly_planned_cents')) {
      context.handle(
        _monthlyPlannedCentsMeta,
        monthlyPlannedCents.isAcceptableOrUnknown(
          data['monthly_planned_cents']!,
          _monthlyPlannedCentsMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cents'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      monthlyPlannedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_planned_cents'],
      )!,
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $SavingsGoalsTable createAlias(String alias) {
    return $SavingsGoalsTable(attachedDatabase, alias);
  }
}

class SavingsGoal extends DataClass implements Insertable<SavingsGoal> {
  final int id;
  final String name;
  final int targetCents;
  final DateTime? targetDate;
  final int? accountId;

  /// Deducted from the "reste à vivre" as planned savings.
  final int monthlyPlannedCents;
  final String iconKey;
  final bool archived;
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetCents,
    this.targetDate,
    this.accountId,
    required this.monthlyPlannedCents,
    required this.iconKey,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['target_cents'] = Variable<int>(targetCents);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    map['monthly_planned_cents'] = Variable<int>(monthlyPlannedCents);
    map['icon_key'] = Variable<String>(iconKey);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  SavingsGoalsCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsCompanion(
      id: Value(id),
      name: Value(name),
      targetCents: Value(targetCents),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      monthlyPlannedCents: Value(monthlyPlannedCents),
      iconKey: Value(iconKey),
      archived: Value(archived),
    );
  }

  factory SavingsGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      targetCents: serializer.fromJson<int>(json['targetCents']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      monthlyPlannedCents: serializer.fromJson<int>(
        json['monthlyPlannedCents'],
      ),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'targetCents': serializer.toJson<int>(targetCents),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'accountId': serializer.toJson<int?>(accountId),
      'monthlyPlannedCents': serializer.toJson<int>(monthlyPlannedCents),
      'iconKey': serializer.toJson<String>(iconKey),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  SavingsGoal copyWith({
    int? id,
    String? name,
    int? targetCents,
    Value<DateTime?> targetDate = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    int? monthlyPlannedCents,
    String? iconKey,
    bool? archived,
  }) => SavingsGoal(
    id: id ?? this.id,
    name: name ?? this.name,
    targetCents: targetCents ?? this.targetCents,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    accountId: accountId.present ? accountId.value : this.accountId,
    monthlyPlannedCents: monthlyPlannedCents ?? this.monthlyPlannedCents,
    iconKey: iconKey ?? this.iconKey,
    archived: archived ?? this.archived,
  );
  SavingsGoal copyWithCompanion(SavingsGoalsCompanion data) {
    return SavingsGoal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      targetCents: data.targetCents.present
          ? data.targetCents.value
          : this.targetCents,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      monthlyPlannedCents: data.monthlyPlannedCents.present
          ? data.monthlyPlannedCents.value
          : this.monthlyPlannedCents,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('accountId: $accountId, ')
          ..write('monthlyPlannedCents: $monthlyPlannedCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    targetCents,
    targetDate,
    accountId,
    monthlyPlannedCents,
    iconKey,
    archived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoal &&
          other.id == this.id &&
          other.name == this.name &&
          other.targetCents == this.targetCents &&
          other.targetDate == this.targetDate &&
          other.accountId == this.accountId &&
          other.monthlyPlannedCents == this.monthlyPlannedCents &&
          other.iconKey == this.iconKey &&
          other.archived == this.archived);
}

class SavingsGoalsCompanion extends UpdateCompanion<SavingsGoal> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> targetCents;
  final Value<DateTime?> targetDate;
  final Value<int?> accountId;
  final Value<int> monthlyPlannedCents;
  final Value<String> iconKey;
  final Value<bool> archived;
  const SavingsGoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.targetCents = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.accountId = const Value.absent(),
    this.monthlyPlannedCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.archived = const Value.absent(),
  });
  SavingsGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int targetCents,
    this.targetDate = const Value.absent(),
    this.accountId = const Value.absent(),
    this.monthlyPlannedCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name),
       targetCents = Value(targetCents);
  static Insertable<SavingsGoal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? targetCents,
    Expression<DateTime>? targetDate,
    Expression<int>? accountId,
    Expression<int>? monthlyPlannedCents,
    Expression<String>? iconKey,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (targetCents != null) 'target_cents': targetCents,
      if (targetDate != null) 'target_date': targetDate,
      if (accountId != null) 'account_id': accountId,
      if (monthlyPlannedCents != null)
        'monthly_planned_cents': monthlyPlannedCents,
      if (iconKey != null) 'icon_key': iconKey,
      if (archived != null) 'archived': archived,
    });
  }

  SavingsGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? targetCents,
    Value<DateTime?>? targetDate,
    Value<int?>? accountId,
    Value<int>? monthlyPlannedCents,
    Value<String>? iconKey,
    Value<bool>? archived,
  }) {
    return SavingsGoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      targetCents: targetCents ?? this.targetCents,
      targetDate: targetDate ?? this.targetDate,
      accountId: accountId ?? this.accountId,
      monthlyPlannedCents: monthlyPlannedCents ?? this.monthlyPlannedCents,
      iconKey: iconKey ?? this.iconKey,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetCents.present) {
      map['target_cents'] = Variable<int>(targetCents.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (monthlyPlannedCents.present) {
      map['monthly_planned_cents'] = Variable<int>(monthlyPlannedCents.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('targetCents: $targetCents, ')
          ..write('targetDate: $targetDate, ')
          ..write('accountId: $accountId, ')
          ..write('monthlyPlannedCents: $monthlyPlannedCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTable extends GoalContributions
    with TableInfo<$GoalContributionsTable, GoalContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES savings_goals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    periodId,
    amountCents,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $GoalContributionsTable createAlias(String alias) {
    return $GoalContributionsTable(attachedDatabase, alias);
  }
}

class GoalContribution extends DataClass
    implements Insertable<GoalContribution> {
  final int id;
  final int goalId;
  final int periodId;
  final int amountCents;
  final DateTime date;
  const GoalContribution({
    required this.id,
    required this.goalId,
    required this.periodId,
    required this.amountCents,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['period_id'] = Variable<int>(periodId);
    map['amount_cents'] = Variable<int>(amountCents);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  GoalContributionsCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      periodId: Value(periodId),
      amountCents: Value(amountCents),
      date: Value(date),
    );
  }

  factory GoalContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContribution(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      periodId: serializer.fromJson<int>(json['periodId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'periodId': serializer.toJson<int>(periodId),
      'amountCents': serializer.toJson<int>(amountCents),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  GoalContribution copyWith({
    int? id,
    int? goalId,
    int? periodId,
    int? amountCents,
    DateTime? date,
  }) => GoalContribution(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    periodId: periodId ?? this.periodId,
    amountCents: amountCents ?? this.amountCents,
    date: date ?? this.date,
  );
  GoalContribution copyWithCompanion(GoalContributionsCompanion data) {
    return GoalContribution(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContribution(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('periodId: $periodId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, periodId, amountCents, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContribution &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.periodId == this.periodId &&
          other.amountCents == this.amountCents &&
          other.date == this.date);
}

class GoalContributionsCompanion extends UpdateCompanion<GoalContribution> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<int> periodId;
  final Value<int> amountCents;
  final Value<DateTime> date;
  const GoalContributionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.periodId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.date = const Value.absent(),
  });
  GoalContributionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required int periodId,
    required int amountCents,
    required DateTime date,
  }) : goalId = Value(goalId),
       periodId = Value(periodId),
       amountCents = Value(amountCents),
       date = Value(date);
  static Insertable<GoalContribution> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<int>? periodId,
    Expression<int>? amountCents,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (periodId != null) 'period_id': periodId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (date != null) 'date': date,
    });
  }

  GoalContributionsCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<int>? periodId,
    Value<int>? amountCents,
    Value<DateTime>? date,
  }) {
    return GoalContributionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      periodId: periodId ?? this.periodId,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('periodId: $periodId, ')
          ..write('amountCents: $amountCents, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

class $DebtPaymentsTable extends DebtPayments
    with TableInfo<$DebtPaymentsTable, DebtPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _debtIdMeta = const VerificationMeta('debtId');
  @override
  late final GeneratedColumn<int> debtId = GeneratedColumn<int>(
    'debt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES debts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _principalCentsMeta = const VerificationMeta(
    'principalCents',
  );
  @override
  late final GeneratedColumn<int> principalCents = GeneratedColumn<int>(
    'principal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestCentsMeta = const VerificationMeta(
    'interestCents',
  );
  @override
  late final GeneratedColumn<int> interestCents = GeneratedColumn<int>(
    'interest_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    debtId,
    transactionId,
    date,
    amountCents,
    principalCents,
    interestCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('debt_id')) {
      context.handle(
        _debtIdMeta,
        debtId.isAcceptableOrUnknown(data['debt_id']!, _debtIdMeta),
      );
    } else if (isInserting) {
      context.missing(_debtIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('principal_cents')) {
      context.handle(
        _principalCentsMeta,
        principalCents.isAcceptableOrUnknown(
          data['principal_cents']!,
          _principalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_principalCentsMeta);
    }
    if (data.containsKey('interest_cents')) {
      context.handle(
        _interestCentsMeta,
        interestCents.isAcceptableOrUnknown(
          data['interest_cents']!,
          _interestCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebtPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      debtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debt_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaction_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      principalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}principal_cents'],
      )!,
      interestCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_cents'],
      )!,
    );
  }

  @override
  $DebtPaymentsTable createAlias(String alias) {
    return $DebtPaymentsTable(attachedDatabase, alias);
  }
}

class DebtPayment extends DataClass implements Insertable<DebtPayment> {
  final int id;
  final int debtId;
  final int? transactionId;
  final DateTime date;
  final int amountCents;
  final int principalCents;
  final int interestCents;
  const DebtPayment({
    required this.id,
    required this.debtId,
    this.transactionId,
    required this.date,
    required this.amountCents,
    required this.principalCents,
    required this.interestCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['debt_id'] = Variable<int>(debtId);
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    map['date'] = Variable<DateTime>(date);
    map['amount_cents'] = Variable<int>(amountCents);
    map['principal_cents'] = Variable<int>(principalCents);
    map['interest_cents'] = Variable<int>(interestCents);
    return map;
  }

  DebtPaymentsCompanion toCompanion(bool nullToAbsent) {
    return DebtPaymentsCompanion(
      id: Value(id),
      debtId: Value(debtId),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      date: Value(date),
      amountCents: Value(amountCents),
      principalCents: Value(principalCents),
      interestCents: Value(interestCents),
    );
  }

  factory DebtPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtPayment(
      id: serializer.fromJson<int>(json['id']),
      debtId: serializer.fromJson<int>(json['debtId']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
      date: serializer.fromJson<DateTime>(json['date']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      principalCents: serializer.fromJson<int>(json['principalCents']),
      interestCents: serializer.fromJson<int>(json['interestCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'debtId': serializer.toJson<int>(debtId),
      'transactionId': serializer.toJson<int?>(transactionId),
      'date': serializer.toJson<DateTime>(date),
      'amountCents': serializer.toJson<int>(amountCents),
      'principalCents': serializer.toJson<int>(principalCents),
      'interestCents': serializer.toJson<int>(interestCents),
    };
  }

  DebtPayment copyWith({
    int? id,
    int? debtId,
    Value<int?> transactionId = const Value.absent(),
    DateTime? date,
    int? amountCents,
    int? principalCents,
    int? interestCents,
  }) => DebtPayment(
    id: id ?? this.id,
    debtId: debtId ?? this.debtId,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    date: date ?? this.date,
    amountCents: amountCents ?? this.amountCents,
    principalCents: principalCents ?? this.principalCents,
    interestCents: interestCents ?? this.interestCents,
  );
  DebtPayment copyWithCompanion(DebtPaymentsCompanion data) {
    return DebtPayment(
      id: data.id.present ? data.id.value : this.id,
      debtId: data.debtId.present ? data.debtId.value : this.debtId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      date: data.date.present ? data.date.value : this.date,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      principalCents: data.principalCents.present
          ? data.principalCents.value
          : this.principalCents,
      interestCents: data.interestCents.present
          ? data.interestCents.value
          : this.interestCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtPayment(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('transactionId: $transactionId, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('principalCents: $principalCents, ')
          ..write('interestCents: $interestCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    debtId,
    transactionId,
    date,
    amountCents,
    principalCents,
    interestCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtPayment &&
          other.id == this.id &&
          other.debtId == this.debtId &&
          other.transactionId == this.transactionId &&
          other.date == this.date &&
          other.amountCents == this.amountCents &&
          other.principalCents == this.principalCents &&
          other.interestCents == this.interestCents);
}

class DebtPaymentsCompanion extends UpdateCompanion<DebtPayment> {
  final Value<int> id;
  final Value<int> debtId;
  final Value<int?> transactionId;
  final Value<DateTime> date;
  final Value<int> amountCents;
  final Value<int> principalCents;
  final Value<int> interestCents;
  const DebtPaymentsCompanion({
    this.id = const Value.absent(),
    this.debtId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.date = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.principalCents = const Value.absent(),
    this.interestCents = const Value.absent(),
  });
  DebtPaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int debtId,
    this.transactionId = const Value.absent(),
    required DateTime date,
    required int amountCents,
    required int principalCents,
    this.interestCents = const Value.absent(),
  }) : debtId = Value(debtId),
       date = Value(date),
       amountCents = Value(amountCents),
       principalCents = Value(principalCents);
  static Insertable<DebtPayment> custom({
    Expression<int>? id,
    Expression<int>? debtId,
    Expression<int>? transactionId,
    Expression<DateTime>? date,
    Expression<int>? amountCents,
    Expression<int>? principalCents,
    Expression<int>? interestCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (debtId != null) 'debt_id': debtId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (date != null) 'date': date,
      if (amountCents != null) 'amount_cents': amountCents,
      if (principalCents != null) 'principal_cents': principalCents,
      if (interestCents != null) 'interest_cents': interestCents,
    });
  }

  DebtPaymentsCompanion copyWith({
    Value<int>? id,
    Value<int>? debtId,
    Value<int?>? transactionId,
    Value<DateTime>? date,
    Value<int>? amountCents,
    Value<int>? principalCents,
    Value<int>? interestCents,
  }) {
    return DebtPaymentsCompanion(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      transactionId: transactionId ?? this.transactionId,
      date: date ?? this.date,
      amountCents: amountCents ?? this.amountCents,
      principalCents: principalCents ?? this.principalCents,
      interestCents: interestCents ?? this.interestCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (debtId.present) {
      map['debt_id'] = Variable<int>(debtId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (principalCents.present) {
      map['principal_cents'] = Variable<int>(principalCents.value);
    }
    if (interestCents.present) {
      map['interest_cents'] = Variable<int>(interestCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('debtId: $debtId, ')
          ..write('transactionId: $transactionId, ')
          ..write('date: $date, ')
          ..write('amountCents: $amountCents, ')
          ..write('principalCents: $principalCents, ')
          ..write('interestCents: $interestCents')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconKeyMeta = const VerificationMeta(
    'iconKey',
  );
  @override
  late final GeneratedColumn<String> iconKey = GeneratedColumn<String>(
    'icon_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('tag'),
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    categoryId,
    accountId,
    amountCents,
    iconKey,
    colorValue,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    }
    if (data.containsKey('icon_key')) {
      context.handle(
        _iconKeyMeta,
        iconKey.isAcceptableOrUnknown(data['icon_key']!, _iconKeyMeta),
      );
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      ),
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      ),
      iconKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_key'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String label;
  final int? categoryId;
  final int? accountId;

  /// Null means "ask the amount when tapped".
  final int? amountCents;
  final String iconKey;
  final int? colorValue;
  final int sortOrder;
  const Favorite({
    required this.id,
    required this.label,
    this.categoryId,
    this.accountId,
    this.amountCents,
    required this.iconKey,
    this.colorValue,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<int>(accountId);
    }
    if (!nullToAbsent || amountCents != null) {
      map['amount_cents'] = Variable<int>(amountCents);
    }
    map['icon_key'] = Variable<String>(iconKey);
    if (!nullToAbsent || colorValue != null) {
      map['color_value'] = Variable<int>(colorValue);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      label: Value(label),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      amountCents: amountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(amountCents),
      iconKey: Value(iconKey),
      colorValue: colorValue == null && nullToAbsent
          ? const Value.absent()
          : Value(colorValue),
      sortOrder: Value(sortOrder),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      accountId: serializer.fromJson<int?>(json['accountId']),
      amountCents: serializer.fromJson<int?>(json['amountCents']),
      iconKey: serializer.fromJson<String>(json['iconKey']),
      colorValue: serializer.fromJson<int?>(json['colorValue']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
      'categoryId': serializer.toJson<int?>(categoryId),
      'accountId': serializer.toJson<int?>(accountId),
      'amountCents': serializer.toJson<int?>(amountCents),
      'iconKey': serializer.toJson<String>(iconKey),
      'colorValue': serializer.toJson<int?>(colorValue),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Favorite copyWith({
    int? id,
    String? label,
    Value<int?> categoryId = const Value.absent(),
    Value<int?> accountId = const Value.absent(),
    Value<int?> amountCents = const Value.absent(),
    String? iconKey,
    Value<int?> colorValue = const Value.absent(),
    int? sortOrder,
  }) => Favorite(
    id: id ?? this.id,
    label: label ?? this.label,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId.present ? accountId.value : this.accountId,
    amountCents: amountCents.present ? amountCents.value : this.amountCents,
    iconKey: iconKey ?? this.iconKey,
    colorValue: colorValue.present ? colorValue.value : this.colorValue,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      iconKey: data.iconKey.present ? data.iconKey.value : this.iconKey,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    categoryId,
    accountId,
    amountCents,
    iconKey,
    colorValue,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.label == this.label &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.amountCents == this.amountCents &&
          other.iconKey == this.iconKey &&
          other.colorValue == this.colorValue &&
          other.sortOrder == this.sortOrder);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> label;
  final Value<int?> categoryId;
  final Value<int?> accountId;
  final Value<int?> amountCents;
  final Value<String> iconKey;
  final Value<int?> colorValue;
  final Value<int> sortOrder;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String label,
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.iconKey = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : label = Value(label);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? label,
    Expression<int>? categoryId,
    Expression<int>? accountId,
    Expression<int>? amountCents,
    Expression<String>? iconKey,
    Expression<int>? colorValue,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (iconKey != null) 'icon_key': iconKey,
      if (colorValue != null) 'color_value': colorValue,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  FavoritesCompanion copyWith({
    Value<int>? id,
    Value<String>? label,
    Value<int?>? categoryId,
    Value<int?>? accountId,
    Value<int?>? amountCents,
    Value<String>? iconKey,
    Value<int?>? colorValue,
    Value<int>? sortOrder,
  }) {
    return FavoritesCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      amountCents: amountCents ?? this.amountCents,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (iconKey.present) {
      map['icon_key'] = Variable<String>(iconKey.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('amountCents: $amountCents, ')
          ..write('iconKey: $iconKey, ')
          ..write('colorValue: $colorValue, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  late final $PeriodsTable periods = $PeriodsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $DebtsTable debts = $DebtsTable(this);
  late final $RecurrencesTable recurrences = $RecurrencesTable(this);
  late final $RecurrenceInstancesTable recurrenceInstances =
      $RecurrenceInstancesTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $SavingsGoalsTable savingsGoals = $SavingsGoalsTable(this);
  late final $GoalContributionsTable goalContributions =
      $GoalContributionsTable(this);
  late final $DebtPaymentsTable debtPayments = $DebtPaymentsTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    categories,
    settingsEntries,
    periods,
    transactions,
    debts,
    recurrences,
    recurrenceInstances,
    budgets,
    savingsGoals,
    goalContributions,
    debtPayments,
    favorites,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrences', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrences', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'debts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrences', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurrences',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_instances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_instances', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurrence_instances', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budgets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budgets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('savings_goals', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'savings_goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_contributions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_contributions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'debts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('debt_payments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transactions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('debt_payments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('favorites', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'accounts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('favorites', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required String name,
      required AccountType type,
      Value<int> initialBalanceCents,
      Value<String> iconKey,
      Value<int?> colorValue,
      Value<bool> archived,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<AccountType> type,
      Value<int> initialBalanceCents,
      Value<String> iconKey,
      Value<int?> colorValue,
      Value<bool> archived,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Txn>>
  _outgoingTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableProcessedTableManager get outgoingTransactions {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _outgoingTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Txn>>
  _incomingTransfersTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'accounts__id__transactions__to_account_id',
  );

  $$TransactionsTableProcessedTableManager get incomingTransfers {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.toAccountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomingTransfersTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurrencesTable, List<Recurrence>>
  _recurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurrences,
    aliasName: 'accounts__id__recurrences__account_id',
  );

  $$RecurrencesTableProcessedTableManager get recurrencesRefs {
    final manager = $$RecurrencesTableTableManager(
      $_db,
      $_db.recurrences,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurrencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavingsGoalsTable, List<SavingsGoal>>
  _savingsGoalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savingsGoals,
    aliasName: 'accounts__id__savings_goals__account_id',
  );

  $$SavingsGoalsTableProcessedTableManager get savingsGoalsRefs {
    final manager = $$SavingsGoalsTableTableManager(
      $_db,
      $_db.savingsGoals,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_savingsGoalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<Favorite>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: 'accounts__id__favorites__account_id',
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get initialBalanceCents => $composableBuilder(
    column: $table.initialBalanceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> outgoingTransactions(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingTransfers(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.toAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurrencesRefs(
    Expression<bool> Function($$RecurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableFilterComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savingsGoalsRefs(
    Expression<bool> Function($$SavingsGoalsTableFilterComposer f) f,
  ) {
    final $$SavingsGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialBalanceCents => $composableBuilder(
    column: $table.initialBalanceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get initialBalanceCents => $composableBuilder(
    column: $table.initialBalanceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> outgoingTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomingTransfers<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.toAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savingsGoalsRefs<T extends Object>(
    Expression<T> Function($$SavingsGoalsTableAnnotationComposer a) f,
  ) {
    final $$SavingsGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({
            bool outgoingTransactions,
            bool incomingTransfers,
            bool recurrencesRefs,
            bool savingsGoalsRefs,
            bool favoritesRefs,
          })
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<int> initialBalanceCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                type: type,
                initialBalanceCents: initialBalanceCents,
                iconKey: iconKey,
                colorValue: colorValue,
                archived: archived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required AccountType type,
                Value<int> initialBalanceCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                type: type,
                initialBalanceCents: initialBalanceCents,
                iconKey: iconKey,
                colorValue: colorValue,
                archived: archived,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                outgoingTransactions = false,
                incomingTransfers = false,
                recurrencesRefs = false,
                savingsGoalsRefs = false,
                favoritesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (outgoingTransactions) db.transactions,
                    if (incomingTransfers) db.transactions,
                    if (recurrencesRefs) db.recurrences,
                    if (savingsGoalsRefs) db.savingsGoals,
                    if (favoritesRefs) db.favorites,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (outgoingTransactions)
                        await $_getPrefetchedData<Account, $AccountsTable, Txn>(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._outgoingTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingTransfers)
                        await $_getPrefetchedData<Account, $AccountsTable, Txn>(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._incomingTransfersTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingTransfers,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurrencesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Recurrence
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._recurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (savingsGoalsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          SavingsGoal
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._savingsGoalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).savingsGoalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Favorite
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({
        bool outgoingTransactions,
        bool incomingTransfers,
        bool recurrencesRefs,
        bool savingsGoalsRefs,
        bool favoritesRefs,
      })
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required CategoryKind kind,
      Value<int?> parentId,
      Value<String> iconKey,
      required int colorValue,
      Value<bool> isSystem,
      Value<int> sortOrder,
      Value<bool> archived,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<CategoryKind> kind,
      Value<int?> parentId,
      Value<String> iconKey,
      Value<int> colorValue,
      Value<bool> isSystem,
      Value<int> sortOrder,
      Value<bool> archived,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTable, List<Txn>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'categories__id__transactions__category_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecurrencesTable, List<Recurrence>>
  _recurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurrences,
    aliasName: 'categories__id__recurrences__category_id',
  );

  $$RecurrencesTableProcessedTableManager get recurrencesRefs {
    final manager = $$RecurrencesTableTableManager(
      $_db,
      $_db.recurrences,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurrencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'categories__id__budgets__category_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<Favorite>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: 'categories__id__favorites__category_id',
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CategoryKind, CategoryKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurrencesRefs(
    Expression<bool> Function($$RecurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableFilterComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CategoryKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({
            bool parentId,
            bool transactionsRefs,
            bool recurrencesRefs,
            bool budgetsRefs,
            bool favoritesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<CategoryKind> kind = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                kind: kind,
                parentId: parentId,
                iconKey: iconKey,
                colorValue: colorValue,
                isSystem: isSystem,
                sortOrder: sortOrder,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required CategoryKind kind,
                Value<int?> parentId = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                required int colorValue,
                Value<bool> isSystem = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                parentId: parentId,
                iconKey: iconKey,
                colorValue: colorValue,
                isSystem: isSystem,
                sortOrder: sortOrder,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                transactionsRefs = false,
                recurrencesRefs = false,
                budgetsRefs = false,
                favoritesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (recurrencesRefs) db.recurrences,
                    if (budgetsRefs) db.budgets,
                    if (favoritesRefs) db.favorites,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$CategoriesTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn:
                                        $$CategoriesTableReferences
                                            ._parentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Txn
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurrencesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Recurrence
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Budget
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Favorite
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({
        bool parentId,
        bool transactionsRefs,
        bool recurrencesRefs,
        bool budgetsRefs,
        bool favoritesRefs,
      })
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingEntry,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingEntry,
            BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingEntry>,
          ),
          SettingEntry,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingEntry,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingEntry,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingEntry>,
      ),
      SettingEntry,
      PrefetchHooks Function()
    >;
typedef $$PeriodsTableCreateCompanionBuilder =
    PeriodsCompanion Function({
      Value<int> id,
      required DateTime startDate,
      required DateTime endDate,
      required PeriodStatus status,
      Value<int> carryOverInCents,
      Value<int?> carryOverManualCents,
      Value<DateTime?> closedAt,
    });
typedef $$PeriodsTableUpdateCompanionBuilder =
    PeriodsCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<PeriodStatus> status,
      Value<int> carryOverInCents,
      Value<int?> carryOverManualCents,
      Value<DateTime?> closedAt,
    });

final class $$PeriodsTableReferences
    extends BaseReferences<_$AppDatabase, $PeriodsTable, Period> {
  $$PeriodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<Txn>>
  _transactionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactions,
    aliasName: 'periods__id__transactions__period_id',
  );

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurrenceInstancesTable,
    List<RecurrenceInstance>
  >
  _recurrenceInstancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceInstances,
        aliasName: 'periods__id__recurrence_instances__period_id',
      );

  $$RecurrenceInstancesTableProcessedTableManager get recurrenceInstancesRefs {
    final manager = $$RecurrenceInstancesTableTableManager(
      $_db,
      $_db.recurrenceInstances,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTable, List<Budget>> _budgetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.budgets,
    aliasName: 'periods__id__budgets__period_id',
  );

  $$BudgetsTableProcessedTableManager get budgetsRefs {
    final manager = $$BudgetsTableTableManager(
      $_db,
      $_db.budgets,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalContributionsTable, List<GoalContribution>>
  _goalContributionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributions,
        aliasName: 'periods__id__goal_contributions__period_id',
      );

  $$GoalContributionsTableProcessedTableManager get goalContributionsRefs {
    final manager = $$GoalContributionsTableTableManager(
      $_db,
      $_db.goalContributions,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PeriodStatus, PeriodStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get carryOverInCents => $composableBuilder(
    column: $table.carryOverInCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carryOverManualCents => $composableBuilder(
    column: $table.carryOverManualCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsRefs(
    Expression<bool> Function($$TransactionsTableFilterComposer f) f,
  ) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurrenceInstancesRefs(
    Expression<bool> Function($$RecurrenceInstancesTableFilterComposer f) f,
  ) {
    final $$RecurrenceInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrenceInstances,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceInstancesTableFilterComposer(
            $db: $db,
            $table: $db.recurrenceInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsRefs(
    Expression<bool> Function($$BudgetsTableFilterComposer f) f,
  ) {
    final $$BudgetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableFilterComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalContributionsRefs(
    Expression<bool> Function($$GoalContributionsTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalContributions,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalContributionsTableFilterComposer(
            $db: $db,
            $table: $db.goalContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carryOverInCents => $composableBuilder(
    column: $table.carryOverInCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carryOverManualCents => $composableBuilder(
    column: $table.carryOverManualCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PeriodStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get carryOverInCents => $composableBuilder(
    column: $table.carryOverInCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get carryOverManualCents => $composableBuilder(
    column: $table.carryOverManualCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurrenceInstancesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceInstancesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceInstances,
          getReferencedColumn: (t) => t.periodId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> budgetsRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgets,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableAnnotationComposer(
            $db: $db,
            $table: $db.budgets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalContributionsRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributions,
          getReferencedColumn: (t) => t.periodId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$PeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeriodsTable,
          Period,
          $$PeriodsTableFilterComposer,
          $$PeriodsTableOrderingComposer,
          $$PeriodsTableAnnotationComposer,
          $$PeriodsTableCreateCompanionBuilder,
          $$PeriodsTableUpdateCompanionBuilder,
          (Period, $$PeriodsTableReferences),
          Period,
          PrefetchHooks Function({
            bool transactionsRefs,
            bool recurrenceInstancesRefs,
            bool budgetsRefs,
            bool goalContributionsRefs,
          })
        > {
  $$PeriodsTableTableManager(_$AppDatabase db, $PeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<PeriodStatus> status = const Value.absent(),
                Value<int> carryOverInCents = const Value.absent(),
                Value<int?> carryOverManualCents = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => PeriodsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                status: status,
                carryOverInCents: carryOverInCents,
                carryOverManualCents: carryOverManualCents,
                closedAt: closedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                required PeriodStatus status,
                Value<int> carryOverInCents = const Value.absent(),
                Value<int?> carryOverManualCents = const Value.absent(),
                Value<DateTime?> closedAt = const Value.absent(),
              }) => PeriodsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                status: status,
                carryOverInCents: carryOverInCents,
                carryOverManualCents: carryOverManualCents,
                closedAt: closedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsRefs = false,
                recurrenceInstancesRefs = false,
                budgetsRefs = false,
                goalContributionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsRefs) db.transactions,
                    if (recurrenceInstancesRefs) db.recurrenceInstances,
                    if (budgetsRefs) db.budgets,
                    if (goalContributionsRefs) db.goalContributions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsRefs)
                        await $_getPrefetchedData<Period, $PeriodsTable, Txn>(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._transactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurrenceInstancesRefs)
                        await $_getPrefetchedData<
                          Period,
                          $PeriodsTable,
                          RecurrenceInstance
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._recurrenceInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetsRefs)
                        await $_getPrefetchedData<
                          Period,
                          $PeriodsTable,
                          Budget
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._budgetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalContributionsRefs)
                        await $_getPrefetchedData<
                          Period,
                          $PeriodsTable,
                          GoalContribution
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._goalContributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalContributionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeriodsTable,
      Period,
      $$PeriodsTableFilterComposer,
      $$PeriodsTableOrderingComposer,
      $$PeriodsTableAnnotationComposer,
      $$PeriodsTableCreateCompanionBuilder,
      $$PeriodsTableUpdateCompanionBuilder,
      (Period, $$PeriodsTableReferences),
      Period,
      PrefetchHooks Function({
        bool transactionsRefs,
        bool recurrenceInstancesRefs,
        bool budgetsRefs,
        bool goalContributionsRefs,
      })
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required DateTime date,
      required TxnType type,
      required int amountCents,
      Value<int?> sharedTotalCents,
      Value<int?> categoryId,
      required int accountId,
      Value<int?> toAccountId,
      required int periodId,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<IncomeStatus?> incomeStatus,
      Value<int?> recurrenceId,
      Value<DateTime> createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<TxnType> type,
      Value<int> amountCents,
      Value<int?> sharedTotalCents,
      Value<int?> categoryId,
      Value<int> accountId,
      Value<int?> toAccountId,
      Value<int> periodId,
      Value<String?> note,
      Value<String?> receiptPath,
      Value<IncomeStatus?> incomeStatus,
      Value<int?> recurrenceId,
      Value<DateTime> createdAt,
    });

final class $$TransactionsTableReferences
    extends BaseReferences<_$AppDatabase, $TransactionsTable, Txn> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('transactions__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _toAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('transactions__to_account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get toAccountId {
    final $_column = $_itemColumn<int>('to_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('transactions__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecurrenceInstancesTable,
    List<RecurrenceInstance>
  >
  _recurrenceInstancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceInstances,
        aliasName: 'transactions__id__recurrence_instances__transaction_id',
      );

  $$RecurrenceInstancesTableProcessedTableManager get recurrenceInstancesRefs {
    final manager = $$RecurrenceInstancesTableTableManager(
      $_db,
      $_db.recurrenceInstances,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DebtPaymentsTable, List<DebtPayment>>
  _debtPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.debtPayments,
    aliasName: 'transactions__id__debt_payments__transaction_id',
  );

  $$DebtPaymentsTableProcessedTableManager get debtPaymentsRefs {
    final manager = $$DebtPaymentsTableTableManager(
      $_db,
      $_db.debtPayments,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnType, TxnType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sharedTotalCents => $composableBuilder(
    column: $table.sharedTotalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IncomeStatus?, IncomeStatus, String>
  get incomeStatus => $composableBuilder(
    column: $table.incomeStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get recurrenceId => $composableBuilder(
    column: $table.recurrenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get toAccountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recurrenceInstancesRefs(
    Expression<bool> Function($$RecurrenceInstancesTableFilterComposer f) f,
  ) {
    final $$RecurrenceInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrenceInstances,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceInstancesTableFilterComposer(
            $db: $db,
            $table: $db.recurrenceInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> debtPaymentsRefs(
    Expression<bool> Function($$DebtPaymentsTableFilterComposer f) f,
  ) {
    final $$DebtPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtPayments,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.debtPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sharedTotalCents => $composableBuilder(
    column: $table.sharedTotalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get incomeStatus => $composableBuilder(
    column: $table.incomeStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrenceId => $composableBuilder(
    column: $table.recurrenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get toAccountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sharedTotalCents => $composableBuilder(
    column: $table.sharedTotalCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<IncomeStatus?, String> get incomeStatus =>
      $composableBuilder(
        column: $table.incomeStatus,
        builder: (column) => column,
      );

  GeneratedColumn<int> get recurrenceId => $composableBuilder(
    column: $table.recurrenceId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get toAccountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toAccountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recurrenceInstancesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceInstancesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceInstances,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> debtPaymentsRefs<T extends Object>(
    Expression<T> Function($$DebtPaymentsTableAnnotationComposer a) f,
  ) {
    final $$DebtPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtPayments,
      getReferencedColumn: (t) => t.transactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.debtPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Txn,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (Txn, $$TransactionsTableReferences),
          Txn,
          PrefetchHooks Function({
            bool categoryId,
            bool accountId,
            bool toAccountId,
            bool periodId,
            bool recurrenceInstancesRefs,
            bool debtPaymentsRefs,
          })
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int?> sharedTotalCents = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int?> toAccountId = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<IncomeStatus?> incomeStatus = const Value.absent(),
                Value<int?> recurrenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                date: date,
                type: type,
                amountCents: amountCents,
                sharedTotalCents: sharedTotalCents,
                categoryId: categoryId,
                accountId: accountId,
                toAccountId: toAccountId,
                periodId: periodId,
                note: note,
                receiptPath: receiptPath,
                incomeStatus: incomeStatus,
                recurrenceId: recurrenceId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required TxnType type,
                required int amountCents,
                Value<int?> sharedTotalCents = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                required int accountId,
                Value<int?> toAccountId = const Value.absent(),
                required int periodId,
                Value<String?> note = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<IncomeStatus?> incomeStatus = const Value.absent(),
                Value<int?> recurrenceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                date: date,
                type: type,
                amountCents: amountCents,
                sharedTotalCents: sharedTotalCents,
                categoryId: categoryId,
                accountId: accountId,
                toAccountId: toAccountId,
                periodId: periodId,
                note: note,
                receiptPath: receiptPath,
                incomeStatus: incomeStatus,
                recurrenceId: recurrenceId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                accountId = false,
                toAccountId = false,
                periodId = false,
                recurrenceInstancesRefs = false,
                debtPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurrenceInstancesRefs) db.recurrenceInstances,
                    if (debtPaymentsRefs) db.debtPayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toAccountId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._toAccountIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._toAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (periodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.periodId,
                                    referencedTable:
                                        $$TransactionsTableReferences
                                            ._periodIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableReferences
                                            ._periodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurrenceInstancesRefs)
                        await $_getPrefetchedData<
                          Txn,
                          $TransactionsTable,
                          RecurrenceInstance
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._recurrenceInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (debtPaymentsRefs)
                        await $_getPrefetchedData<
                          Txn,
                          $TransactionsTable,
                          DebtPayment
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableReferences
                              ._debtPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableReferences(
                                db,
                                table,
                                p0,
                              ).debtPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Txn,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (Txn, $$TransactionsTableReferences),
      Txn,
      PrefetchHooks Function({
        bool categoryId,
        bool accountId,
        bool toAccountId,
        bool periodId,
        bool recurrenceInstancesRefs,
        bool debtPaymentsRefs,
      })
    >;
typedef $$DebtsTableCreateCompanionBuilder =
    DebtsCompanion Function({
      Value<int> id,
      required String name,
      required DebtKind kind,
      required int principalCents,
      required int remainingCents,
      Value<int> installmentCents,
      Value<int?> installmentsTotal,
      Value<int> installmentsPaid,
      Value<int> annualRateBps,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> settled,
    });
typedef $$DebtsTableUpdateCompanionBuilder =
    DebtsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DebtKind> kind,
      Value<int> principalCents,
      Value<int> remainingCents,
      Value<int> installmentCents,
      Value<int?> installmentsTotal,
      Value<int> installmentsPaid,
      Value<int> annualRateBps,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> settled,
    });

final class $$DebtsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtsTable, Debt> {
  $$DebtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurrencesTable, List<Recurrence>>
  _recurrencesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurrences,
    aliasName: 'debts__id__recurrences__debt_id',
  );

  $$RecurrencesTableProcessedTableManager get recurrencesRefs {
    final manager = $$RecurrencesTableTableManager(
      $_db,
      $_db.recurrences,
    ).filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurrencesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DebtPaymentsTable, List<DebtPayment>>
  _debtPaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.debtPayments,
    aliasName: 'debts__id__debt_payments__debt_id',
  );

  $$DebtPaymentsTableProcessedTableManager get debtPaymentsRefs {
    final manager = $$DebtPaymentsTableTableManager(
      $_db,
      $_db.debtPayments,
    ).filter((f) => f.debtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_debtPaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DebtsTableFilterComposer extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DebtKind, DebtKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingCents => $composableBuilder(
    column: $table.remainingCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentCents => $composableBuilder(
    column: $table.installmentCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentsTotal => $composableBuilder(
    column: $table.installmentsTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get annualRateBps => $composableBuilder(
    column: $table.annualRateBps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get settled => $composableBuilder(
    column: $table.settled,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurrencesRefs(
    Expression<bool> Function($$RecurrencesTableFilterComposer f) f,
  ) {
    final $$RecurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableFilterComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> debtPaymentsRefs(
    Expression<bool> Function($$DebtPaymentsTableFilterComposer f) f,
  ) {
    final $$DebtPaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtPayments,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtPaymentsTableFilterComposer(
            $db: $db,
            $table: $db.debtPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DebtsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingCents => $composableBuilder(
    column: $table.remainingCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentCents => $composableBuilder(
    column: $table.installmentCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentsTotal => $composableBuilder(
    column: $table.installmentsTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get annualRateBps => $composableBuilder(
    column: $table.annualRateBps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get settled => $composableBuilder(
    column: $table.settled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtsTable> {
  $$DebtsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DebtKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingCents => $composableBuilder(
    column: $table.remainingCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentCents => $composableBuilder(
    column: $table.installmentCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentsTotal => $composableBuilder(
    column: $table.installmentsTotal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentsPaid => $composableBuilder(
    column: $table.installmentsPaid,
    builder: (column) => column,
  );

  GeneratedColumn<int> get annualRateBps => $composableBuilder(
    column: $table.annualRateBps,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get settled =>
      $composableBuilder(column: $table.settled, builder: (column) => column);

  Expression<T> recurrencesRefs<T extends Object>(
    Expression<T> Function($$RecurrencesTableAnnotationComposer a) f,
  ) {
    final $$RecurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> debtPaymentsRefs<T extends Object>(
    Expression<T> Function($$DebtPaymentsTableAnnotationComposer a) f,
  ) {
    final $$DebtPaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.debtPayments,
      getReferencedColumn: (t) => t.debtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtPaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.debtPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DebtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtsTable,
          Debt,
          $$DebtsTableFilterComposer,
          $$DebtsTableOrderingComposer,
          $$DebtsTableAnnotationComposer,
          $$DebtsTableCreateCompanionBuilder,
          $$DebtsTableUpdateCompanionBuilder,
          (Debt, $$DebtsTableReferences),
          Debt,
          PrefetchHooks Function({bool recurrencesRefs, bool debtPaymentsRefs})
        > {
  $$DebtsTableTableManager(_$AppDatabase db, $DebtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DebtKind> kind = const Value.absent(),
                Value<int> principalCents = const Value.absent(),
                Value<int> remainingCents = const Value.absent(),
                Value<int> installmentCents = const Value.absent(),
                Value<int?> installmentsTotal = const Value.absent(),
                Value<int> installmentsPaid = const Value.absent(),
                Value<int> annualRateBps = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> settled = const Value.absent(),
              }) => DebtsCompanion(
                id: id,
                name: name,
                kind: kind,
                principalCents: principalCents,
                remainingCents: remainingCents,
                installmentCents: installmentCents,
                installmentsTotal: installmentsTotal,
                installmentsPaid: installmentsPaid,
                annualRateBps: annualRateBps,
                startDate: startDate,
                endDate: endDate,
                settled: settled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DebtKind kind,
                required int principalCents,
                required int remainingCents,
                Value<int> installmentCents = const Value.absent(),
                Value<int?> installmentsTotal = const Value.absent(),
                Value<int> installmentsPaid = const Value.absent(),
                Value<int> annualRateBps = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> settled = const Value.absent(),
              }) => DebtsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                principalCents: principalCents,
                remainingCents: remainingCents,
                installmentCents: installmentCents,
                installmentsTotal: installmentsTotal,
                installmentsPaid: installmentsPaid,
                annualRateBps: annualRateBps,
                startDate: startDate,
                endDate: endDate,
                settled: settled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$DebtsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({recurrencesRefs = false, debtPaymentsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurrencesRefs) db.recurrences,
                    if (debtPaymentsRefs) db.debtPayments,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurrencesRefs)
                        await $_getPrefetchedData<
                          Debt,
                          $DebtsTable,
                          Recurrence
                        >(
                          currentTable: table,
                          referencedTable: $$DebtsTableReferences
                              ._recurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DebtsTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrencesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.debtId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (debtPaymentsRefs)
                        await $_getPrefetchedData<
                          Debt,
                          $DebtsTable,
                          DebtPayment
                        >(
                          currentTable: table,
                          referencedTable: $$DebtsTableReferences
                              ._debtPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DebtsTableReferences(
                                db,
                                table,
                                p0,
                              ).debtPaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.debtId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DebtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtsTable,
      Debt,
      $$DebtsTableFilterComposer,
      $$DebtsTableOrderingComposer,
      $$DebtsTableAnnotationComposer,
      $$DebtsTableCreateCompanionBuilder,
      $$DebtsTableUpdateCompanionBuilder,
      (Debt, $$DebtsTableReferences),
      Debt,
      PrefetchHooks Function({bool recurrencesRefs, bool debtPaymentsRefs})
    >;
typedef $$RecurrencesTableCreateCompanionBuilder =
    RecurrencesCompanion Function({
      Value<int> id,
      required String name,
      required TxnType type,
      required RecurrenceNature nature,
      Value<int?> categoryId,
      required int accountId,
      required int estimatedAmountCents,
      Value<bool> isVariable,
      required Frequency frequency,
      required int dueDayOfMonth,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> active,
      Value<int?> debtId,
    });
typedef $$RecurrencesTableUpdateCompanionBuilder =
    RecurrencesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<TxnType> type,
      Value<RecurrenceNature> nature,
      Value<int?> categoryId,
      Value<int> accountId,
      Value<int> estimatedAmountCents,
      Value<bool> isVariable,
      Value<Frequency> frequency,
      Value<int> dueDayOfMonth,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> active,
      Value<int?> debtId,
    });

final class $$RecurrencesTableReferences
    extends BaseReferences<_$AppDatabase, $RecurrencesTable, Recurrence> {
  $$RecurrencesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('recurrences__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('recurrences__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $DebtsTable _debtIdTable(_$AppDatabase db) =>
      db.debts.createAlias('recurrences__debt_id__debts__id');

  $$DebtsTableProcessedTableManager? get debtId {
    final $_column = $_itemColumn<int>('debt_id');
    if ($_column == null) return null;
    final manager = $$DebtsTableTableManager(
      $_db,
      $_db.debts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecurrenceInstancesTable,
    List<RecurrenceInstance>
  >
  _recurrenceInstancesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurrenceInstances,
        aliasName: 'recurrences__id__recurrence_instances__recurrence_id',
      );

  $$RecurrenceInstancesTableProcessedTableManager get recurrenceInstancesRefs {
    final manager = $$RecurrenceInstancesTableTableManager(
      $_db,
      $_db.recurrenceInstances,
    ).filter((f) => f.recurrenceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurrenceInstancesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurrencesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TxnType, TxnType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<RecurrenceNature, RecurrenceNature, String>
  get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVariable => $composableBuilder(
    column: $table.isVariable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Frequency, Frequency, String> get frequency =>
      $composableBuilder(
        column: $table.frequency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableFilterComposer get debtId {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableFilterComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recurrenceInstancesRefs(
    Expression<bool> Function($$RecurrenceInstancesTableFilterComposer f) f,
  ) {
    final $$RecurrenceInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrenceInstances,
      getReferencedColumn: (t) => t.recurrenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrenceInstancesTableFilterComposer(
            $db: $db,
            $table: $db.recurrenceInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurrencesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVariable => $composableBuilder(
    column: $table.isVariable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableOrderingComposer get debtId {
    final $$DebtsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableOrderingComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrencesTable> {
  $$RecurrencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TxnType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RecurrenceNature, String> get nature =>
      $composableBuilder(column: $table.nature, builder: (column) => column);

  GeneratedColumn<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVariable => $composableBuilder(
    column: $table.isVariable,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Frequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get dueDayOfMonth => $composableBuilder(
    column: $table.dueDayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$DebtsTableAnnotationComposer get debtId {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableAnnotationComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recurrenceInstancesRefs<T extends Object>(
    Expression<T> Function($$RecurrenceInstancesTableAnnotationComposer a) f,
  ) {
    final $$RecurrenceInstancesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurrenceInstances,
          getReferencedColumn: (t) => t.recurrenceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurrenceInstancesTableAnnotationComposer(
                $db: $db,
                $table: $db.recurrenceInstances,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurrencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrencesTable,
          Recurrence,
          $$RecurrencesTableFilterComposer,
          $$RecurrencesTableOrderingComposer,
          $$RecurrencesTableAnnotationComposer,
          $$RecurrencesTableCreateCompanionBuilder,
          $$RecurrencesTableUpdateCompanionBuilder,
          (Recurrence, $$RecurrencesTableReferences),
          Recurrence,
          PrefetchHooks Function({
            bool categoryId,
            bool accountId,
            bool debtId,
            bool recurrenceInstancesRefs,
          })
        > {
  $$RecurrencesTableTableManager(_$AppDatabase db, $RecurrencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<TxnType> type = const Value.absent(),
                Value<RecurrenceNature> nature = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> estimatedAmountCents = const Value.absent(),
                Value<bool> isVariable = const Value.absent(),
                Value<Frequency> frequency = const Value.absent(),
                Value<int> dueDayOfMonth = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int?> debtId = const Value.absent(),
              }) => RecurrencesCompanion(
                id: id,
                name: name,
                type: type,
                nature: nature,
                categoryId: categoryId,
                accountId: accountId,
                estimatedAmountCents: estimatedAmountCents,
                isVariable: isVariable,
                frequency: frequency,
                dueDayOfMonth: dueDayOfMonth,
                startDate: startDate,
                endDate: endDate,
                active: active,
                debtId: debtId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required TxnType type,
                required RecurrenceNature nature,
                Value<int?> categoryId = const Value.absent(),
                required int accountId,
                required int estimatedAmountCents,
                Value<bool> isVariable = const Value.absent(),
                required Frequency frequency,
                required int dueDayOfMonth,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int?> debtId = const Value.absent(),
              }) => RecurrencesCompanion.insert(
                id: id,
                name: name,
                type: type,
                nature: nature,
                categoryId: categoryId,
                accountId: accountId,
                estimatedAmountCents: estimatedAmountCents,
                isVariable: isVariable,
                frequency: frequency,
                dueDayOfMonth: dueDayOfMonth,
                startDate: startDate,
                endDate: endDate,
                active: active,
                debtId: debtId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurrencesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                accountId = false,
                debtId = false,
                recurrenceInstancesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurrenceInstancesRefs) db.recurrenceInstances,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecurrencesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecurrencesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$RecurrencesTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$RecurrencesTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (debtId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.debtId,
                                    referencedTable:
                                        $$RecurrencesTableReferences
                                            ._debtIdTable(db),
                                    referencedColumn:
                                        $$RecurrencesTableReferences
                                            ._debtIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurrenceInstancesRefs)
                        await $_getPrefetchedData<
                          Recurrence,
                          $RecurrencesTable,
                          RecurrenceInstance
                        >(
                          currentTable: table,
                          referencedTable: $$RecurrencesTableReferences
                              ._recurrenceInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurrencesTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrenceInstancesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recurrenceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurrencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrencesTable,
      Recurrence,
      $$RecurrencesTableFilterComposer,
      $$RecurrencesTableOrderingComposer,
      $$RecurrencesTableAnnotationComposer,
      $$RecurrencesTableCreateCompanionBuilder,
      $$RecurrencesTableUpdateCompanionBuilder,
      (Recurrence, $$RecurrencesTableReferences),
      Recurrence,
      PrefetchHooks Function({
        bool categoryId,
        bool accountId,
        bool debtId,
        bool recurrenceInstancesRefs,
      })
    >;
typedef $$RecurrenceInstancesTableCreateCompanionBuilder =
    RecurrenceInstancesCompanion Function({
      Value<int> id,
      Value<int?> recurrenceId,
      required int periodId,
      required String label,
      required DateTime dueDate,
      required int estimatedAmountCents,
      Value<int?> actualAmountCents,
      required InstanceStatus status,
      Value<DateTime?> paidDate,
      Value<int?> transactionId,
    });
typedef $$RecurrenceInstancesTableUpdateCompanionBuilder =
    RecurrenceInstancesCompanion Function({
      Value<int> id,
      Value<int?> recurrenceId,
      Value<int> periodId,
      Value<String> label,
      Value<DateTime> dueDate,
      Value<int> estimatedAmountCents,
      Value<int?> actualAmountCents,
      Value<InstanceStatus> status,
      Value<DateTime?> paidDate,
      Value<int?> transactionId,
    });

final class $$RecurrenceInstancesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurrenceInstancesTable,
          RecurrenceInstance
        > {
  $$RecurrenceInstancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecurrencesTable _recurrenceIdTable(_$AppDatabase db) => db
      .recurrences
      .createAlias('recurrence_instances__recurrence_id__recurrences__id');

  $$RecurrencesTableProcessedTableManager? get recurrenceId {
    final $_column = $_itemColumn<int>('recurrence_id');
    if ($_column == null) return null;
    final manager = $$RecurrencesTableTableManager(
      $_db,
      $_db.recurrences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurrenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('recurrence_instances__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('recurrence_instances__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurrenceInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceInstancesTable> {
  $$RecurrenceInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualAmountCents => $composableBuilder(
    column: $table.actualAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InstanceStatus, InstanceStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnFilters(column),
  );

  $$RecurrencesTableFilterComposer get recurrenceId {
    final $$RecurrencesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenceId,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableFilterComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceInstancesTable> {
  $$RecurrenceInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualAmountCents => $composableBuilder(
    column: $table.actualAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidDate => $composableBuilder(
    column: $table.paidDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecurrencesTableOrderingComposer get recurrenceId {
    final $$RecurrencesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenceId,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableOrderingComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceInstancesTable> {
  $$RecurrenceInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get estimatedAmountCents => $composableBuilder(
    column: $table.estimatedAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualAmountCents => $composableBuilder(
    column: $table.actualAmountCents,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InstanceStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get paidDate =>
      $composableBuilder(column: $table.paidDate, builder: (column) => column);

  $$RecurrencesTableAnnotationComposer get recurrenceId {
    final $$RecurrencesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenceId,
      referencedTable: $db.recurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrencesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrenceInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrenceInstancesTable,
          RecurrenceInstance,
          $$RecurrenceInstancesTableFilterComposer,
          $$RecurrenceInstancesTableOrderingComposer,
          $$RecurrenceInstancesTableAnnotationComposer,
          $$RecurrenceInstancesTableCreateCompanionBuilder,
          $$RecurrenceInstancesTableUpdateCompanionBuilder,
          (RecurrenceInstance, $$RecurrenceInstancesTableReferences),
          RecurrenceInstance,
          PrefetchHooks Function({
            bool recurrenceId,
            bool periodId,
            bool transactionId,
          })
        > {
  $$RecurrenceInstancesTableTableManager(
    _$AppDatabase db,
    $RecurrenceInstancesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrenceInstancesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurrenceInstancesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> recurrenceId = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<int> estimatedAmountCents = const Value.absent(),
                Value<int?> actualAmountCents = const Value.absent(),
                Value<InstanceStatus> status = const Value.absent(),
                Value<DateTime?> paidDate = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => RecurrenceInstancesCompanion(
                id: id,
                recurrenceId: recurrenceId,
                periodId: periodId,
                label: label,
                dueDate: dueDate,
                estimatedAmountCents: estimatedAmountCents,
                actualAmountCents: actualAmountCents,
                status: status,
                paidDate: paidDate,
                transactionId: transactionId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> recurrenceId = const Value.absent(),
                required int periodId,
                required String label,
                required DateTime dueDate,
                required int estimatedAmountCents,
                Value<int?> actualAmountCents = const Value.absent(),
                required InstanceStatus status,
                Value<DateTime?> paidDate = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
              }) => RecurrenceInstancesCompanion.insert(
                id: id,
                recurrenceId: recurrenceId,
                periodId: periodId,
                label: label,
                dueDate: dueDate,
                estimatedAmountCents: estimatedAmountCents,
                actualAmountCents: actualAmountCents,
                status: status,
                paidDate: paidDate,
                transactionId: transactionId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurrenceInstancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recurrenceId = false,
                periodId = false,
                transactionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recurrenceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurrenceId,
                                    referencedTable:
                                        $$RecurrenceInstancesTableReferences
                                            ._recurrenceIdTable(db),
                                    referencedColumn:
                                        $$RecurrenceInstancesTableReferences
                                            ._recurrenceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (periodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.periodId,
                                    referencedTable:
                                        $$RecurrenceInstancesTableReferences
                                            ._periodIdTable(db),
                                    referencedColumn:
                                        $$RecurrenceInstancesTableReferences
                                            ._periodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (transactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.transactionId,
                                    referencedTable:
                                        $$RecurrenceInstancesTableReferences
                                            ._transactionIdTable(db),
                                    referencedColumn:
                                        $$RecurrenceInstancesTableReferences
                                            ._transactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecurrenceInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrenceInstancesTable,
      RecurrenceInstance,
      $$RecurrenceInstancesTableFilterComposer,
      $$RecurrenceInstancesTableOrderingComposer,
      $$RecurrenceInstancesTableAnnotationComposer,
      $$RecurrenceInstancesTableCreateCompanionBuilder,
      $$RecurrenceInstancesTableUpdateCompanionBuilder,
      (RecurrenceInstance, $$RecurrenceInstancesTableReferences),
      RecurrenceInstance,
      PrefetchHooks Function({
        bool recurrenceId,
        bool periodId,
        bool transactionId,
      })
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      required int periodId,
      required int categoryId,
      required int limitCents,
      Value<bool> rollover,
      Value<int> rolloverInCents,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> id,
      Value<int> periodId,
      Value<int> categoryId,
      Value<int> limitCents,
      Value<bool> rollover,
      Value<int> rolloverInCents,
    });

final class $$BudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTable, Budget> {
  $$BudgetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('budgets__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('budgets__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rolloverInCents => $composableBuilder(
    column: $table.rolloverInCents,
    builder: (column) => ColumnFilters(column),
  );

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rollover => $composableBuilder(
    column: $table.rollover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rolloverInCents => $composableBuilder(
    column: $table.rolloverInCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get limitCents => $composableBuilder(
    column: $table.limitCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get rollover =>
      $composableBuilder(column: $table.rollover, builder: (column) => column);

  GeneratedColumn<int> get rolloverInCents => $composableBuilder(
    column: $table.rolloverInCents,
    builder: (column) => column,
  );

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, $$BudgetsTableReferences),
          Budget,
          PrefetchHooks Function({bool periodId, bool categoryId})
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> limitCents = const Value.absent(),
                Value<bool> rollover = const Value.absent(),
                Value<int> rolloverInCents = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                periodId: periodId,
                categoryId: categoryId,
                limitCents: limitCents,
                rollover: rollover,
                rolloverInCents: rolloverInCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int periodId,
                required int categoryId,
                required int limitCents,
                Value<bool> rollover = const Value.absent(),
                Value<int> rolloverInCents = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                periodId: periodId,
                categoryId: categoryId,
                limitCents: limitCents,
                rollover: rollover,
                rolloverInCents: rolloverInCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({periodId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (periodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.periodId,
                                referencedTable: $$BudgetsTableReferences
                                    ._periodIdTable(db),
                                referencedColumn: $$BudgetsTableReferences
                                    ._periodIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$BudgetsTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$BudgetsTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, $$BudgetsTableReferences),
      Budget,
      PrefetchHooks Function({bool periodId, bool categoryId})
    >;
typedef $$SavingsGoalsTableCreateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      required String name,
      required int targetCents,
      Value<DateTime?> targetDate,
      Value<int?> accountId,
      Value<int> monthlyPlannedCents,
      Value<String> iconKey,
      Value<bool> archived,
    });
typedef $$SavingsGoalsTableUpdateCompanionBuilder =
    SavingsGoalsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> targetCents,
      Value<DateTime?> targetDate,
      Value<int?> accountId,
      Value<int> monthlyPlannedCents,
      Value<String> iconKey,
      Value<bool> archived,
    });

final class $$SavingsGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $SavingsGoalsTable, SavingsGoal> {
  $$SavingsGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('savings_goals__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GoalContributionsTable, List<GoalContribution>>
  _goalContributionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributions,
        aliasName: 'savings_goals__id__goal_contributions__goal_id',
      );

  $$GoalContributionsTableProcessedTableManager get goalContributionsRefs {
    final manager = $$GoalContributionsTableTableManager(
      $_db,
      $_db.goalContributions,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingsGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyPlannedCents => $composableBuilder(
    column: $table.monthlyPlannedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> goalContributionsRefs(
    Expression<bool> Function($$GoalContributionsTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalContributions,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalContributionsTableFilterComposer(
            $db: $db,
            $table: $db.goalContributions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SavingsGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyPlannedCents => $composableBuilder(
    column: $table.monthlyPlannedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingsGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTable> {
  $$SavingsGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetCents => $composableBuilder(
    column: $table.targetCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyPlannedCents => $composableBuilder(
    column: $table.monthlyPlannedCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> goalContributionsRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributions,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTable,
          SavingsGoal,
          $$SavingsGoalsTableFilterComposer,
          $$SavingsGoalsTableOrderingComposer,
          $$SavingsGoalsTableAnnotationComposer,
          $$SavingsGoalsTableCreateCompanionBuilder,
          $$SavingsGoalsTableUpdateCompanionBuilder,
          (SavingsGoal, $$SavingsGoalsTableReferences),
          SavingsGoal,
          PrefetchHooks Function({bool accountId, bool goalContributionsRefs})
        > {
  $$SavingsGoalsTableTableManager(_$AppDatabase db, $SavingsGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> targetCents = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int> monthlyPlannedCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsCompanion(
                id: id,
                name: name,
                targetCents: targetCents,
                targetDate: targetDate,
                accountId: accountId,
                monthlyPlannedCents: monthlyPlannedCents,
                iconKey: iconKey,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int targetCents,
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int> monthlyPlannedCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => SavingsGoalsCompanion.insert(
                id: id,
                name: name,
                targetCents: targetCents,
                targetDate: targetDate,
                accountId: accountId,
                monthlyPlannedCents: monthlyPlannedCents,
                iconKey: iconKey,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavingsGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, goalContributionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (goalContributionsRefs) db.goalContributions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$SavingsGoalsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$SavingsGoalsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (goalContributionsRefs)
                        await $_getPrefetchedData<
                          SavingsGoal,
                          $SavingsGoalsTable,
                          GoalContribution
                        >(
                          currentTable: table,
                          referencedTable: $$SavingsGoalsTableReferences
                              ._goalContributionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SavingsGoalsTableReferences(
                                db,
                                table,
                                p0,
                              ).goalContributionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SavingsGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTable,
      SavingsGoal,
      $$SavingsGoalsTableFilterComposer,
      $$SavingsGoalsTableOrderingComposer,
      $$SavingsGoalsTableAnnotationComposer,
      $$SavingsGoalsTableCreateCompanionBuilder,
      $$SavingsGoalsTableUpdateCompanionBuilder,
      (SavingsGoal, $$SavingsGoalsTableReferences),
      SavingsGoal,
      PrefetchHooks Function({bool accountId, bool goalContributionsRefs})
    >;
typedef $$GoalContributionsTableCreateCompanionBuilder =
    GoalContributionsCompanion Function({
      Value<int> id,
      required int goalId,
      required int periodId,
      required int amountCents,
      required DateTime date,
    });
typedef $$GoalContributionsTableUpdateCompanionBuilder =
    GoalContributionsCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<int> periodId,
      Value<int> amountCents,
      Value<DateTime> date,
    });

final class $$GoalContributionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution
        > {
  $$GoalContributionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SavingsGoalsTable _goalIdTable(_$AppDatabase db) => db.savingsGoals
      .createAlias('goal_contributions__goal_id__savings_goals__id');

  $$SavingsGoalsTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<int>('goal_id')!;

    final manager = $$SavingsGoalsTableTableManager(
      $_db,
      $_db.savingsGoals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('goal_contributions__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$SavingsGoalsTableFilterComposer get goalId {
    final $$SavingsGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavingsGoalsTableOrderingComposer get goalId {
    final $$SavingsGoalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableOrderingComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$SavingsGoalsTableAnnotationComposer get goalId {
    final $$SavingsGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.savingsGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution,
          $$GoalContributionsTableFilterComposer,
          $$GoalContributionsTableOrderingComposer,
          $$GoalContributionsTableAnnotationComposer,
          $$GoalContributionsTableCreateCompanionBuilder,
          $$GoalContributionsTableUpdateCompanionBuilder,
          (GoalContribution, $$GoalContributionsTableReferences),
          GoalContribution,
          PrefetchHooks Function({bool goalId, bool periodId})
        > {
  $$GoalContributionsTableTableManager(
    _$AppDatabase db,
    $GoalContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => GoalContributionsCompanion(
                id: id,
                goalId: goalId,
                periodId: periodId,
                amountCents: amountCents,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required int periodId,
                required int amountCents,
                required DateTime date,
              }) => GoalContributionsCompanion.insert(
                id: id,
                goalId: goalId,
                periodId: periodId,
                amountCents: amountCents,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalContributionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false, periodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable:
                                    $$GoalContributionsTableReferences
                                        ._goalIdTable(db),
                                referencedColumn:
                                    $$GoalContributionsTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (periodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.periodId,
                                referencedTable:
                                    $$GoalContributionsTableReferences
                                        ._periodIdTable(db),
                                referencedColumn:
                                    $$GoalContributionsTableReferences
                                        ._periodIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalContributionsTable,
      GoalContribution,
      $$GoalContributionsTableFilterComposer,
      $$GoalContributionsTableOrderingComposer,
      $$GoalContributionsTableAnnotationComposer,
      $$GoalContributionsTableCreateCompanionBuilder,
      $$GoalContributionsTableUpdateCompanionBuilder,
      (GoalContribution, $$GoalContributionsTableReferences),
      GoalContribution,
      PrefetchHooks Function({bool goalId, bool periodId})
    >;
typedef $$DebtPaymentsTableCreateCompanionBuilder =
    DebtPaymentsCompanion Function({
      Value<int> id,
      required int debtId,
      Value<int?> transactionId,
      required DateTime date,
      required int amountCents,
      required int principalCents,
      Value<int> interestCents,
    });
typedef $$DebtPaymentsTableUpdateCompanionBuilder =
    DebtPaymentsCompanion Function({
      Value<int> id,
      Value<int> debtId,
      Value<int?> transactionId,
      Value<DateTime> date,
      Value<int> amountCents,
      Value<int> principalCents,
      Value<int> interestCents,
    });

final class $$DebtPaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $DebtPaymentsTable, DebtPayment> {
  $$DebtPaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DebtsTable _debtIdTable(_$AppDatabase db) =>
      db.debts.createAlias('debt_payments__debt_id__debts__id');

  $$DebtsTableProcessedTableManager get debtId {
    final $_column = $_itemColumn<int>('debt_id')!;

    final manager = $$DebtsTableTableManager(
      $_db,
      $_db.debts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_debtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) => db
      .transactions
      .createAlias('debt_payments__transaction_id__transactions__id');

  $$TransactionsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableManager(
      $_db,
      $_db.transactions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DebtPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get interestCents => $composableBuilder(
    column: $table.interestCents,
    builder: (column) => ColumnFilters(column),
  );

  $$DebtsTableFilterComposer get debtId {
    final $$DebtsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableFilterComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableFilterComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interestCents => $composableBuilder(
    column: $table.interestCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$DebtsTableOrderingComposer get debtId {
    final $$DebtsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableOrderingComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableOrderingComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtPaymentsTable> {
  $$DebtPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get principalCents => $composableBuilder(
    column: $table.principalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get interestCents => $composableBuilder(
    column: $table.interestCents,
    builder: (column) => column,
  );

  $$DebtsTableAnnotationComposer get debtId {
    final $$DebtsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.debtId,
      referencedTable: $db.debts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DebtsTableAnnotationComposer(
            $db: $db,
            $table: $db.debts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableAnnotationComposer(
            $db: $db,
            $table: $db.transactions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DebtPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtPaymentsTable,
          DebtPayment,
          $$DebtPaymentsTableFilterComposer,
          $$DebtPaymentsTableOrderingComposer,
          $$DebtPaymentsTableAnnotationComposer,
          $$DebtPaymentsTableCreateCompanionBuilder,
          $$DebtPaymentsTableUpdateCompanionBuilder,
          (DebtPayment, $$DebtPaymentsTableReferences),
          DebtPayment,
          PrefetchHooks Function({bool debtId, bool transactionId})
        > {
  $$DebtPaymentsTableTableManager(_$AppDatabase db, $DebtPaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> debtId = const Value.absent(),
                Value<int?> transactionId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> principalCents = const Value.absent(),
                Value<int> interestCents = const Value.absent(),
              }) => DebtPaymentsCompanion(
                id: id,
                debtId: debtId,
                transactionId: transactionId,
                date: date,
                amountCents: amountCents,
                principalCents: principalCents,
                interestCents: interestCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int debtId,
                Value<int?> transactionId = const Value.absent(),
                required DateTime date,
                required int amountCents,
                required int principalCents,
                Value<int> interestCents = const Value.absent(),
              }) => DebtPaymentsCompanion.insert(
                id: id,
                debtId: debtId,
                transactionId: transactionId,
                date: date,
                amountCents: amountCents,
                principalCents: principalCents,
                interestCents: interestCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DebtPaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({debtId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (debtId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.debtId,
                                referencedTable: $$DebtPaymentsTableReferences
                                    ._debtIdTable(db),
                                referencedColumn: $$DebtPaymentsTableReferences
                                    ._debtIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable: $$DebtPaymentsTableReferences
                                    ._transactionIdTable(db),
                                referencedColumn: $$DebtPaymentsTableReferences
                                    ._transactionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DebtPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtPaymentsTable,
      DebtPayment,
      $$DebtPaymentsTableFilterComposer,
      $$DebtPaymentsTableOrderingComposer,
      $$DebtPaymentsTableAnnotationComposer,
      $$DebtPaymentsTableCreateCompanionBuilder,
      $$DebtPaymentsTableUpdateCompanionBuilder,
      (DebtPayment, $$DebtPaymentsTableReferences),
      DebtPayment,
      PrefetchHooks Function({bool debtId, bool transactionId})
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      required String label,
      Value<int?> categoryId,
      Value<int?> accountId,
      Value<int?> amountCents,
      Value<String> iconKey,
      Value<int?> colorValue,
      Value<int> sortOrder,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<int> id,
      Value<String> label,
      Value<int?> categoryId,
      Value<int?> accountId,
      Value<int?> amountCents,
      Value<String> iconKey,
      Value<int?> colorValue,
      Value<int> sortOrder,
    });

final class $$FavoritesTableReferences
    extends BaseReferences<_$AppDatabase, $FavoritesTable, Favorite> {
  $$FavoritesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('favorites__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('favorites__account_id__accounts__id');

  $$AccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<int>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconKey => $composableBuilder(
    column: $table.iconKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconKey =>
      $composableBuilder(column: $table.iconKey, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, $$FavoritesTableReferences),
          Favorite,
          PrefetchHooks Function({bool categoryId, bool accountId})
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FavoritesCompanion(
                id: id,
                label: label,
                categoryId: categoryId,
                accountId: accountId,
                amountCents: amountCents,
                iconKey: iconKey,
                colorValue: colorValue,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String label,
                Value<int?> categoryId = const Value.absent(),
                Value<int?> accountId = const Value.absent(),
                Value<int?> amountCents = const Value.absent(),
                Value<String> iconKey = const Value.absent(),
                Value<int?> colorValue = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => FavoritesCompanion.insert(
                id: id,
                label: label,
                categoryId: categoryId,
                accountId: accountId,
                amountCents: amountCents,
                iconKey: iconKey,
                colorValue: colorValue,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoritesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable: $$FavoritesTableReferences
                                    ._categoryIdTable(db),
                                referencedColumn: $$FavoritesTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$FavoritesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$FavoritesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, $$FavoritesTableReferences),
      Favorite,
      PrefetchHooks Function({bool categoryId, bool accountId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
  $$PeriodsTableTableManager get periods =>
      $$PeriodsTableTableManager(_db, _db.periods);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db, _db.debts);
  $$RecurrencesTableTableManager get recurrences =>
      $$RecurrencesTableTableManager(_db, _db.recurrences);
  $$RecurrenceInstancesTableTableManager get recurrenceInstances =>
      $$RecurrenceInstancesTableTableManager(_db, _db.recurrenceInstances);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db, _db.savingsGoals);
  $$GoalContributionsTableTableManager get goalContributions =>
      $$GoalContributionsTableTableManager(_db, _db.goalContributions);
  $$DebtPaymentsTableTableManager get debtPayments =>
      $$DebtPaymentsTableTableManager(_db, _db.debtPayments);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
}
