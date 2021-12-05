import React from 'react';
import Player from "../components/Player";
import { render } from "react-dom";
import axios from "axios";

axios.defaults.headers.common['Accept'] = 'application/json';

const App = () => (
    <div>
        OMGMOD
        <Player />
    </div>
)

document.addEventListener('DOMContentLoaded', () => {
    render(
        <App />,
        document.body.appendChild(document.createElement('div')),
    )
})