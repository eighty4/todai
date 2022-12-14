import React from 'react'
import PropTypes from 'prop-types'
import {StyleSheet, TextInput, View} from 'react-native'

const styles = StyleSheet.create({
    container: {
        borderBottomColor: 'darkgrey',
        borderBottomWidth: StyleSheet.hairlineWidth,
        marginBottom: 10,
    },
    input: {
        fontSize: 20,
        fontStyle: 'italic',
        paddingVertical: 10,
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
        if (this.state.text.length > 0) {
            this.props.addTodo(e.nativeEvent.text)
            this.setState({text: ''})
        }
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
                           value={this.state.text}
                />
            </View>
        )
    }
}

TodoInput.propTypes = {
    addTodo: PropTypes.func.isRequired,
}

export default TodoInput
