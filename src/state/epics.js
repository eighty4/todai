import {combineEpics} from 'redux-observable'
import {epics as todoEpics} from './todos'

export default combineEpics(...todoEpics)
