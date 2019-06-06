import React from 'react'
import {ScrollView, Dimensions} from 'react-native'
import {TodayView, TomorrowView} from './DayView.js'

const width = Dimensions.get("window").width;

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
        console.log('onPan', destination)
        const x = destination === 'today' ? 0 : width + 1
        this.refs._scrollView.scrollTo({x, animated: true})
    }
}
