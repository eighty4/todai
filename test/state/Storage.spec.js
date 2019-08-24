import Storage from '../../src/state/Storage'
import {AsyncStorage} from 'react-native'

jest.mock('react-native', () => ({

    AsyncStorage: (() => {

        let items = {}

        return {

            setItem: jest.fn((key, value) => {
                items[key] = value.toString()
                return Promise.resolve()
            }),

            getItem: jest.fn((key) => {
                return Promise.resolve(items[key])
            }),
        }
    })(),
}))

describe('loadTodos', () => {

    test('starts with empty arrays', () => {
        expect.assertions(3)
        return Storage.loadTodos().then(result => {
            expect(AsyncStorage.getItem.mock.calls.length).toBe(2)
            expect(result.today).toStrictEqual([])
            expect(result.tomorrow).toStrictEqual([])
        })
    })
})
