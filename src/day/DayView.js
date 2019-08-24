import React from 'react'
import PropTypes from 'prop-types'
import {View, Text, StyleSheet, TouchableWithoutFeedback, Keyboard} from 'react-native'
import TodoList from '../todos/TodoListContainer'

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
        borderBottomWidth: 1,
    },
})

class DayView extends React.PureComponent {

    render() {
        return (
            <TouchableWithoutFeedback onPress={Keyboard.dismiss}>
                <View style={styles.container}>
                    <Text style={styles.label}>{this.props.day === 'today' ? 'Today' : 'Tomorrow'}</Text>
                    <View style={styles.divider}/>
                    <TodoList day={this.props.day} todos={this.props.todos}/>
                </View>
            </TouchableWithoutFeedback>
        )
    }
}

DayView.propTypes = {
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    todos: PropTypes.array.isRequired,
}

export default DayView
