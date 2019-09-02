import {AsyncStorage} from 'react-native'
import dayjs from 'dayjs'

const createId = () => Math.floor(Math.random() * Math.floor(1000))

const currentTime = () => dayjs().format('YYYY-MM-DDTHH:mm:ssZ')

const conformToArray = todoOrTodos => todoOrTodos instanceof Array ? todoOrTodos : [todoOrTodos]

const mapToIdArray = todoOrTodos => conformToArray(todoOrTodos).map(todo => todo.id)

const read = (key, defaultValue) => {
    return AsyncStorage
        .getItem(key, undefined)
        .then(result => !!result ? JSON.parse(result) : defaultValue)
}

const write = (key, value) => {
    return AsyncStorage.setItem(key, JSON.stringify(value))
}

const removeTodos = (todos, todoIdsToRemove) => todos.filter(todo => todoIdsToRemove.indexOf(todo.id) === -1)

class Storage {

    static reset() {
        return Promise.all([
            AsyncStorage.removeItem('today'),
            AsyncStorage.removeItem('tomorrow'),
        ])
    }

    static getTodos(day) {
        if (day) {
            return read(day, {todos: [], completed: []})
        } else {
            return Promise.all([
                Storage.getTodos('today'),
                Storage.getTodos('tomorrow'),
            ]).then(results => {
                return {
                    today: results[0],
                    tomorrow: results[1],
                }
            })
        }
    }

    static addTodos(day, todoOrTodos, copyInsteadOfCreate) {
        const todos = conformToArray(todoOrTodos)
        return Storage.getTodos(day)
            .then(loadedDayState => {
                todos.forEach(todo => loadedDayState.todos.push(
                    copyInsteadOfCreate ? todo : {id: createId(), text: todo, createdTime: currentTime()}
                ))
                return write(day, loadedDayState)
            })
    }

    static deleteTodos(day, todoIdsToDelete) {
        return Storage.getTodos(day)
            .then(loadedDayState => {
                loadedDayState.todos = removeTodos(loadedDayState.todos, todoIdsToDelete)
                loadedDayState.completed = removeTodos(loadedDayState.completed, todoIdsToDelete)
                return write(day, loadedDayState)
            })
    }

    static moveTodos(fromDay, todoOrTodos) {
        const toDay = fromDay === 'today' ? 'tomorrow' : 'today'
        return Storage.addTodos(toDay, todoOrTodos, true)
            .then(() => Storage.deleteTodos(fromDay, mapToIdArray(todoOrTodos)))
    }

    static completeTodos(day, todoIdsToComplete) {
        return Storage.getTodos(day).then(loadedDayState => {
            loadedDayState.todos = loadedDayState.todos.filter(todo => {
                if (todoIdsToComplete.indexOf(todo.id) === -1) {
                    return true
                } else {
                    todo.completedTime = currentTime()
                    loadedDayState.completed.unshift(todo)
                    return false
                }
            })
            return write(day, loadedDayState)
        })
    }

    static undoCompleteTodos(day, todoIdsToUndoComplete) {
        return Storage.getTodos(day).then(loadedDayState => {
            loadedDayState.completed = loadedDayState.completed.filter(todo => {
                if (todoIdsToUndoComplete.indexOf(todo.id) === -1) {
                    return true
                } else {
                    delete todo.completedTime
                    loadedDayState.todos.push(todo)
                    return false
                }
            })
            return write(day, loadedDayState)
        })
    }
}

export default Storage
