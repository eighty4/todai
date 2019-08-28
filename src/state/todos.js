import Storage from './Storage'
import {of} from 'rxjs'
import {filter, mergeMap} from 'rxjs/operators'

export const CHANGE_VIEWING_DAY = 'CHANGE_VIEWING_DAY'

export const LOAD_TODOS = 'LOAD_TODOS'
export const LOAD_TODOS_SUCCESS = 'LOAD_TODOS_SUCCESS'
export const LOAD_TODOS_FAILURE = 'LOAD_TODOS_FAILURE'

export const ADD_TODO = 'ADD_TODO'
export const ADD_TODO_SUCCESS = 'ADD_TODO_SUCCESS'
export const ADD_TODO_FAILURE = 'ADD_TODO_FAILURE'

export const DELETE_TODO = 'DELETE_TODO'
export const DELETE_TODO_SUCCESS = 'DELETE_TODO_SUCCESS'
export const DELETE_TODO_FAILURE = 'DELETE_TODO_FAILURE'

export const DRAG_TODO = 'DRAG_TODO'
export const DROP_TODO_HOVER = 'DROP_TODO_HOVER'
export const DROP_TODO = 'DROP_TODO'

export const changeViewingDay = () => ({type: CHANGE_VIEWING_DAY})

export const loadTodos = () => ({type: LOAD_TODOS})

export const addTodo = (todo) => ({type: ADD_TODO, todo})

export const deleteTodo = (day, todo) => ({type: DELETE_TODO, day, todo})

export const dragTodo = (dragging = true) => ({type: DRAG_TODO, dragging})

export const hoverTodoOnActionPane = (hoveringOnActionPane = true) => ({type: DROP_TODO_HOVER, hoveringOnActionPane})

export const dropTodoOnActionPane = (day, todo) => ({type: DROP_TODO, day, todo})

const initialState = {
    viewing: 'today',
    today: [],
    tomorrow: [],
    loading: false,
    error: false,
    adding: false,
    dragging: false,
    hoveringOnActionPane: false
}

export const reducers = (prevState = initialState, action) => {
    switch (action.type) {
        case CHANGE_VIEWING_DAY:
            const viewing = prevState.viewing === 'today' ? 'tomorrow' : 'today'
            return {
                ...prevState,
                viewing,
            }
        case LOAD_TODOS:
            return {
                ...prevState,
                loading: true,
                error: false,
            }
        case LOAD_TODOS_SUCCESS:
            const {todos} = action
            return {
                ...prevState,
                loading: false,
                ...todos,
            }
        case LOAD_TODOS_FAILURE:
            const {error} = action
            return {
                ...prevState,
                loading: false,
                error,
            }
        case DRAG_TODO:
            const {dragging} = action
            return {
                ...prevState,
                dragging,
            }
        case DROP_TODO_HOVER:
            const {hoveringOnActionPane} = action
            return {
                ...prevState,
                hoveringOnActionPane,
            }
        case DROP_TODO:
            return {
                ...prevState,
                loading: true,
                dragging: false,
                hoveringOnActionPane: false,
            }
        default:
            return prevState
    }
}

export const loadTodosEpic = action$ => action$.pipe(
    filter(action => action.type === LOAD_TODOS),
    mergeMap(() => Storage.loadTodos()
        .then(todos => ({type: LOAD_TODOS_SUCCESS, todos}))
        .catch(error => ({type: LOAD_TODOS_FAILURE, error}))
    ),
)

export const addTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === ADD_TODO),
    mergeMap(({todo}) => Storage.addTodo(state$.value.todos.viewing, todo)
        .then(() => ({type: ADD_TODO_SUCCESS}))
        .catch(error => ({type: ADD_TODO_FAILURE, error}))
    ),
)

export const refreshTodosEpic = action$ => action$.pipe(
    filter(action => action.type === ADD_TODO_SUCCESS || action.type === DELETE_TODO_SUCCESS),
    mergeMap(() => of(loadTodos())),
)

export const deleteTodoEpic = action$ => action$.pipe(
    filter(action => action.type === DELETE_TODO),
    mergeMap(({day, todo}) => Storage.deleteTodo(day, todo)
        .then(() => ({type: DELETE_TODO_SUCCESS}))
        .catch(error => ({type: DELETE_TODO_FAILURE, error}))
    ),
)

export const moveTodoToOtherDayEpic = action$ => action$.pipe(
    filter(action => action.type === DROP_TODO),
    mergeMap(({day, todo}) => Storage.moveTodo(day, todo)
        .then(() => ({type: ADD_TODO_SUCCESS}))
        .catch(error => ({type: ADD_TODO_FAILURE, error}))
    ),
)

export const epics = [
    loadTodosEpic,
    addTodoEpic,
    refreshTodosEpic,
    deleteTodoEpic,
    moveTodoToOtherDayEpic,
]
