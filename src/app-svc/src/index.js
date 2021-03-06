import http from 'http';
import path from 'path';
import tooBusy from 'toobusy-js';
import express from 'express';
import bodyParser from 'body-parser';
import cookieParser from 'cookie-parser';
import hbs from 'express-handlebars';
import { multaHlpr } from 'libs/multa.helper';

import {
  errorResponder,
  finalResponder,
} from './libs/responders';
import {
  noCacheMiddleware,
  tooBusyMiddleware,
  requestLoggerMiddleware,
} from './libs/middlewares';

import routes from './routes';
import logger from './libs/logger';

import pkg from '../../../package.json';

global.pkg = pkg;

global.window = {
  name: pkg.name,
  config: {
    logLevel: process.env.LOG_LEVEL,
    isNode: true,
  },
};
process.env.LOG_LEVEL = process.env.LOG_LEVEL || 'error';
process.env.SSR = process.env.SSR !== 'false';

const log = logger.get('APP-SVC', { ignoreLogLevel: true });
const port = process.env.APP_SVC_PORT || 4000;

log.info(`[APP_SVC_MODE = ${process.env.APP_SVC_MODE}]`);
log.info(`[APP_SVC_PORT = ${port}]`);
log.info(`[NODE_ENV = ${process.env.NODE_ENV}]`);
log.info(`[LOG_LEVEL = ${process.env.LOG_LEVEL}]`);
log.info(`[SVC_HOST = ${process.env.SVC_HOST}]`);
log.info(`[SSR = ${process.env.SSR}]`);

log.info(`Starting app [${pkg.name}] ...`);

function initApp () {
  const app = express();

  app.set('views', path.join(__dirname, 'libs/views'));
  app.engine('.hbs', hbs({ extname: '.hbs' }));
  app.set('view engine', '.hbs');

  app.set('port', port);
  app.set('x-powered-by', false);
  app.set('query parser', 'extended');

  app.use(tooBusyMiddleware);
  app.use(cookieParser());
  app.use(requestLoggerMiddleware);
  app.use(bodyParser.json({ limit: '25mb' }));
  app.use(bodyParser.urlencoded({ extended: true }));
  app.use(noCacheMiddleware);
  app.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
  });
  app.use(routes.router);

  errorResponder.use(app);
  app.use(finalResponder.router);

  const server = http.createServer(app);
  server.listen(port);
  server.on('error', (error) => {
    if (error.syscall !== 'listen') {
      throw error;
    }

    switch (error.code) {
      case 'EACCES':
        log.error(`Port ${port} requires elevated privileges`);
        process.exit(1);
        break;
      case 'EADDRINUSE':
        log.error(`Port ${port} is already in use`);
        process.exit(1);
        break;
      default:
        throw error;
    }
  });
  server.on('listening', () => {
    const addr = server.address();
    const bind = typeof addr === 'string'
      ? `pipe ${addr}`
      : `port ${addr.port}`;
    log.info(`Listening on ${bind}`);
  });
  server.on('close', () => {
    log.info('Server stopped');
  });

  process.on('SIGINT', () => {
    tooBusy.shutdown();
    process.exit();
  });

  process.on('unhandledRejection', (reason, p) => {
    log.warn('Unhandled Rejection at: Promise', p, 'reason:', reason);
  });

  global.multaData = {
    appConfig: multaHlpr.generateAppConfig(),
  };
}

initApp();

export {};
