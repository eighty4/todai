import React from 'react'
import PropTypes from 'prop-types';
import {View, Text, Dimensions, StyleSheet, TouchableOpacity} from 'react-native'

const {width, height} = Dimensions.get("window");

const dayData = {
    today: {
        label: 'Today',
        button: '>',
    },
    tomorrow: {
        label: 'Tomorrow',
        button: '<',

    }
}

const styles = StyleSheet.create({
    container: {
        width,
        height,
        display: 'flex',
        flexDirection: 'row'
    },
    spacer: {
        width: 20
    }
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
    }
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

    const spacer = <View style={styles.spacer}/>

    const thisDay = <View style={thisDayStyles.container}>
        <Text style={thisDayStyles.label}>{dayData[props.day].label}</Text>
        <View style={thisDayStyles.divider}/>
    </View>

    const otherDayStylesToUse = {
        ...otherDayStyles.container,
        alignItems: props.day === 'today' ? 'flex-start' : 'flex-end'
    }

    const otherDay = <View style={otherDayStylesToUse}>
        <TouchableOpacity style={otherDayStyles.button} onPress={props.onPanButtonPress}>
            <Text style={otherDayStyles.buttonText}>{dayData[props.day].button}</Text>
        </TouchableOpacity>
    </View>

    if (props.day === 'today') {
        return (
            <View style={styles.container}>
                {spacer}
                {thisDay}
                {otherDay}
            </View>
        )
    } else {
        return (
            <View style={styles.container}>
                {otherDay}
                {thisDay}
                {spacer}
            </View>
        )
    }
}

DayView.propTypes = {
    day: PropTypes.oneOf(['today', 'tomorrow']),
    onPanButtonPress: PropTypes.func.isRequired,
}

export const TodayView = props => <DayView {...{...props, day: 'today'}}/>

export const TomorrowView = props => <DayView {...{...props, day: 'tomorrow'}}/>
