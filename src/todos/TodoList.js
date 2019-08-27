import React from 'react'
import PropTypes from 'prop-types'
import {ScrollView, StyleSheet} from 'react-native'
import Todo from './Todo'
import TodoInputContainer from '../input/TodoInputContainer'

const styles = StyleSheet.create({
    container: {
        paddingTop: 15,
        paddingVertical: 20,
    },
})

class TodoList extends React.PureComponent {

    state = {
        selectedQuantity: 0,
    }

    onTodoSelection = () => {
        this.setState({selectedQuantity: this.state.selectedQuantity + 1})
    }

    onTodoDeselection = () => {
        this.setState({selectedQuantity: this.state.selectedQuantity - 1})
    }

    render() {
        const scrollEnabled = false // todo check height of content to toggle on/off
        const containerStyles = {
            ...styles.container,
            [this.props.day === 'today' ? 'paddingLeft' : 'paddingRight']: 20,
        }
        return (
            <ScrollView style={containerStyles} scrollEnabled={scrollEnabled}>
                {this.props.todos.map(this.renderTodo)}
                <TodoInputContainer day={this.props.day}/>
            </ScrollView>
        )
    }

    renderTodo = (todo) => {
        return <Todo key={todo}
                     todo={todo}
                     day={this.props.day}
                     multiSelectActivated={!!this.state.selectedQuantity}
                     onSelection={this.onTodoSelection}
                     onDeselection={this.onTodoDeselection}
                     deleteTodo={this.props.deleteTodo}
                     onDrag={this.props.dragTodo}
                     onActionPaneHover={this.props.hoverTodoOnActionPane}
                     onActionPaneDrop={this.props.dropTodoOnActionPane}
                     hoveringOnActionPane={this.props.hoveringOnActionPane}
        />
    }
}

TodoList.propTypes = {
    day: PropTypes.string.isRequired,
    todos: PropTypes.array.isRequired,
    deleteTodo: PropTypes.func.isRequired,
    dragTodo: PropTypes.func.isRequired,
    hoverTodoOnActionPane: PropTypes.func.isRequired,
    dropTodoOnActionPane: PropTypes.func.isRequired,
    hoveringOnActionPane: PropTypes.bool.isRequired,
}

export default TodoList
