import {handle} from 'redux-pack'

export const LOAD_TODOS = 'LOAD_TODOS'

export const loadTodos = () => ({
    type: LOAD_TODOS,
    promise: Promise.resolve({
        today: ['Build deck', 'Laundry'],
        tomorrow: ['Yoga', 'Clean car', 'Uber'],
    })
})

const initialState = {today: [], tomorrow: [], loading: false, error: false}

export const reducers = (state = initialState, action) => {
    const {type, payload} = action
    switch (type) {
        case LOAD_TODOS:
            return handle(state, action, {
                start: prevState => ({...prevState, loading: true, error: false}),
                finish: prevState => ({...prevState, loading: false}),
                failure: prevState => ({...prevState, error: true}),
                success: prevState => ({...prevState, today: payload.today, tomorrow: payload.tomorrow}),
            })
        default:
            return state
    }
}
