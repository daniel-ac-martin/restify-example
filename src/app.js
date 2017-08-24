'use strict';

const config = require('../config.js');
const log = require('./lib/logger');
const pets = require('./middleware/pets');
const restify = require('restify');
const restifyBunyanLogger = require('restify-bunyan-logger');

const name = 'restify-example';
process.title = name.substr(0, 6);

const httpd = restify.createServer({
  log: log,
  name: name
});
httpd.on('after', restifyBunyanLogger());

const respond = (req, res, next) => {
  res.send('hello ' + req.params.name);
  next();
};
httpd.get('/hello/:name', respond);
httpd.head('/hello/:name', respond);
const throwError = (req, res, next) => {
  throw new Error('made a booboo');
};
httpd.get('/error', throwError);

httpd.use(restify.plugins.bodyParser({ mapParams: false }));
httpd.use(restify.plugins.queryParser({ mapParams: false }));
httpd.get('pet', pets.search);
httpd.post('pet', pets.create);
httpd.get('pet/:id', pets.read);
//httpd.put('pet/:id', pets.update);
//httpd.delete('pet/:id', pets.delete);

httpd.listen(config.httpd.port, config.httpd.host, () => {
    log.info('%s listening at %s', httpd.name, httpd.url);
});
