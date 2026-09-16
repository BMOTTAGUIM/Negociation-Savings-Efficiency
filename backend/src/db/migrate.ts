import { readFile } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import pg from 'pg';

const { Client } = pg;
const databaseUrl = process.env.DATABASE_URL;

if (!databaseUrl) {
  throw new Error('DATABASE_URL is required to run database migrations.');
}

const currentDirectory = dirname(fileURLToPath(import.meta.url));
const schemaPath = resolve(currentDirectory, 'schema.sql');
const schema = await readFile(schemaPath, 'utf8');
const client = new Client({ connectionString: databaseUrl });

try {
  await client.connect();
  await client.query('BEGIN');
  await client.query(schema);
  await client.query('COMMIT');
  console.log('Database schema applied successfully.');
} catch (error) {
  await client.query('ROLLBACK').catch(() => undefined);
  throw error;
} finally {
  await client.end();
}
