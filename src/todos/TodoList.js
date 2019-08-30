import React from 'react'
import PropTypes from 'prop-types'
import {ScrollView, StyleSheet} from 'react-native'
import Todo from './Todo'
import TodoInput from '../input/TodoInputContainer'

const styles = StyleSheet.create({
    container: {
        paddingTop: 15,
        paddingVertical: 20,
    },
})

class TodoList extends React.PureComponent {

    render() {
        const scrollEnabled = false // todo check height of content to toggle on/off
        const containerStyles = [styles.container, {[this.props.day === 'today' ? 'paddingLeft' : 'paddingRight']: 20}]
        return (
            <ScrollView style={containerStyles} scrollEnabled={scrollEnabled}>
                {this.props.todos.map(this.renderTodo)}
                <TodoInput/>
            </ScrollView>
        )
    }

    renderTodo = (todo) => {
        return <Todo key={todo}
                     selected={this.props.selectedTodos.indexOf(todo) !== -1}
                     todo={todo}
                     day={this.props.day}
                     multiSelectActivated={this.props.multiSelectActivated}
                     selectTodo={this.props.selectTodo}
                     completeTodo={this.props.completeTodo}
                     deselectTodo={this.props.deselectTodo}
                     onDrag={this.props.dragTodo}
                     onActionPaneHover={this.props.hoverTodoOnActionPane}
                     moveSelectedTodos={this.props.moveSelectedTodos}
                     hoveringOnActionPane={this.props.hoveringOnActionPane}
        />
    }
}

TodoList.propTypes = {
    day: PropTypes.string.isRequired,
    todos: PropTypes.array.isRequired,
    selectedTodos: PropTypes.array.isRequired,
    selectTodo: PropTypes.func.isRequired,
    completeTodo: PropTypes.func.isRequired,
    deselectTodo: PropTypes.func.isRequired,
    dragTodo: PropTypes.func.isRequired,
    hoverTodoOnActionPane: PropTypes.func.isRequired,
    moveSelectedTodos: PropTypes.func.isRequired,
    hoveringOnActionPane: PropTypes.bool.isRequired,
    multiSelectActivated: PropTypes.bool.isRequired,
}

export default TodoList
