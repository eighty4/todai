import React from 'react'
import PropTypes from 'prop-types'
import {StyleSheet, TouchableOpacity, Dimensions, Keyboard} from 'react-native'
import {DeleteButton, PanButton, MultiMoveButton, ConfirmButton} from "./ActionPaneButtons";

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
                <PanButton onPress={this.onPanePress} day={this.props.currentViewingDay}/>
                {/*<DeleteButton onPress={this.props.deleteTodo}/>*/}
                {/*<MultiMoveButton onPress={this.props.deleteTodo}/>*/}
                {/*<ConfirmButton onPress={this.props.deleteTodo}/>*/}
            </TouchableOpacity>
        )
    }
}

ActionPane.propTypes = {
    deleteTodo: PropTypes.func.isRequired,
    onPan: PropTypes.func.isRequired,
    currentViewingDay: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    dragging: PropTypes.bool.isRequired,
    hovering: PropTypes.bool.isRequired,
}

export default ActionPane
