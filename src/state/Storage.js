import {AsyncStorage} from 'react-native'
import dayjs from 'dayjs'

const removeFromArray = (array, item) => {
    const j = array.indexOf(item)
    if (j >= 0) {
        array.splice(j, 1)
    }
}

const read = (key, defaultValue) => {
    return AsyncStorage
        .getItem(key, undefined)
        .then(result => !!result ? JSON.parse(result) : defaultValue)
}

const write = (key, value) => {
    return AsyncStorage.setItem(key, JSON.stringify(value))
}

class Storage {

    static getTodos(day) {
        if (day) {
            return read(day, [])
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

    static addTodos(day, todoOrTodos) {
        return Storage.getTodos(day)
            .then(todos => {
                if (todoOrTodos instanceof Array) {
                    todoOrTodos.forEach(todo => todos.push(todo))
                } else {
                    todos.push(todoOrTodos)
                }
                return write(day, todos)
            })
    }

    static deleteTodos(day, todoOrTodos) {
        return Storage.getTodos(day)
            .then(todos => {
                if (todoOrTodos instanceof Array) {
                    for (let i = 0; i < todoOrTodos.length; i++) {
                        removeFromArray(todos, todoOrTodos[i])
                    }
                } else {
                    removeFromArray(todos, todoOrTodos)
                }
                return write(day, todos)
            })
    }

    static moveTodos(fromDay, todosToMove) {
        const toDay = fromDay === 'today' ? 'tomorrow' : 'today'
        return Storage.addTodos(toDay, todosToMove).then(() => Storage.deleteTodos(fromDay, todosToMove))
    }

    static completeTodos(day, todoOrTodos) {
        const now = dayjs()
        // const completedTime = now.format('YYYY-MM-DDTHH:mm:ssZ')
        const todayDate = now.format('YYYY-MM-DD')
        return read(`completed:${todayDate}`, [])
            .then(completedTodos => {
                if (todoOrTodos instanceof Array) {
                    completedTodos.push(todoOrTodos)
                } else {
                    completedTodos.unshift(todoOrTodos)
                }
                return completedTodos
            })
            .then(completedTodos => write(`completed:${todayDate}`, completedTodos))
            .then(() => Storage.deleteTodos(day, todoOrTodos))
    }
}

export default Storage
