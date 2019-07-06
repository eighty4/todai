import React from 'react'
import {connect} from 'react-redux'
import {addTodo} from '../state/todos'
import TodoInput from './TodoInput'

const mapStateToProps = () => {
    return {}
}

const mapDispatchToProps = (dispatch) => {
    return {
        addTodo: (day, todo) => dispatch(addTodo(day, todo)),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoInput)
