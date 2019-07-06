import React from 'react'
import PropTypes from 'prop-types';
import {View, Text, StyleSheet} from 'react-native'
import Todos from './Todos'

const styles = StyleSheet.create({
    container: {
        paddingTop: 70,
        width: '100%',
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
            <View style={{...styles.container}}>
                <Text style={styles.label}>{this.props.day === 'today' ? 'Today' : 'Tomorrow'}</Text>
                <View style={styles.divider}/>
                <Todos day={this.props.day} todos={this.props.todos}/>
            </View>
        )
    }
}

DayView.propTypes = {
    day: PropTypes.oneOf(['today', 'tomorrow']),
    todos: PropTypes.array.isRequired,
}

export default DayView
