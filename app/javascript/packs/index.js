import React from 'react';
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import axios from "axios";
import { App } from "../app/App";
import store from '../app/store'
import { fetchPlayer } from "../features/player/playerSlice";
import { fetchCompanies } from "../features/companies/companiesSlice";
import { fetchDoctrines } from "../features/doctrines/doctrinesSlice";

axios.defaults.headers.common['Accept'] = 'application/json';
axios.defaults.baseURL = "/api"

store.dispatch(fetchPlayer())
store.dispatch(fetchCompanies())
store.dispatch(fetchDoctrines())

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
    document.body.appendChild(document.createElement('div')),
  )
})
