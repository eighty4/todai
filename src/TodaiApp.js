import React from 'react'
import {ScrollView} from 'react-native'
import {TodayView, TomorrowView} from './DayView.js'
import {getWindowWidth} from "./Util";

export default class TodaiApp extends React.Component {

    render() {
        return (
            <ScrollView horizontal pagingEnabled ref="_scrollView">
                <TodayView onPanButtonPress={this.onPan.bind(this, 'tomorrow')}/>
                <TomorrowView onPanButtonPress={this.onPan.bind(this, 'today')}/>
            </ScrollView>
        )
    }

    onPan(destination) {
        const x = destination === 'today' ? 0 : getWindowWidth() + 1
        this.refs._scrollView.scrollTo({x, animated: true})
    }
}
