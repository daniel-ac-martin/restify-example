'use strict';

const errors = require('restify-errors');
const promiseRejectionHandler = require('../lib/promise-rejection-handler');
const model = require('../model/pets');

module.exports = {
    create: (req, res, next) => {
        model.create(req.body.dob, req.body.name, req.body.sex, req.body.species)
            .then(id => {
                res.send(id);
                next();
            })
            .catch(promiseRejectionHandler(next));
    },
    read: (req, res, next) => {
        model.read(req.params.id)
            .then(r => {
                if (r) {
                    res.send(r);
                    next();
                } else {
                    next(new errors.NotFoundError());
                }
            })
            .catch(promiseRejectionHandler(next));
    },
    search: (req, res, next) => {
        model.search(req.query.dobStart, req.query.dobFinish, req.query.name, req.query.sex, req.query.species)
            .then(id => {
                 res.send(id);
                 next();
            })
            .catch(promiseRejectionHandler(next));
    }
};
