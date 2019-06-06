import React from 'react'
import PropTypes from 'prop-types';
import {View, Text, StyleSheet, TouchableOpacity} from 'react-native'
import Todos from './Todos'
import {getWindowDimensions} from "./Util";

const dayData = {
    today: {
        label: 'Today',
        button: '>',
        todos: ['Yoga', 'Fix tub', 'Clean bathroom']
    },
    tomorrow: {
        label: 'Tomorrow',
        button: '<',
        todos: ['Run'],
    },
}

const styles = StyleSheet.create({
    container: {
        display: 'flex',
        flexDirection: 'row'
    },
    spacer: {
        width: 20,
    },
})

const thisDayStyles = StyleSheet.create({
    container: {
        paddingTop: 70,
        flex: 1,
    },
    label: {
        fontSize: 45,
        fontWeight: "bold",
        paddingLeft: 20,
    },
    divider: {
        paddingTop: 5,
        borderBottomColor: 'black',
        borderBottomWidth: 1,
    },
})

const otherDayStyles = StyleSheet.create({
    container: {
        width: '15%',
        display: 'flex',
        justifyContent: 'center',
    },
    button: {
        borderRadius: 5,
        width: 50,
        height: 50,
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: 'black',
        borderWidth: 1,
    },
    buttonText: {
        textAlign: 'center',
        color: 'black',
        fontSize: 20,
    }
})

const DayView = props => {

    const spacer = <View key="spacer" style={styles.spacer}/>

    const thisDay = <View key="this-day" style={thisDayStyles.container}>
        <Text style={thisDayStyles.label}>{dayData[props.day].label}</Text>
        <View style={thisDayStyles.divider}/>
        <Todos todos={dayData[props.day].todos}/>
    </View>

    const otherDayStylesToUse = {
        ...otherDayStyles.container,
        alignItems: props.day === 'today' ? 'flex-start' : 'flex-end'
    }

    const otherDay = <View key="other-day" style={otherDayStylesToUse}>
        <TouchableOpacity style={otherDayStyles.button} onPress={props.onPanButtonPress}>
            <Text style={otherDayStyles.buttonText}>{dayData[props.day].button}</Text>
        </TouchableOpacity>
    </View>

    const {height, width} = getWindowDimensions()
    return (
        <View style={{...styles.container, height, width}}>
            {props.day === 'today' ? [spacer, thisDay, otherDay] : [otherDay, thisDay, spacer]}
        </View>
    )
}

DayView.propTypes = {
    day: PropTypes.oneOf(['today', 'tomorrow']),
    onPanButtonPress: PropTypes.func.isRequired,
}

export const TodayView = props => <DayView {...{...props, day: 'today'}}/>

export const TomorrowView = props => <DayView {...{...props, day: 'tomorrow'}}/>
