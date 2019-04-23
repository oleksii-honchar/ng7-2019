import urlJoin from 'url-join';

function addOriginIfNeeded (origin, path) {
  let finalPath = path;
  if (finalPath.startsWith('./')) {
    finalPath = finalPath.slice(2);
  }

  if (finalPath.startsWith('http')) return finalPath;
  return urlJoin(origin, finalPath);
}

function createAppConfig (origin) {
  if (!global.multaData || !global.multaData.appConfig) {
    return 'not specified';
  }

  const appConfig = Object.assign({}, global.multaData.appConfig);

  if (!origin) return appConfig;

  appConfig.scriptUrls = appConfig.scriptUrls.map(scriptUrl => addOriginIfNeeded(origin, scriptUrl));
  appConfig.styleUrls = appConfig.styleUrls.map(styleUrl => addOriginIfNeeded(origin, styleUrl));

  return appConfig;
}

export default function get (req, res, next) {
  const appSvcConfig = req.query.appSvcConfig ? JSON.parse(req.query.appSvcConfig) : {};

  const { origin } = appSvcConfig;

  res.body = createAppConfig(origin);
  res.statusCode = 200;
  next();
}
