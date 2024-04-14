import React from 'react';
import ReactDOM from 'react-dom'
import { Provider } from 'react-redux'

import axios from "axios";
import { App } from "../app/App";
import store from '../app/store'
import { loadInitialData } from "../features/rulesets/rulesetsSlice";

axios.defaults.headers.common['Accept'] = 'application/json';
axios.defaults.baseURL = "/api"

store.dispatch(loadInitialData())

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
    document.body.appendChild(document.createElement('div')),
  )
})
