import React from 'react'
import {Provider} from 'react-redux'
import store from './state/store'
import DayPan from './DayPanContainer'
import TodosBootstrapContainer from './TodosBootstrapContainer'
import DayViewContainer from './day/DayViewContainer'

export default class TodaiApp extends React.PureComponent {

    render() {
        const days = {
            today: <DayViewContainer day="today"/>,
            tomorrow: <DayViewContainer day="tomorrow"/>,
        }
        return (
            <Provider store={store}>
                <TodosBootstrapContainer>
                    <DayPan {...days}/>
                </TodosBootstrapContainer>
            </Provider>
        )
    }

}
