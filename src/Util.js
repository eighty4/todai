import {Dimensions} from 'react-native'

export const getWindowDimensions = () => Dimensions.get('window')

export const getWindowWidth = () => getWindowDimensions().width
