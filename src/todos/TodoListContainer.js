import React from 'react'
import {connect} from 'react-redux'
import {
    selectTodo,
    deselectTodo,
    dragTodo,
    hoverTodoOnActionPane,
    moveSelectedTodos,
    completeTodo,
} from '../state/todos'
import TodoList from './TodoList'

const mapStateToProps = (state) => {
    return {
        selectedTodos: state.todos.selected,
        hoveringOnActionPane: state.todos.hoveringOnActionPane,
        multiSelectActivated: state.todos.selected.length > 0,
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        selectTodo: (todo) => dispatch(selectTodo(todo)),
        deselectTodo: (todo) => dispatch(deselectTodo(todo)),
        moveSelectedTodos: () => dispatch(moveSelectedTodos()),
        dragTodo: (dragging) => dispatch(dragTodo(dragging)),
        hoverTodoOnActionPane: (hovering) => dispatch(hoverTodoOnActionPane(hovering)),
        completeTodo: (todo) => dispatch(completeTodo(todo))
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoList)
