import logger from 'libs/logger';
import { PageParamsFromReqQuery } from './PageParamsFromReqQuery';
import { ssrSvc } from './ssr-service';

const log = logger.get('/routes/root/all');

async function all (req, res, next) {
  if (res.body && res.statusCode === 200) {
    return next();
  }

  let pageOpts = {
    originalUrl: req.originalUrl,
    appName: 'Ciklum',
    logLevel: process.env.LOG_LEVEL,
    appId: 'root',
  };

  const queryParams = new PageParamsFromReqQuery(req.query).value();

  const { scriptUrls, styleUrls, rootElementName } = global.multaData.appConfig;
  pageOpts = {
    ...pageOpts,
    startApp: queryParams.startApp,
    ssr: queryParams.ssr,

    // @todo: html, scripts, styles should be generated via @ciklum/multa
    html: `<${rootElementName}></${rootElementName}>`,
    scriptUrls,
    styleUrls,
  };

  if (!queryParams.ssr) {
    log.info(`ssr=${queryParams.ssr} skipping ssr...`);

    res.opts = pageOpts;
    res.statusCode = 200;
    res.template = 'component';
    return next();
  }

  const pageParams = {
    ...queryParams,
    originalUrl: req.originalUrl,
  };

  return ssrSvc.render(pageParams, req.headers)
    .then((payload) => {
      const {
        context,
      } = payload;

      if (context.url) {
        // react router redirect all
        const { status = 301 } = context;
        log.warn('App redirected to ->', context.url, ', with status =', status);
        res.redirect(status, context.url);
        return next();
      }

      res.statusCode = context.status || 200;
      pageOpts = {
        ...pageOpts,
        html: payload.html,
        css: payload.css,
      };
      res.opts = pageOpts;
      res.template = 'component';

      return next();
    })
    .catch((err) => {
      log.error('ERROR', err);

      res.statusCode = 500;
      res.opts = pageOpts;
      res.template = '500';
      return next();
    });
}

export const handler = { all };
