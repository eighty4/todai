import React from 'react'
import PropTypes from 'prop-types'
import {View, TextInput, StyleSheet} from 'react-native'

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
    },
})

class TodoInput extends React.Component {

    onChangeText() {

    }

    render() {
        return (
            <View style={styles.container}>
                <TextInput style={styles.input}
                           placeholder=" + Add a new todo"
                           underlineColorAndroid="transparent"
                           onChangeText={() => {}}/>
            </View>
        )
    }
}

TodoInput.propTypes = {
    onTodoCreated: PropTypes.func.isRequired,
}

export default TodoInput
