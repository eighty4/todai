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
        dragging: false,
    }

    longPressTimer = null

    panResponder = PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onPanResponderGrant: (e, g) => {
            // this.props.deleteTodo(this.props.day, this.props.todo)

            if (this.state.selected || this.props.multiSelectActivated) {
                this.toggleSelection()
            } else {
                this.longPressTimer = setTimeout(() => {
                    this.setState({selected: true, dragging: true})
                    this.props.onSelection()
                    this.props.onDrag()
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
            if (this.state.dragging && this.isHoveringOverActionPaneBounds(g.moveX) !== this.props.hoveringOnActionPane) {
                this.props.onActionPaneHover(!this.props.hoveringOnActionPane)
            }
        },
        onPanResponderRelease: (e, g) => {
            if (this.state.selected && this.isHoveringOverActionPaneBounds(g.moveX)) {
                this.props.onActionPaneDrop(this.props.day, this.props.todo)
            } else if (this.state.selected) {
                this.props.onDrag(false)
                this.props.onDeselection()
                this.setState({dragging: false})
            } else {
                this.clearLongPressTimer()
            }
        },
        onPanResponderTerminationRequest: () => false
    })

    isHoveringOverActionPaneBounds = (x) => {
        const {width} = Dimensions.get('window')
        if (this.props.day === 'today') {
            return width * .8 < x
        } else {
            return width * .2 > x
        }
    }

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
    onDrag: PropTypes.func.isRequired,
    onActionPaneHover: PropTypes.func.isRequired,
    onActionPaneDrop: PropTypes.func.isRequired,
    hoveringOnActionPane: PropTypes.bool.isRequired,
}

export default Todo
