import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';

const schema = readFileSync(new URL('../schema.sql', import.meta.url), 'utf8');

function hasCreateTable(tableName) {
  return new RegExp(`CREATE TABLE IF NOT EXISTS\\s+${tableName}\\s*\\(`, 'i').test(schema);
}

function hasColumn(tableName, columnName) {
  const tableRe = new RegExp(`CREATE TABLE IF NOT EXISTS\\s+${tableName}\\s*\\(([^;]+)\\);`, 'is');
  const match = schema.match(tableRe);
  if (!match) return false;
  return new RegExp(`\\b${columnName}\\b`, 'i').test(match[1]);
}

test('schema contains tables used by API', () => {
  ['Users', 'Sites', 'ReadingRecords', 'Snippets', 'Announcements'].forEach((name) => {
    assert.equal(hasCreateTable(name), true, `${name} table should exist`);
  });
});

test('schema contains columns required by API queries', () => {
  assert.equal(hasColumn('Users', 'status'), true);
  assert.equal(hasColumn('Snippets', 'chapter_id'), true);
  assert.equal(hasColumn('Snippets', 'position'), true);
  assert.equal(hasColumn('Announcements', 'is_read'), true);
});
