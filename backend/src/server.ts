import Fastify from 'fastify';

const server = Fastify({ logger: true });
const port = Number(process.env.PORT ?? 3000);

server.get('/health', async () => ({
  status: 'ok',
  service: 'negotiation-savings-backend'
}));

server.listen({ port, host: '127.0.0.1' }).catch((error) => {
  server.log.error(error);
  process.exit(1);
});
