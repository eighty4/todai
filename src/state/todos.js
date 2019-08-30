import Storage from './Storage'
import {of} from 'rxjs'
import {filter, mergeMap} from 'rxjs/operators'

export const CHANGE_VIEWING_DAY = 'CHANGE_VIEWING_DAY'

export const LOAD_TODOS = 'LOAD_TODOS'
export const LOAD_TODOS_SUCCESS = 'LOAD_TODOS_SUCCESS'

export const SELECT_TODO = 'SELECT_TODO'
export const DESELECT_TODO = 'DESELECT_TODO'

export const ADD_TODO = 'ADD_TODO'
export const COMPLETE_TODO = 'COMPLETE_TODO'

export const DELETE_SELECTED_TODOS = 'DELETE_SELECTED_TODOS'
export const MOVE_SELECTED_TODOS = 'MOVE_SELECTED_TODOS'
export const COMPLETE_SELECTED_TODOS = 'COMPLETE_SELECTED_TODOS'

export const DRAG_TODO = 'DRAG_TODO'
export const DROP_TODO_HOVER = 'DROP_TODO_HOVER'

export const OPERATION_SUCCESS = 'OPERATION_SUCCESS'
export const OPERATION_ERROR = 'OPERATION_ERROR'

export const changeViewingDay = () => ({type: CHANGE_VIEWING_DAY})

export const loadTodos = () => ({type: LOAD_TODOS})

export const selectTodo = (todo) => ({type: SELECT_TODO, todo})
export const deselectTodo = (todo) => ({type: DESELECT_TODO, todo})

export const addTodo = (todo) => ({type: ADD_TODO, todo})
export const completeTodo = (todo) => ({type: COMPLETE_TODO, todo})

export const deleteSelectedTodos = () => ({type: DELETE_SELECTED_TODOS})
export const moveSelectedTodos = () => ({type: MOVE_SELECTED_TODOS})
export const completeSelectedTodos = () => ({type: COMPLETE_SELECTED_TODOS})

export const dragTodo = (dragging = true) => ({type: DRAG_TODO, dragging})

export const hoverTodoOnActionPane = (hoveringOnActionPane = true) => ({type: DROP_TODO_HOVER, hoveringOnActionPane})

const initialState = {
    viewing: 'today',
    selected: [],
    today: [],
    tomorrow: [],
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
            }
        case LOAD_TODOS_SUCCESS:
            const {todos} = action
            return {
                ...prevState,
                ...todos,
            }
        case SELECT_TODO:
            return {
                ...prevState,
                selected: [...prevState.selected, action.todo],
            }
        case DESELECT_TODO:
            return {
                ...prevState,
                selected: prevState.selected.filter(todo => todo !== action.todo),
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
        case MOVE_SELECTED_TODOS:
            return {
                ...prevState,
                loading: true,
                dragging: false,
                hoveringOnActionPane: false,
            }
        case OPERATION_SUCCESS:
            if (action.deselect) {
                return {
                    ...prevState,
                    selected: [],
                }
            } else {
                return prevState
            }
        default:
            return prevState
    }
}

export const loadTodosEpic = action$ => action$.pipe(
    filter(action => action.type === LOAD_TODOS),
    mergeMap(() => Storage.getTodos()
        .then(todos => ({type: LOAD_TODOS_SUCCESS, todos}))
        .catch(error => ({type: OPERATION_ERROR, error, operation: LOAD_TODOS}))
    ),
)

export const addTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === ADD_TODO),
    mergeMap(({todo}) => Storage.addTodos(state$.value.todos.viewing, todo)
        .then(() => ({type: OPERATION_SUCCESS}))
        .catch(error => ({type: OPERATION_ERROR, error, operation: ADD_TODO}))
    ),
)

export const deleteSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === DELETE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selected} = state$.value.todos
        return Storage.deleteTodos(viewing, selected)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: DELETE_SELECTED_TODOS}))
        }
    ),
)

export const moveSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === MOVE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selected} = state$.value.todos
        return Storage.moveTodos(viewing, selected)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: MOVE_SELECTED_TODOS}))
        }
    ),
)

export const completeSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === MOVE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selected} = state$.value.todos
        return Storage.completeTodos(viewing, selected)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: COMPLETE_SELECTED_TODOS}))
        }
    ),
)

export const completeTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === COMPLETE_TODO),
    mergeMap((action) => Storage.completeTodos(state$.value.todos.viewing, action.todo)
            .then(() => ({type: OPERATION_SUCCESS}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: COMPLETE_SELECTED_TODOS}))
    ),
)

export const refreshTodosEpic = action$ => action$.pipe(
    filter(action => action.type === OPERATION_SUCCESS),
    mergeMap(() => of(loadTodos())),
)

export const epics = [
    loadTodosEpic,
    addTodoEpic,
    deleteSelectedTodosEpic,
    moveSelectedTodosEpic,
    completeSelectedTodosEpic,
    refreshTodosEpic,
    completeTodoEpic,
]
