import {of} from 'rxjs'
import {
    ADD_TODO_FAILURE,
    ADD_TODO_SUCCESS,
    addTodo,
    addTodoEpic,
    LOAD_TODOS,
    LOAD_TODOS_FAILURE,
    LOAD_TODOS_SUCCESS,
    loadTodosEpic
} from '../../src/state/todos'
import Storage from '../../src/state/Storage'

jest.mock('../../src/state/Storage')

describe('loadTodosEpic', () => {

    test('dispatches LOAD_TODOS_SUCCESS when finished', done => {
        const todos = {today: ['foo'], tomorrow: ['bar']}
        Storage.loadTodos.mockReturnValue(Promise.resolve(todos))
        loadTodosEpic(of({type: LOAD_TODOS}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: LOAD_TODOS_SUCCESS, todos})
                done()
            })
    })

    test('dispatches LOAD_TODOS_FAILURE when error', done => {
        const error = 'turn up millhouse'
        Storage.loadTodos.mockImplementation(() => Promise.reject(error))
        loadTodosEpic(of({type: LOAD_TODOS}))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: LOAD_TODOS_FAILURE, error})
                done()
            })
    })
})

describe('addTodoEpic', () => {

    test('dispatches ADD_TODO_SUCCESS and LOAD_TODOS when finished', done => {
        Storage.addTodo.mockReturnValue(Promise.resolve())
        addTodoEpic(of(addTodo('today', 'clean')))
            .subscribe(dispatched => {
                expect(dispatched).toContainEqual({type: ADD_TODO_SUCCESS})
                expect(dispatched).toContainEqual({type: LOAD_TODOS})
                expect(dispatched.length).toBe(2)
                done()
            })
    })

    test('dispatches ADD_TODO_FAILURE when error', done => {
        const error = 'all your base are belong to us'
        Storage.addTodo.mockReturnValue(Promise.reject(error))
        addTodoEpic(of(addTodo('today', 'clean')))
            .subscribe(dispatched => {
                expect(dispatched).toStrictEqual({type: ADD_TODO_FAILURE, error})
                done()
            })
    })
})
