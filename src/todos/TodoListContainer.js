import React from 'react'
import {connect} from 'react-redux'
import {deleteTodo} from '../state/todos'
import TodoList from './TodoList'

const mapStateToProps = () => {
    return {}
}

const mapDispatchToProps = (dispatch) => {
    return {
        deleteTodo: (day, todo) => dispatch(deleteTodo(day, todo)),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoList)
