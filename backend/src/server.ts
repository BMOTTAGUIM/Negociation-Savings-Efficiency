import Fastify from 'fastify';
import pg from 'pg';

const server = Fastify({ logger: true });
const port = Number(process.env.PORT ?? 3000);
const databaseUrl = process.env.DATABASE_URL;
const pool = databaseUrl ? new pg.Pool({ connectionString: databaseUrl }) : null;

server.get('/health', async () => ({
  status: 'ok',
  service: 'negotiation-savings-backend',
  database: pool ? 'configured' : 'not-configured'
}));

server.addHook('onClose', async () => {
  await pool?.end();
});

server.listen({ port, host: '127.0.0.1' }).catch(async (error) => {
  server.log.error(error);
  await pool?.end();
  process.exit(1);
});
