import React from 'react'
import PropTypes from 'prop-types'
import {StyleSheet, TouchableOpacity, Dimensions, Keyboard} from 'react-native'
import ActionPaneButton from './ActionPaneButton'

const styles = StyleSheet.create({
    container: {
        alignItems: 'center',
        justifyContent: 'center',
    },
})

class ActionPane extends React.PureComponent {

    onPanePress = () => {
        Keyboard.dismiss()
        this.props.onPan()
    }

    render() {
        const {height} = Dimensions.get('window')
        const containerStyles = [styles.container, {height}]
        if (this.props.dragging) containerStyles.push({backgroundColor: 'lemonchiffon'})
        if (this.props.hovering) containerStyles.push({backgroundColor: 'limegreen'})
        return (
            <TouchableOpacity style={containerStyles} onPress={this.onPanePress}>
                <ActionPaneButton onPress={this.onPanePress} day={this.props.day}/>
            </TouchableOpacity>
        )
    }
}

ActionPane.propTypes = {
    onPan: PropTypes.func.isRequired,
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    dragging: PropTypes.bool.isRequired,
    hovering: PropTypes.bool.isRequired,
}

export default ActionPane
