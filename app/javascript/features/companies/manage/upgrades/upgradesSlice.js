import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, upsertSquads } from "../units/squadsSlice";

const upgradesAdapter = createEntityAdapter()
const initialState = upgradesAdapter.getInitialState({})

const upgradesSlice = createSlice({
  name: "upgrades",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        upgradesAdapter.setAll(state, action.payload.upgrades)
      })
  }
})

export default upgradesSlice.reducer
export const {
  selectAll: selectAllUpgrades,
  selectById: selectUpgradeById
} = upgradesAdapter.getSelectors(state => state.upgrades)
