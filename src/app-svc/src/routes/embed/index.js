import express from 'express';
import get from './handler';

export const embedRouter = new express.Router();

embedRouter.get('/embed', get);
