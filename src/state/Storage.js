import {AsyncStorage} from 'react-native'

class Storage {

    static retrieveRecord(key, defaultValue) {
        return AsyncStorage
            .getItem(key, undefined)
            .then(result => !!result ? JSON.parse(result) : defaultValue)
    }

    static loadTodos() {
        const today = new Date().toISOString().substring(0, 10)
        const tomorrow = today.substring(0, 8) + (parseInt(today.substring(8, 10), 10) + 1)

        return Promise.all([
            Storage.retrieveRecord('todos:' + today, []),
            Storage.retrieveRecord('todos:' + tomorrow, []),
        ]).then(results => {
            return {
                today: results[0],
                tomorrow: results[1],
            }
        })
    }

    static addTodo(day, todo) {
        const today = new Date().toISOString().substring(0, 10)
        const dateKey = day === 'today' ? today : today.substring(0, 8) + (parseInt(today.substring(8, 10), 10) + 1)
        return Storage.retrieveRecord('todos:' + dateKey, [])
            .then(todos => {
                todos.push(todo)
                return AsyncStorage.setItem(dateKey, JSON.stringify(todos))
            })
    }
}

export default Storage
