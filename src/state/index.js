import {applyMiddleware, createStore} from 'redux'
import { createEpicMiddleware } from 'redux-observable'
import {createLogger} from 'redux-logger'
import {combineEpics} from 'redux-observable'
import {epics as todoEpics} from './todos'
import {combineReducers} from 'redux'
import {reducers as todos} from './todos'

const reducers = combineReducers({todos})
const reduxObservable = createEpicMiddleware()
const middleware = applyMiddleware(reduxObservable, createLogger())

export default createStore(reducers, middleware)

reduxObservable.run(combineEpics(...todoEpics))
