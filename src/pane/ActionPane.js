import React from 'react'
import PropTypes from 'prop-types'
import {StyleSheet, TouchableOpacity, Dimensions, Keyboard} from 'react-native'
import {DeleteButton, PanButton, MoveButton, CompleteButton, DeselectButton} from './ActionPaneButtons'

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
                {this.getActionPaneButtons()}
            </TouchableOpacity>
        )
    }

    getActionPaneButtons() {
        if (this.props.dragging) {
            return <MoveButton key="move" onPress={this.props.moveSelectedTodos}/>
        } else if (!this.props.userHasSelectedTodos) {
            return <PanButton onPress={this.onPanePress} day={this.props.currentViewingDay}/>
        } else {
            return [
                <DeleteButton key="delete" onPress={this.props.deleteSelectedTodos}/>,
                <MoveButton key="move" onPress={this.props.moveSelectedTodos}/>,
                <CompleteButton key="confirm" onPress={this.props.completeSelectedTodos}/>,
                <DeselectButton key="deselect" onPress={this.props.deselectSelectedTodos}/>,
            ]
        }
    }
}

ActionPane.propTypes = {
    deleteSelectedTodos: PropTypes.func.isRequired,
    moveSelectedTodos: PropTypes.func.isRequired,
    completeSelectedTodos: PropTypes.func.isRequired,
    onPan: PropTypes.func.isRequired,
    currentViewingDay: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    dragging: PropTypes.bool.isRequired,
    hovering: PropTypes.bool.isRequired,
    userHasSelectedTodos: PropTypes.bool.isRequired,
}

export default ActionPane
