import React from 'react'
import {connect} from 'react-redux'
import TodoInput from './TodoInput'

const mapStateToProps = () => {
    return {}
}

const mapDispatchToProps = () => {
    return {
        onTodoCreated: () => {},
    }
}

export default connect(mapStateToProps, mapDispatchToProps)(TodoInput)
