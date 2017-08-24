'use strict';

const db = require('../lib/db.js');

module.exports = {
    create: (dob, name, sex, species) => {
        return db.funcId('new_pet', [
            dob,
            name,
            sex,
            species
        ]);
    },
    read: id => {
        return db.funcOneOrNone('pet', id);
    },
    search: (dobStart, dobFinish, name, sex, species) => {
        return db.func('pets', [
            dobStart,
            dobFinish,
            name,
            sex,
            species
        ]);
    }
};
