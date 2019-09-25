import MapView, { Marker, Polygon } from 'react-native-maps'
import React, {Fragment, Component} from 'react';
import {
  SafeAreaView,
} from 'react-native';

const randomColor = () => `rgb(${Math.random() * 256},${Math.random() * 256},${Math.random() * 256})`

const dLat = 0.000017
const dLon = 0.00008

const raise = (base, difference) => {
        const signModifier = base < 0 ? -1 : 1
        return signModifier * (Math.abs(base) + Math.abs(difference))
}

const makeBreedingPlotCoords = (bottomRight) => [
        bottomRight,
        {...bottomRight, longitude: raise(bottomRight.longitude, dLon)},
        {latitude: raise(bottomRight.latitude, dLat), longitude: raise(bottomRight.longitude, dLon)},
        {...bottomRight, latitude: raise(bottomRight.latitude, dLat)},
]

const makeField = (bottomRight, numRows, numCols, padSize) => {
        let plots = []

        for (let i=1; i<=numCols; i++) {
                const spaceDueToRowPadding = (i - 1) * padSize
                const spaceDueToRowOffset = i * dLon
                for (let ii=1; ii<=numRows; ii++) {
                        const spaceDueToColumnPadding = (ii - 1) * padSize
                        const spaceDueToColumnOffset = ii * dLat
                        let thisBottomRight = {
                                latitude: raise(raise(bottomRight.latitude, spaceDueToColumnOffset), spaceDueToColumnPadding),
                                longitude: raise(raise(bottomRight.longitude, spaceDueToRowOffset), spaceDueToRowPadding),
                        }

                        plots.push(makeBreedingPlotCoords(thisBottomRight))
                }
        }

        return plots
}

const renderField = (field) => {
        return field.map( (plot, index) => (
                <Polygon key={index} coordinates={plot} fillColor={randomColor()} strokeWidth={0.01}/>
        ) )
}

const myField = makeField({latitude: 38.789, longitude: -90.308}, 50, 50, 0.0000075)

const App = () => {
        return (
        <SafeAreaView style={{flex: 1}}>
                <MapView 
                        mapType='satellite'
                        style={{flex: 1}} 
                        region={{
                                latitude: 38.789025,
                                longitude: -90.30808,
                                latitudeDelta: Number.MIN_VALUE,
                                longitudeDelta: Number.MIN_VALUE,
                        }}>
                        {renderField(myField)}
                </MapView>
        </SafeAreaView>
        )
}

export default App;