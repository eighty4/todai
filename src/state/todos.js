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
export const UNDO_COMPLETE_TODO = 'UNDO_COMPLETE_TODO'

export const DELETE_SELECTED_TODOS = 'DELETE_SELECTED_TODOS'
export const MOVE_SELECTED_TODOS = 'MOVE_SELECTED_TODOS'
export const COMPLETE_SELECTED_TODOS = 'COMPLETE_SELECTED_TODOS'

export const TOGGLE_SHOWING_COMPLETED_TODOS = 'TOGGLE_SHOWING_COMPLETED_TODOS'

export const DRAG_TODO = 'DRAG_TODO'
export const DROP_TODO_HOVER = 'DROP_TODO_HOVER'

export const OPERATION_SUCCESS = 'OPERATION_SUCCESS'
export const OPERATION_ERROR = 'OPERATION_ERROR'

export const changeViewingDay = () => ({type: CHANGE_VIEWING_DAY})

export const loadTodos = () => ({type: LOAD_TODOS})

export const selectTodo = (todo) => ({type: SELECT_TODO, todoId: todo.id})
export const deselectTodo = (todo) => ({type: DESELECT_TODO, todoId: todo.id})

export const addTodo = (todoText) => ({type: ADD_TODO, todoText})
export const completeTodo = (todo) => ({type: COMPLETE_TODO, todo})
export const undoCompleteTodo = (todo) => ({type: UNDO_COMPLETE_TODO, todo})

export const deleteSelectedTodos = () => ({type: DELETE_SELECTED_TODOS})
export const moveSelectedTodos = () => ({type: MOVE_SELECTED_TODOS})
export const completeSelectedTodos = () => ({type: COMPLETE_SELECTED_TODOS})

export const toggleShowingCompletedTodos = () => ({type: TOGGLE_SHOWING_COMPLETED_TODOS})

export const dragTodo = (dragging = true) => ({type: DRAG_TODO, dragging})

export const hoverTodoOnActionPane = (hoveringOnActionPane = true) => ({type: DROP_TODO_HOVER, hoveringOnActionPane})

const initialState = {
    viewing: 'today',
    selectedIds: [],
    today: {
        todos: [],
        completed: [],
    },
    tomorrow: {
        todos: [],
        completed: [],
    },
    dragging: false,
    hoveringOnActionPane: false,
    hideCompletedTodos: true,
}

export const reducers = (prevState = initialState, action) => {
    switch (action.type) {
        case CHANGE_VIEWING_DAY:
            const viewing = prevState.viewing === 'today' ? 'tomorrow' : 'today'
            return {
                ...prevState,
                selectedIds: [],
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
                selectedIds: [...prevState.selectedIds, action.todoId],
            }
        case DESELECT_TODO:
            return {
                ...prevState,
                selectedIds: prevState.selectedIds.filter(todoId => todoId !== action.todoId),
            }
        case TOGGLE_SHOWING_COMPLETED_TODOS:
            return {
                ...prevState,
                hideCompletedTodos: !prevState.hideCompletedTodos,
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
                    selectedIds: [],
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
        .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
    ),
)

export const addTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === ADD_TODO),
    mergeMap(({todoText}) => Storage.addTodos(state$.value.todos.viewing, todoText)
        .then(() => ({type: OPERATION_SUCCESS}))
        .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
    ),
)

export const deleteSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === DELETE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selectedIds} = state$.value.todos
        return Storage.deleteTodos(viewing, selectedIds)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
        }
    ),
)

export const moveSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === MOVE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selectedIds} = state$.value.todos
        const selected = state$.value.todos[viewing].todos.filter(todo => selectedIds.indexOf(todo.id) !== -1)
        return Storage.moveTodos(viewing, selected)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
        }
    ),
)

export const completeSelectedTodosEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === MOVE_SELECTED_TODOS),
    mergeMap(() => {
        const {viewing, selectedIds} = state$.value.todos
        return Storage.completeTodos(viewing, selectedIds)
            .then(() => ({type: OPERATION_SUCCESS, deselect: true}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
        }
    ),
)

export const completeTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === COMPLETE_TODO),
    mergeMap((action) => Storage.completeTodos(state$.value.todos.viewing, [action.todo.id])
            .then(() => ({type: OPERATION_SUCCESS}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
    ),
)

export const undoCompleteTodoEpic = (action$, state$) => action$.pipe(
    filter(action => action.type === UNDO_COMPLETE_TODO),
    mergeMap((action) => Storage.undoCompleteTodos(state$.value.todos.viewing, [action.todo.id])
            .then(() => ({type: OPERATION_SUCCESS}))
            .catch(error => ({type: OPERATION_ERROR, error, operation: action.type}))
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
    undoCompleteTodoEpic,
]
