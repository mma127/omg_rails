import { createAsyncThunk, createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import axios from "axios"
import { fetchDoctrines } from "../doctrines/doctrinesSlice";
import { fetchPlayer } from "../player/playerSlice";
import { fetchActiveCompanies } from "../companies/companiesSlice";

const rulesetsAdapter = createEntityAdapter()

const initialState = rulesetsAdapter.getInitialState({
  activeRuleset: null
})

export const fetchRulesets = createAsyncThunk("rulesets/fetchRulesets", async (rulesetType) => {
  const response = await axios.get(`/rulesets?type=${rulesetType}`)
  return response.data
})

export const fetchActiveRuleset = createAsyncThunk("rulesets/fetchActiveRuleset", async (rulesetType) => {
  const response = await axios.get(`/rulesets/active?type=${rulesetType}`)
  return response.data
})

export const loadInitialData = () => async (dispatch, getState) => {
  await dispatch(fetchActiveRuleset("war"))
  dispatch(fetchDoctrines())
  dispatch(fetchPlayer())

  const state = getState()

  const activeRuleset = selectActiveRuleset(state)
  dispatch(fetchActiveCompanies(activeRuleset.id))
}

const rulesetsSlice = createSlice({
  name: "rulesets",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchRulesets.fulfilled, (state, action) => {
        rulesetsAdapter.setAll(state, action.payload)
      })
      .addCase(fetchActiveRuleset.fulfilled, (state, action) => {
        state.activeRuleset = action.payload
      })
  }
})

export default rulesetsSlice.reducer

export const {
  selectAll: selectAllRulesets,
  selectById: selectRulesetById
} = rulesetsAdapter.getSelectors(state => state.rulesets)

export const selectActiveRuleset = state => state.rulesets.activeRuleset
