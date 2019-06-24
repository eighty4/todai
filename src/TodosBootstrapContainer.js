import React from 'react'
import {connect} from 'react-redux'
import TodosBootstrap from './TodosBootstrap'
import {loadTodos} from './state/todos'

const mapStateToProps = () => ({})

const mapDispatchToProps = (dispatch) => ({
    loadTodos: () => dispatch(loadTodos())
})

export default connect(mapStateToProps, mapDispatchToProps)(TodosBootstrap)
