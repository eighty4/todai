import React from 'react'
import {Provider} from 'react-redux'
import store from './state'
import DayPan from './DayPanContainer'
import TodosBootstrapContainer from './TodosBootstrapContainer'
import DayViewContainer from './day/DayViewContainer'
import MenuButton from './menu/MenuButton'

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
                    <MenuButton/>
                </TodosBootstrapContainer>
            </Provider>
        )
    }

}
