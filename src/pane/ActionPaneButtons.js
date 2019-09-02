import React from 'react'
import PropTypes from 'prop-types'
import {TouchableOpacity, StyleSheet, Dimensions} from 'react-native'
import {FontAwesomeIcon} from '@fortawesome/react-native-fontawesome'
import {faAngleLeft, faAngleRight, faTrashAlt, faExchangeAlt, faCheckDouble, faTimes} from '@fortawesome/free-solid-svg-icons'

const styles = StyleSheet.create({
    container: {
        justifyContent: 'center',
        alignItems: 'center',
        borderColor: 'black',
        borderWidth: StyleSheet.hairlineWidth,
        borderRadius: 3,
    },
    icon: {
        color: '#333',
    }
})

class ActionPaneButton extends React.PureComponent {

    onButtonPress = () => this.props.onPress()

    render() {
        const {height, width} = Dimensions.get('window')
        const backgroundColor = this.props.backgroundColor || 'white'
        const additionalContainerStyles = {backgroundColor, width: width * .125, height: height * .1}
        if (this.props.heightModifier) additionalContainerStyles.height = additionalContainerStyles.height * this.props.heightModifier
        return (
            <TouchableOpacity style={[styles.container, additionalContainerStyles]} onPress={this.onButtonPress}>
                <FontAwesomeIcon icon={this.props.icon} size={this.props.size || 22} style={styles.icon} color={this.props.color}/>
            </TouchableOpacity>
        )
    }
}

ActionPaneButton.propTypes = {
    onPress: PropTypes.func.isRequired,
    heightModifier: PropTypes.number,
    color: PropTypes.string,
    size: PropTypes.number,
    backgroundColor: PropTypes.string,
    icon: PropTypes.any.isRequired,
}

export class PanButton extends React.PureComponent {

    static propTypes = {
        onPress: PropTypes.func,
        day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    }

    static ICON = {
        today: faAngleRight,
        tomorrow: faAngleLeft,
    }

    render() {
        return (
            <ActionPaneButton icon={PanButton.ICON[this.props.day]} onPress={this.props.onPress}/>
        )
    }
}

export class DeleteButton extends React.PureComponent {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        return (
            <ActionPaneButton heightModifier={.75} onPress={this.props.onPress} backgroundColor="firebrick" icon={faTrashAlt}/>
        )
    }
}

export class MoveButton extends React.PureComponent {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        return (
            <ActionPaneButton heightModifier={.75} onPress={this.props.onPress} backgroundColor="skyblue" icon={faExchangeAlt}/>
        )
    }
}

export class CompleteButton extends React.PureComponent {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        return (
            <ActionPaneButton heightModifier={.75} onPress={this.props.onPress} backgroundColor="forestgreen" icon={faCheckDouble}/>
        )
    }
}

export class DeselectButton extends React.PureComponent {

    static propTypes = {
        onPress: PropTypes.func.isRequired,
    }

    render() {
        return (
            <ActionPaneButton heightModifier={.75} onPress={this.props.onPress} color="firebrick" icon={faTimes} size={30}/>
        )
    }
}
