import {applyMiddleware, combineReducers, createStore} from 'redux'
import {middleware as reduxPackMiddleware} from 'redux-pack'
import {createLogger} from 'redux-logger'
import {reducers as add} from './add'
import {reducers as todos} from './todos'

export const reducers = combineReducers({add, todos})

export const store = createStore(reducers, applyMiddleware(reduxPackMiddleware, createLogger()))
