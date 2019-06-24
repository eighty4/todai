import React from 'react'
import {connect} from 'react-redux'
import DayView from './DayView'

const mapStateToProps = (state, props) => {
    return {
        todos: state.todos[props.day]
    }
}

export default connect(mapStateToProps)(DayView)
