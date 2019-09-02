import React from 'react'
import {connect} from 'react-redux'
import {addTodo} from '../state/todos'
import TodoInput from './TodoInput'

const mapStateToProps = () => ({})

const mapDispatchToProps = (dispatch) => {
    return {
        addTodo: (todo) => dispatch(addTodo(todo)),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoInput)
