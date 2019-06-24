import React from 'react'
import PropTypes from 'prop-types'

class TodosBootstrap extends React.PureComponent {

    componentDidMount() {
        this.props.loadTodos()
    }

    render() {
        return (
            this.props.children
        )
    }
}

TodosBootstrap.propTypes = {
    loadTodos: PropTypes.func.isRequired,
}

export default TodosBootstrap
