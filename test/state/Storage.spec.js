import Storage from '../../src/state/Storage'
import {AsyncStorage} from 'react-native'
import dayjs from 'dayjs'

jest.mock('dayjs', () => {
    return () => {
        return {
            format: () => '1984-07-12'
        }
    }
})

jest.mock('react-native', () => ({

    AsyncStorage: (() => {

        let items = {}

        return {

            setItem: jest.fn((key, value) => {
                items[key] = value
                return Promise.resolve()
            }),

            getItem: jest.fn((key) => {
                return Promise.resolve(items[key])
            }),

            _getItem: (key) => {
                return JSON.parse(items[key])
            },

            _setItem: (key, value) => {
                items[key] = JSON.stringify(value)
            },
        }
    })(),
}))

describe('Storage', () => {

    beforeEach(() => {
        jest.clearAllMocks()
    })

    describe('getTodos', () => {

        test('starts with empty arrays', () => {
            expect.assertions(3)
            return Storage.getTodos().then(result => {
                expect(AsyncStorage.getItem.mock.calls.length).toBe(2)
                expect(result.today).toStrictEqual([])
                expect(result.tomorrow).toStrictEqual([])
            })
        })
    })

    describe('completeTodos', () => {

        test('asdf', () => {
            AsyncStorage._setItem('today', ['foo', 'bar'])

            expect.assertions(4)
            return Storage.completeTodos('today', 'foo').then(() => {
                expect(AsyncStorage.getItem.mock.calls.length).toBe(2)
                expect(AsyncStorage.setItem.mock.calls.length).toBe(2)
                expect(AsyncStorage._getItem('completed:1984-07-12')).toContain('foo')
                expect(AsyncStorage._getItem('today')).not.toContain('foo')
            })
        })
    })
})
