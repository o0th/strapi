'use strict';

/**
 * something service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::something.something');
