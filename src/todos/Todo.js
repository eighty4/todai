import React from 'react'
import PropTypes from 'prop-types'
import {
    Animated,
    Text,
    StyleSheet,
    PanResponder,
    Dimensions,
} from 'react-native'
import {CheckBox} from 'react-native-elements'

const styles = StyleSheet.create({
    container: {
        marginBottom: 10,
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'flex-start',
    },
    text: {
        fontSize: 24,
    },
    checkBoxContainer: {
        marginHorizontal: 0,
    }
})

class Todo extends React.Component {

    state = {
        selecting: false,
        dragging: false,
    }

    longPressTimer = null

    panResponder = PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onPanResponderGrant: (e, g) => {
            this.setState({selecting: true})
            if (this.props.selected || this.props.multiSelectActivated) {
                this.toggleSelection()
            } else {
                this.longPressTimer = setTimeout(() => {
                    this.setState({dragging: true})
                    this.props.selectTodo(this.props.todo)
                    this.props.onDrag()
                    this.clearLongPressTimer()
                }, 300)
            }
        },
        onPanResponderMove: (e, g) => {
            if (this.longPressTimer && this.isOverTodo(g.moveX, g.moveY)) {
                this.clearLongPressTimer()
            }
            if (this.state.dragging && this.isOverActionPane(g.moveX) !== this.props.hoveringOnActionPane) {
                this.props.onActionPaneHover(!this.props.hoveringOnActionPane)
            }
        },

        onPanResponderRelease: (e, g) => {
            const stateChange = {selecting: false}
            if (this.props.selected && g.moveX !== 0 && this.isOverActionPane(g.moveX)) {
                this.props.moveSelectedTodos()
                stateChange.dragging = false
            } else if (this.state.selecting && this.props.selected) {
                this.props.onDrag(false)
                stateChange.dragging = false
            }  else if (this.props.selected) {
                this.props.deselectTodo(this.props.todo)
            } else {
                this.clearLongPressTimer()
            }
            this.setState(stateChange)
        },
        onPanResponderTerminationRequest: () => false
    })

    isOverActionPane = (x) => {
        const {width} = Dimensions.get('window')
        if (this.props.day === 'today') {
            return x > width * .8
        } else {
            console.log(`isOverActionPane: ${x} < ${width} * .2`)
            return x < width * .2
        }
    }

    isOverTodo = (x, y) => {
        return x < this.state.x || x > (this.state.x + this.state.width) || y < this.state.y || y > (this.state.y + this.state.height)
    }

    toggleSelection = () => {
        this.props.selected ? this.props.deselectTodo(this.props.todo) : this.props.selectTodo(this.props.todo)
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

    completeTodo = () => {
        this.props[this.props.completed ? 'undoCompleteTodo' : 'completeTodo'](this.props.todo)
    }

    render() {
        const containerStyles = [styles.container, {backgroundColor: this.props.selected ? 'skyblue' : 'rebeccapurple'}]
        return (
            <Animated.View style={containerStyles} {...this.panResponder.panHandlers} onLayout={this.onLayout}>
                <CheckBox checked={this.props.completed}
                          containerStyle={styles.checkBoxContainer}
                          size={28}
                          onPress={this.completeTodo}
                />
                <Text style={styles.text}>{this.props.todo.text}</Text>
            </Animated.View>
        )
    }
}

Todo.propTypes = {
    selected: PropTypes.bool.isRequired,
    completed: PropTypes.bool.isRequired,
    todo: PropTypes.object.isRequired,
    day: PropTypes.oneOf(['today', 'tomorrow']).isRequired,
    multiSelectActivated: PropTypes.bool.isRequired,
    selectTodo: PropTypes.func.isRequired,
    completeTodo: PropTypes.func.isRequired,
    undoCompleteTodo: PropTypes.func.isRequired,
    deselectTodo: PropTypes.func.isRequired,
    onDrag: PropTypes.func.isRequired,
    onActionPaneHover: PropTypes.func.isRequired,
    moveSelectedTodos: PropTypes.func.isRequired,
    hoveringOnActionPane: PropTypes.bool.isRequired,
}

export default Todo
