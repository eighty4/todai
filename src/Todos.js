import React from 'react'
import {View, Text, ScrollView, StyleSheet} from 'react-native'

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

const renderTodo = todo => <View key={todo} style={styles.todo}>
    <Text style={styles.label}>{todo}</Text>
</View>

export default props => {
    const scrollEnabled = false // check height of content to toggle on/off
    return (
        <ScrollView style={styles.container} scrollEnabled={scrollEnabled}>
            {props.todos.map(renderTodo)}
        </ScrollView>
    )
}
