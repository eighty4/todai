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
        return (
            <TouchableOpacity style={{...styles.container, height}} onPress={this.onPanePress}>
                <ActionPaneButton onPress={this.onPanePress}/>
            </TouchableOpacity>
        )
    }
}

ActionPane.propTypes = {
    onPan: PropTypes.func.isRequired,
}

export default ActionPane
