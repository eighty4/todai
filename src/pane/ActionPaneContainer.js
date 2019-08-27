import React from 'react'
import {connect} from 'react-redux'
import ActionPane from './ActionPane'

const mapStateToProps = (state) => {
    return {
        dragging: state.todos.dragging,
        hovering: state.todos.hoveringOnActionPane,
    }
}

export default connect(mapStateToProps)(ActionPane)
