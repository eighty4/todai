import React from 'react'
import PropTypes from 'prop-types'
import {TouchableOpacity, StyleSheet, Text, Dimensions} from 'react-native'

const styles = StyleSheet.create({
    container: {
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: 'black',
        borderWidth: StyleSheet.hairlineWidth,
        borderRadius: 3,
    },
})

class ActionPaneButton extends React.PureComponent {

    static BUTTON_TEXT = {
        today: '>',
        tomorrow: '<',
    }

    onButtonPress = () => this.props.onPress()

    render() {
        const {height, width} = Dimensions.get('window')
        const containerStyles = {
            ...styles.container,
            height: height * .1,
            width: width * .1,
        }
        return (
            <TouchableOpacity style={containerStyles} onPress={this.onButtonPress}>
                <Text>{ActionPaneButton.BUTTON_TEXT[this.props.day]}</Text>
            </TouchableOpacity>
        )
    }
}

ActionPaneButton.propTypes = {
    onPress: PropTypes.func.isRequired,
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
}

export default ActionPaneButton
