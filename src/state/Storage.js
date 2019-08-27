import {AsyncStorage} from 'react-native'

class Storage {

    static retrieveRecord(key, defaultValue) {
        return AsyncStorage
            .getItem(key, undefined)
            .then(result => !!result ? JSON.parse(result) : defaultValue)
    }

    static loadTodos(day) {
        if (day) {
            return Storage.retrieveRecord(`todos:${day}`, [])
        } else {
            return Promise.all([
                Storage.loadTodos('today'),
                Storage.loadTodos('tomorrow'),
            ]).then(results => {
                return {
                    today: results[0],
                    tomorrow: results[1],
                }
            })
        }
    }

    static addTodo(day, todo) {
        return Storage.loadTodos(day)
            .then(todos => {
                todos.push(todo)
                return AsyncStorage.setItem(`todos:${day}`, JSON.stringify(todos))
            })
    }

    static deleteTodo(day, todo) {
        return Storage.loadTodos(day)
            .then(todos => {
                const i = todos.indexOf(todo)
                if (i >= 0) {
                    todos.splice(i, 1)
                }
                return AsyncStorage.setItem(`todos:${day}`, JSON.stringify(todos))
            })
    }

    // todo rollback if the second setItem fails?
    static moveTodo(fromDay, todo) {
        const toDay = fromDay === 'today' ? 'tomorrow' : 'today'
        return Storage.addTodo(toDay, todo).then(() => Storage.deleteTodo(fromDay, todo))
    }
}

export default Storage
