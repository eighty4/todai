import {of, BehaviorSubject} from 'rxjs'
import {
    addTodo,
    addTodoEpic,
    loadTodosEpic,
    LOAD_TODOS,
    LOAD_TODOS_SUCCESS,
    OPERATION_SUCCESS,
    OPERATION_ERROR,
    ADD_TODO,
} from '../../src/state/todos'
import Storage from '../../src/state/Storage'

jest.mock('../../src/state/Storage')

describe('loadTodosEpic', () => {

    test('dispatches LOAD_TODOS_SUCCESS when finished', done => {
        const todos = {today: ['foo'], tomorrow: ['bar']}
        Storage.getTodos.mockReturnValue(Promise.resolve(todos))
        loadTodosEpic(of({type: LOAD_TODOS}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: LOAD_TODOS_SUCCESS, todos})
                done()
            })
    })

    test('dispatches LOAD_TODOS_FAILURE when error', done => {
        const error = 'turn up millhouse'
        Storage.getTodos.mockImplementation(() => Promise.reject(error))
        loadTodosEpic(of({type: LOAD_TODOS}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: OPERATION_ERROR, error, operation: LOAD_TODOS})
                done()
            })
    })
})

describe('addTodoEpic', () => {

    test('dispatches OPERATION_SUCCESS when finished', done => {
        Storage.addTodos.mockReturnValue(Promise.resolve())
        addTodoEpic(of(addTodo('clean')), new BehaviorSubject({todos: {viewing: 'today'}}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: OPERATION_SUCCESS})
                done()
            })
    })

    test('dispatches ADD_TODO_FAILURE when error', done => {
        const error = 'all your base are belong to us'
        Storage.addTodos.mockReturnValue(Promise.reject(error))
        addTodoEpic(of(addTodo('today', 'clean')), new BehaviorSubject({todos: {viewing: 'today'}}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: OPERATION_ERROR, error, operation: ADD_TODO})
                done()
            })
    })
})
