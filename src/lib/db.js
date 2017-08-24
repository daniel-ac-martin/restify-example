'use strict';

const pgp = require('pg-promise')();
const config = require('../../config.js');

const connection = {
  host: config.postgres.host,
  port: config.postgres.port,
  database: config.postgres.name,
  user: config.postgres.user,
  password: config.postgres.pass
};

const db = pgp(connection);
const qrm = pgp.queryResult;

module.exports = {
    funcNone: (q, v) => db.func(q, v, qrm.none),
    funcId: (q, v) => db.func(q, v, qrm.one).then(w => w[q]),
    funcOne: (q, v) => db.func(q, v, qrm.one),
    funcOneOrNone: (q, v) => db.func(q, v, qrm.one | qrm.none),
    funcMany: (q, v) => db.func(q, v, qrm.many),
    func: (q, v) => db.func(q, v)
};
