import React from 'react'
import {Animated, Dimensions, StyleSheet, TouchableOpacity, View} from 'react-native'
import PropTypes from 'prop-types'

const styles = StyleSheet.create({
    parentOuterContainer: {
        position: 'absolute',
        right: 16,
        bottom: 16,
        backgroundColor: 'skyblue',
        zIndex: 100,
    },
    innerContainer: {
        width: '100%',
        height: '100%',
    },
    nestedOuterContainer: {
        position: 'absolute',
        backgroundColor: 'red',
    },
})

class NestedMenuButton extends React.PureComponent {

    static propTypes = {
        ...MenuButton.propTypes,
        index: PropTypes.number.isRequired,
        open: PropTypes.bool.isRequired,
        color: PropTypes.string.isRequired,
    }

    animatedY = new Animated.Value(0)

    render() {
        const width = Dimensions.get('window').width
        const buttonSize = width * .15
        const positionOffset = ((width * .2 - buttonSize)) / 2
        const outerContainerStyles = {
            ...styles.nestedOuterContainer,
            width: buttonSize,
            height: buttonSize,
            borderRadius: buttonSize * .5,
            right: positionOffset + 16,
            bottom: positionOffset + 16,
            backgroundColor: this.props.color,
            transform: [{
                translateY: this.animatedY,
            }],
        }
        Animated.timing(this.animatedY, {
            toValue: this.props.open ? -this.props.index * width * .2 : 0,
            duration: 250,
            useNativeDriver: true,
        }).start()
        return (
            <Animated.View style={outerContainerStyles}>
                <TouchableOpacity>
                    <View style={styles.innerContainer}>

                    </View>
                </TouchableOpacity>
            </Animated.View>
        )
    }
}

class MenuButton extends React.PureComponent {

    static propTypes = {
        onMenuButtonPress: PropTypes.func.isRequired,
    }

    render() {
        const buttonSize = Dimensions.get('window').width * .2
        const dimensionStyles = {
            width: buttonSize,
            height: buttonSize,
            borderRadius: buttonSize * .5,
        }
        return (
            <View style={[styles.parentOuterContainer, dimensionStyles]}>
                <TouchableOpacity onPress={this.props.onMenuButtonPress}>
                    <View style={styles.innerContainer}/>
                </TouchableOpacity>
            </View>
        )
    }
}

export default class Menu extends React.Component {

    state = {
        open: false
    }

    onMenuButtonPress = () => {
        this.setState({open: !this.state.open})
    }

    render() {
        return (
            <View>
                <MenuButton onMenuButtonPress={this.onMenuButtonPress}/>
                <NestedMenuButton index={3} color="red" open={this.state.open} onMenuButtonPress={() => {}}/>
                <NestedMenuButton index={2} color="orange" open={this.state.open} onMenuButtonPress={() => {}}/>
                <NestedMenuButton index={1} color="green" open={this.state.open} onMenuButtonPress={() => {}}/>
            </View>
        )
    }
}
