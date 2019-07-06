import React from 'react'
import PropTypes from 'prop-types'
import {StyleSheet, TextInput, View} from 'react-native'

const styles = StyleSheet.create({
    container: {
        borderBottomColor: 'darkgrey',
        borderBottomWidth: 1,
        marginRight: 20,
    },
    input: {
        fontSize: 20,
        fontStyle: 'italic',
        paddingBottom: 10,
        paddingTop: 10,
        zIndex: 200,
    },
})

class TodoInput extends React.Component {

    state = {
        open: false,
        text: '',
    }

    onChangeText = (text) => {
        this.setState({text})
    }

    onFocus = () => {
        this.setState({open: true})
    }

    onSubmitEditing = (e) => {
        this.props.addTodo(this.props.day, e.nativeEvent.text)
    }

    render() {
        return (
            <View style={styles.container}>
                <TextInput style={styles.input}
                           placeholder=" + Add a new todo"
                           underlineColorAndroid="transparent"
                           onChangeText={this.onChangeText}
                           onFocus={this.onFocus}
                           onSubmitEditing={this.onSubmitEditing}
                />
            </View>
        )
    }
}

TodoInput.propTypes = {
    day: PropTypes.string.isRequired,
    addTodo: PropTypes.func.isRequired,
}

export default TodoInput
