import express from 'express';
import Url from 'url';
import path from 'path';

import { APP_BIN_PATH } from 'constants';
import { handler } from 'routes/root';
import { versionRouter } from 'routes/version';
import { embedRouter } from './routes/embed';

const mountPoint = process.env.APP_SVC_MOUNT_POINT;

const router = new express.Router();

router.use(mountPoint, [
  versionRouter,
  embedRouter,
  (req, res, next) => {
    if (!req.route) res.status(404);

    return next();
  },
]);

router.use(/\/static/, [
  express.static(APP_BIN_PATH),
  (req, res, next) => {
    if (!req.route) res.status(404);

    return next();
  },
]);

router.use('*', (req, res, next) => {
  if (req.route || res.statusCode === 404 || res.statusCode === 500) {
    return next();
  }

  if (path.extname(Url.parse(req.originalUrl).pathname)) {
    res.statusCode = 404;
    return next();
  }

  return handler.all(req, res, next);
});

export default { router };
