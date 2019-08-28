import React from 'react'
import {connect} from 'react-redux'
import DayPan from './DayPan'
import {changeViewingDay} from './state/todos'

const mapStateToProps = () => ({})

const mapDispatchToProps = (dispatch) => ({
    changeViewingDay: () => dispatch(changeViewingDay())
})

export default connect(mapStateToProps, mapDispatchToProps)(DayPan)
