
export const addTodo = (label) => {
    return {
        type: "ADD_TODO",
        label,
    }
}

export const reducers = (state = {}, action) => {
    switch (action.type) {
        default:
            return state
    }
}
