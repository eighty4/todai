import React from 'react'
import PropTypes from 'prop-types'
import {View, Text, ScrollView, StyleSheet} from 'react-native'
import TodoInputContainer from '../input/TodoInputContainer'

const styles = StyleSheet.create({
    container: {
        paddingLeft: 20,
        paddingTop: 15,
    },
    todo: {
        marginBottom: 10,
    },
    label: {
        fontSize: 20,
    },
})

class Todos extends React.PureComponent {

    static renderTodo(todo) {
        return (
            <View key={todo} style={styles.todo}>
                <Text style={styles.label}>{todo}</Text>
            </View>
        )
    }

    render() {
        const scrollEnabled = false // todo check height of content to toggle on/off
        return (
            <ScrollView style={styles.container} scrollEnabled={scrollEnabled}>
                {this.props.todos.map(Todos.renderTodo)}
                <TodoInputContainer/>
            </ScrollView>
        )
    }
}

Todos.propTypes = {
    todos: PropTypes.array.isRequired,
}

export default Todos
