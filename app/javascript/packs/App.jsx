import React from 'react';
import Player from "../components/Player";
import { render } from "react-dom";
import axios from "axios";
import DoctrineList from "../components/DoctrineList";
import CompanyForm from "../components/CompanyForm";

axios.defaults.headers.common['Accept'] = 'application/json';

const App = () => (
    <div>
        OMGMOD
        <Player />

        <br />
        <CompanyForm />
        <br/>
        <DoctrineList />
    </div>
)

document.addEventListener('DOMContentLoaded', () => {
    render(
        <App />,
        document.body.appendChild(document.createElement('div')),
    )
})