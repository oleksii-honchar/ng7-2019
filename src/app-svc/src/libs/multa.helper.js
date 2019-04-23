import fs from 'fs';
import path from 'path';
import { JSDOM } from 'jsdom';

import { APP_BIN_PATH } from '../constants';

export const multaHlpr = {
  generateAppConfig () {
    const indexHtmlContent = this.getIndexHtmlContent();
    const jsdom = new JSDOM(indexHtmlContent);
    const appConfig = this.getAppConfigFromJSDOM(jsdom);

    return appConfig;
  },

  getIndexHtmlContent () {
    const indexHtmlBuffer = fs.readFileSync(path.resolve(APP_BIN_PATH, 'index.html'));
    const indexHtmlContent = indexHtmlBuffer.toString();

    return indexHtmlContent;
  },

  getAppConfigFromJSDOM (jsdom) {
    const scriptElements = jsdom.window.document.querySelectorAll('script');
    const scriptUrls = Array.from(scriptElements).map(scriptElement => scriptElement.src);

    const styleElements = jsdom.window.document.querySelectorAll('link');
    const styleUrls = Array.from(styleElements).map(styleElement => styleElement.href);

    const rootElementName = jsdom.window.document.body.children[0].localName;

    return {
      rootElementName,
      scriptUrls,
      styleUrls,
      content: '',
    };
  },
};
