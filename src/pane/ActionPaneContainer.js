import React from 'react'
import {connect} from 'react-redux'
import ActionPane from './ActionPane'
import {deleteTodo} from '../state/todos'

const mapStateToProps = (state) => {
    return {
        currentViewingDay: state.todos.viewing,
        dragging: state.todos.dragging,
        hovering: state.todos.hoveringOnActionPane,
    }
}

const mapDispatchToProps = (dispatch) => {
    return {
        deleteTodo: (day, todo) => dispatch(deleteTodo(todo)),
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(ActionPane)
