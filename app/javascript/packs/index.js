import React from 'react';
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import axios from "axios";
import { App } from "../app/App";
import store from '../app/store'
import { fetchPlayer } from "../features/player/playerSlice";
import { fetchCompanies } from "../features/companies/companiesSlice";

axios.defaults.headers.common['Accept'] = 'application/json';

store.dispatch(fetchPlayer())
store.dispatch(fetchCompanies())

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
    document.body.appendChild(document.createElement('div')),
  )
})