import {applyMiddleware, createStore} from 'redux'
import { createEpicMiddleware } from 'redux-observable';
import {createLogger} from 'redux-logger'
import reducers from './reducers'
import epics from './epics'

const reduxObservable = createEpicMiddleware()

export default createStore(reducers, applyMiddleware(reduxObservable, createLogger()))

reduxObservable.run(epics)
