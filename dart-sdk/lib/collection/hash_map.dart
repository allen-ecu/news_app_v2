// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of dart.collection;

class _HashMapTable<K, V> extends _HashTable<K> {
  static const int _INITIAL_CAPACITY = 8;
  static const int _VALUE_INDEX = 1;

  _HashMapTable() : super(_INITIAL_CAPACITY);

  int get _entrySize => 2;

  V _value(int offset) => _table[offset + _VALUE_INDEX];
  void _setValue(int offset, V value) { _table[offset + _VALUE_INDEX] = value; }

  _copyEntry(List fromTable, int fromOffset, int toOffset) {
    _table[toOffset + _VALUE_INDEX] = fromTable[fromOffset + _VALUE_INDEX];
  }
}

class HashMap<K, V> implements Map<K, V> {
  final _HashMapTable<K, V> _hashTable;

  HashMap() : _hashTable = new _HashMapTable<K, V>() {
    _hashTable._container = this;
  }

  factory HashMap.from(Map<K, V> other) {
    return new HashMap<K, V>()..addAll(other);
  }

  bool containsKey(K key) {
    return _hashTable._get(key) >= 0;
  }

  bool containsValue(V value) {
    List table = _hashTable._table;
    int entrySize = _hashTable._entrySize;
    for (int offset = 0; offset < table.length; offset += entrySize) {
      if (!_hashTable._isFree(table[offset]) &&
          _hashTable._value(offset) == value) {
        return true;
      }
    }
    return false;
  }

  void addAll(Map<K, V> other) {
    other.forEach((K key, V value) {
      int offset = _hashTable._put(key);
      _hashTable._setValue(offset, value);
      _hashTable._checkCapacity();
    });
  }

  V operator [](K key) {
    int offset = _hashTable._get(key);
    if (offset >= 0) return _hashTable._value(offset);
    return null;
  }

  void operator []=(K key, V value) {
    int offset = _hashTable._put(key);
    _hashTable._setValue(offset, value);
    _hashTable._checkCapacity();
  }

  V putIfAbsent(K key, V ifAbsent()) {
    int offset = _hashTable._probeForAdd(_hashTable._hashCodeOf(key), key);
    Object entry = _hashTable._table[offset];
    if (!_hashTable._isFree(entry)) {
      return _hashTable._value(offset);
    }
    int modificationCount = _hashTable._modificationCount;
    V value = ifAbsent();
    if (modificationCount == _hashTable._modificationCount) {
      _hashTable._setKey(offset, key);
      _hashTable._setValue(offset, value);
      if (entry == null) {
        _hashTable._entryCount++;
        _hashTable._checkCapacity();
      } else {
        assert(identical(entry, _TOMBSTONE));
        _hashTable._deletedCount--;
      }
      _hashTable._recordModification();
    } else {
      // The table might have changed, so we can't trust [offset] any more.
      // Do another lookup before setting the value.
      offset = _hashTable._put(key);
      _hashTable._setValue(offset, value);
      _hashTable._checkCapacity();
    }
    return value;
  }

  V remove(K key) {
    int offset = _hashTable._remove(key);
    if (offset < 0) return null;
    V oldValue = _hashTable._value(offset);
    _hashTable._setValue(offset, null);
    _hashTable._checkCapacity();
    return oldValue;
  }

  void clear() {
    _hashTable._clear();
  }

  void forEach(void action (K key, V value)) {
    int modificationCount = _hashTable._modificationCount;
    List table = _hashTable._table;
    int entrySize = _hashTable._entrySize;
    for (int offset = 0; offset < table.length; offset += entrySize) {
      Object entry = table[offset];
      if (!_hashTable._isFree(entry)) {
        K key = entry;
        V value = _hashTable._value(offset);
        action(key, value);
        _hashTable._checkModification(modificationCount);
      }
    }
  }

  Iterable<K> get keys => new _HashTableKeyIterable<K>(_hashTable);
  Iterable<V> get values =>
      new _HashTableValueIterable<V>(_hashTable, _HashMapTable._VALUE_INDEX);

  int get length => _hashTable._elementCount;

  bool get isEmpty => _hashTable._elementCount == 0;

  String toString() => Maps.mapToString(this);
}
