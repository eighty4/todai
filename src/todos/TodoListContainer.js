import React from 'react'
import {connect} from 'react-redux'
import {
    deleteTodo,
    dragTodo,
    hoverTodoOnActionPane,
    dropTodoOnActionPane,
} from '../state/todos'
import TodoList from './TodoList'

const mapStateToProps = (state) => {
    return {
        hoveringOnActionPane: state.todos.hoveringOnActionPane,
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        deleteTodo: (day, todo) => dispatch(deleteTodo(day, todo)),
        dragTodo: (dragging) => dispatch(dragTodo(dragging)),
        hoverTodoOnActionPane: (hovering) => dispatch(hoverTodoOnActionPane(hovering)),
        dropTodoOnActionPane: (day, todo) => dispatch(dropTodoOnActionPane(day, todo)),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoList)
