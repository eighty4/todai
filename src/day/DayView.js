import React from 'react'
import PropTypes from 'prop-types'
import {Keyboard, ScrollView, StyleSheet, Text, TouchableWithoutFeedback, View, TouchableOpacity} from 'react-native'
import TodoInput from '../input/TodoInputContainer'
import Todo from '../todos/Todo'

const styles = StyleSheet.create({
    container: {
        paddingTop: 70,
        width: '100%',
        height: '100%',
    },
    spacer: {
        width: 20,
    },
    label: {
        fontSize: 45,
        fontWeight: 'bold',
        paddingLeft: 20,
    },
    divider: {
        paddingTop: 5,
        borderBottomColor: 'black',
        borderBottomWidth: StyleSheet.hairlineWidth,
    },
    scrollView: {
        paddingTop: 15,
        paddingVertical: 20,
    },
    displayCompletedToggle: {
        borderColor: '#444',
        borderWidth: StyleSheet.hairlineWidth,
        borderRadius: 3,
        marginHorizontal: 40,
        marginBottom: 15,
        marginTop: 5,
        fontSize: 16,
        color: '#444',
        backgroundColor: '#eee',
        textAlign: 'center',
        paddingVertical: 5,
    },
    congratsText: {
        color: 'skyblue',
        marginVertical: 60,
        textAlign: 'center',
        fontSize: 20,
    }
})

class DayView extends React.PureComponent {

    static LABEL_TEXT = {
        today: 'Today',
        tomorrow: 'Tomorrow',
    }

    toggleShowingCompletedTodos = () => {
        this.props.toggleShowingCompletedTodos()
    }

    render() {
        const scrollEnabled = false // todo check height of content to toggle on/off
        const scrollViewStyles = [styles.scrollView, {[this.props.day === 'today' ? 'paddingLeft' : 'paddingRight']: 20}]
        const labelText = DayView.LABEL_TEXT[this.props.day]
        return (
            <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                <View style={styles.container}>
                    <Text style={styles.label}>{labelText}</Text>
                    <View style={styles.divider}/>
                    <ScrollView style={scrollViewStyles} scrollEnabled={scrollEnabled}>
                        <TodoInput/>
                        {this.hasCompletedAllTodayTodos() && DayView.renderCongrats()}
                        {this.renderTodos(this.props.todos)}
                        {!!this.props.completedTodos.length && this.renderCompletedTodosToggle()}
                        {!this.props.hideCompletedTodos && this.renderTodos(this.props.completedTodos, true)}
                    </ScrollView>
                </View>
            </TouchableWithoutFeedback>
        )
    }

    hasCompletedAllTodayTodos() {
        return this.props.day === 'today' && this.props.todos.length === 0 && this.props.completedTodos.length > 0
    }

    static renderCongrats() {
        return <Text style={styles.congratsText}>
            Congrats, you're done!
        </Text>
    }

    renderTodos(todos, completed = false) {
        return todos.map(todo => <Todo key={todo.id}
                                       completed={completed}
                                       selected={this.props.selectedIds.indexOf(todo.id) !== -1}
                                       todo={todo}
                                       day={this.props.day}
                                       multiSelectActivated={this.props.multiSelectActivated}
                                       selectTodo={this.props.selectTodo}
                                       completeTodo={this.props.completeTodo}
                                       undoCompleteTodo={this.props.undoCompleteTodo}
                                       deselectTodo={this.props.deselectTodo}
                                       onDrag={this.props.dragTodo}
                                       onActionPaneHover={this.props.hoverTodoOnActionPane}
                                       moveSelectedTodos={this.props.moveSelectedTodos}
                                       hoveringOnActionPane={this.props.hoveringOnActionPane}
        />)
    }

    renderCompletedTodosToggle() {
        return (
            <TouchableOpacity onPress={this.toggleShowingCompletedTodos}>
                <Text style={styles.displayCompletedToggle}>
                    {this.props.completedTodos.length} Completed
                </Text>
            </TouchableOpacity>
        )
    }
}

DayView.propTypes = {
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    todos: PropTypes.array.isRequired,
    completedTodos: PropTypes.array.isRequired,
    selectedIds: PropTypes.array.isRequired,
    selectTodo: PropTypes.func.isRequired,
    completeTodo: PropTypes.func.isRequired,
    undoCompleteTodo: PropTypes.func.isRequired,
    deselectTodo: PropTypes.func.isRequired,
    dragTodo: PropTypes.func.isRequired,
    hoverTodoOnActionPane: PropTypes.func.isRequired,
    moveSelectedTodos: PropTypes.func.isRequired,
    hoveringOnActionPane: PropTypes.bool.isRequired,
    multiSelectActivated: PropTypes.bool.isRequired,
    hideCompletedTodos: PropTypes.bool.isRequired,
    toggleShowingCompletedTodos: PropTypes.func.isRequired,
}

export default DayView
