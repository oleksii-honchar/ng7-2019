import path from 'path';
import logger from './libs/logger';

const log = logger.get('constants');

// when in prod - app-svc runned from it's own bundle from dist/app-svc
export const APP_SVC_BIN_PATH = process.env.NODE_ENV === 'production' ? '../' : '../../../dist';
export const APP_BIN_PATH = path.join(__dirname, APP_SVC_BIN_PATH, 'static');

log.debug('__dirname', __dirname);
log.debug('APP_SVC_BIN_PATH', APP_SVC_BIN_PATH);
log.debug('APP_BIN_PATH', APP_BIN_PATH);
