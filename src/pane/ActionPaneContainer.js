import React from 'react'
import {connect} from 'react-redux'
import ActionPane from './ActionPane'
import {
    deleteSelectedTodos,
    moveSelectedTodos,
    completeSelectedTodos,
} from '../state/todos'

const mapStateToProps = (state) => {
    return {
        currentViewingDay: state.todos.viewing,
        dragging: state.todos.dragging,
        hovering: state.todos.hoveringOnActionPane,
        userHasSelectedTodos: state.todos.selected.length > 0,
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        deleteSelectedTodos: () => dispatch(deleteSelectedTodos()),
        moveSelectedTodos: () => dispatch(moveSelectedTodos()),
        completeSelectedTodos: () => dispatch(completeSelectedTodos()),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ActionPane)
