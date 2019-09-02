import React from 'react'
import {connect} from 'react-redux'
import DayView from './DayView'
import {
    completeTodo,
    undoCompleteTodo,
    deselectTodo,
    dragTodo,
    hoverTodoOnActionPane,
    moveSelectedTodos,
    selectTodo,
    toggleShowingCompletedTodos,
} from '../state/todos'

const mapStateToProps = (state, props) => ({
    todos: state.todos[props.day].todos,
    completedTodos: state.todos[props.day].completed,
    selectedIds: state.todos.selectedIds,
    hoveringOnActionPane: state.todos.hoveringOnActionPane,
    multiSelectActivated: state.todos.selectedIds.length > 0,
    hideCompletedTodos: state.todos.hideCompletedTodos,
})

const mapDispatchToProps = (dispatch) => {
    return {
        selectTodo: (todo) => dispatch(selectTodo(todo)),
        deselectTodo: (todo) => dispatch(deselectTodo(todo)),
        moveSelectedTodos: () => dispatch(moveSelectedTodos()),
        dragTodo: (dragging) => dispatch(dragTodo(dragging)),
        hoverTodoOnActionPane: (hovering) => dispatch(hoverTodoOnActionPane(hovering)),
        completeTodo: (todo) => dispatch(completeTodo(todo)),
        undoCompleteTodo: (todo) => dispatch(undoCompleteTodo(todo)),
        toggleShowingCompletedTodos: () => dispatch(toggleShowingCompletedTodos()),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(DayView)
