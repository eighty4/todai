import {AsyncStorage} from 'react-native'

class Storage {

    static retrieveRecord(key, defaultValue) {
        return AsyncStorage
            .getItem(key, undefined)
            .then(result => !!result ? JSON.parse(result) : defaultValue)
    }

    static loadTodos() {
        return Promise.all([
            Storage.retrieveRecord('todos:today', []),
            Storage.retrieveRecord('todos:tomorrow', []),
        ]).then(results => {
            return {
                today: results[0],
                tomorrow: results[1],
            }
        })
    }

    static addTodo(day, todo) {
        return Storage.retrieveRecord(`todos:${day}`, [])
            .then(todos => {
                todos.push(todo)
                return AsyncStorage.setItem(`todos:${day}`, JSON.stringify(todos))
            })
    }

    static deleteTodo(day, todo) {
        return Storage.retrieveRecord(`todos:${day}`, [])
            .then(todos => {
                const i = todos.indexOf(todo)
                if (i >= 0) {
                    todos.splice(i, 1)
                }
                return AsyncStorage.setItem(`todos:${day}`, JSON.stringify(todos))
            })
    }
}

export default Storage
