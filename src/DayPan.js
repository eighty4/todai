import React from 'react'
import PropTypes from 'prop-types'
import {Animated, View, PanResponder, StyleSheet, Dimensions, Keyboard} from 'react-native'
import ActionPane from './pane/ActionPaneContainer'

const styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
    },
})

class DayPan extends React.PureComponent {

    static TODAY = 0

    static TOMORROW = 1

    static SWIPE_FROM_MARGIN = 0.8

    static SWIPE_DISTANCE_THRESHOLD = 0.2

    constructor(props, context) {
        super(props, context)
        this.animatedX = new Animated.Value(0)
        this.state = {
            day: DayPan.TODAY,
        }
    }

    static xSwipeMargin(width) {
        return Math.floor(width * DayPan.SWIPE_FROM_MARGIN)
    }

    panResponder = PanResponder.create({
        onMoveShouldSetPanResponder: (e, g) => {
            const {width} = Dimensions.get('window')
            switch (this.state.day) {
                case DayPan.TODAY:
                    return g.dx < 0 && e.nativeEvent.pageX > width - DayPan.xSwipeMargin(width)
                case DayPan.TOMORROW:
                    return g.dx > 0 && e.nativeEvent.pageX < DayPan.xSwipeMargin(width)
            }
        },
        onPanResponderMove: (e, g) => {
            const width = Dimensions.get('window').width
            switch (this.state.day) {
                case DayPan.TODAY:
                    this.animatedX.setValue(g.moveX - g.x0)
                    break
                case DayPan.TOMORROW:
                    this.animatedX.setValue(g.moveX - g.x0 - width * .8)
                    break
            }
        },
        onPanResponderRelease: (e, g) => {
            const {width} = Dimensions.get('window')
            if (Math.abs(g.dx) > width * DayPan.SWIPE_DISTANCE_THRESHOLD) {
                this.toggleDay()
            } else {
                this.animateDayTransition(this.state.day)
            }
        },
    })

    toggleDay() {
        this.animateDayTransition(Math.abs(this.state.day - 1))
        this.props.changeViewingDay()
    }

    animateDayTransition(day) {
        Keyboard.dismiss()
        const toValue = day === DayPan.TODAY ? 0 : Dimensions.get('window').width * -.8
        const stateChangeCallback = day === this.state.day ? undefined : () => {
            this.setState({day: Math.abs(this.state.day - 1)})
        }
        Animated.timing(this.animatedX, {
            toValue,
            duration: 250,
            useNativeDriver: true,
        }).start(stateChangeCallback)
    }

    onManualPan = () => this.toggleDay()

    render() {
        const {width, height} = Dimensions.get('window')
        const animatedViewStyles = {
            ...styles.container,
            height,
            width: width * 1.8,
            transform: [{
                translateX: this.animatedX,
            }]
        }
        return (
            <Animated.View style={animatedViewStyles} {...this.panResponder.panHandlers}>
                <View style={{height, width: width * .8}}>
                    {this.props.today}
                </View>
                <View style={{height, width: width * .2}}>
                    <ActionPane onPan={this.onManualPan}/>
                </View>
                <View style={{height, width: width * .8}}>
                    {this.props.tomorrow}
                </View>
            </Animated.View>
        )
    }
}

DayPan.propTypes = {
    today: PropTypes.any.isRequired,
    tomorrow: PropTypes.any.isRequired,
}

export default DayPan
