import React from 'react'
import PropTypes from 'prop-types'
import {
    Animated,
    Text,
    StyleSheet,
    PanResponder,
    Dimensions,
} from 'react-native'

const styles = StyleSheet.create({
    container: {
        marginBottom: 10,
        padding: 10,
    },
    text: {
        fontSize: 24,
    },
})

class Todo extends React.Component {

    state = {
        selected: false,
    }

    longPressTimer = null

    panResponder = PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onPanResponderGrant: (e, g) => {
            console.log('grant')
            // this.props.deleteTodo(this.props.day, this.props.todo)

            if (this.state.selected || this.props.multiSelectActivated) {
                this.toggleSelection()
            } else {
                this.longPressTimer = setTimeout(() => {
                    this.setState({selected: true})
                    this.props.onSelection()
                    this.clearLongPressTimer()
                }, 500)
            }
        },
        onPanResponderMove: (e, g) => {
            if (this.longPressTimer) {
                if (g.moveX < this.state.x
                    || g.moveX > (this.state.x + this.state.width)
                    || g.moveY < this.state.y
                    || g.moveY > (this.state.y + this.state.height)) {
                    console.log('moved out of container, aborting')
                    this.clearLongPressTimer()
                }
            }
        },
        onPanResponderRelease: (e, g) => {
            if (this.state.selected) {
                const {width} = Dimensions.get('window')
                if (this.props.day === 'today') {
                    if (width * .8 < g.moveX) {
                        console.log('dropped on right edge')
                    }
                } else {
                    if (width * .2 > g.moveX) {
                        console.log('dropped on left edge')
                    }
                }
            } else {
                this.clearLongPressTimer()
            }
        },
        onPanResponderTerminationRequest: () => false
    })

    toggleSelection = () => {
        this.state.selected ? this.props.onDeselection() : this.props.onSelection()
        this.setState({selected: !this.state.selected})
    }

    clearLongPressTimer = () => {
        if (this.longPressTimer) {
            clearTimeout(this.longPressTimer)
            this.longPressTimer = null
        }
    }

    onLayout = (e) => {
        const {x, y, height, width} = e.nativeEvent.layout
        this.setState({x, y, height, width})
    }

    componentWillUnmount() {
        this.clearLongPressTimer()
    }

    render() {
        const containerStyles = [styles.container, {backgroundColor: this.state.selected ? 'skyblue' : 'rebeccapurple'}]
        return (
            <Animated.View style={containerStyles} {...this.panResponder.panHandlers} onLayout={this.onLayout}>
                <Text style={styles.text}>{this.props.todo}</Text>
            </Animated.View>
        )
    }
}

Todo.propTypes = {
    todo: PropTypes.string.isRequired,
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    multiSelectActivated: PropTypes.bool.isRequired,
    onSelection: PropTypes.func.isRequired,
    onDeselection: PropTypes.func.isRequired,
    deleteTodo: PropTypes.func.isRequired,
}

export default Todo
