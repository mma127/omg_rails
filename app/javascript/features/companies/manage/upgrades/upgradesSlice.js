import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, fetchSnapshotCompanySquads, upsertSquads } from "../units/squadsSlice";
import { fetchStatsUnit } from "../../../stats/units/statsUnitsSlice";

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
      .addCase(fetchSnapshotCompanySquads.fulfilled, (state, action) => {
        upgradesAdapter.setAll(state, action.payload.upgrades)
      })

      .addCase(fetchStatsUnit.fulfilled, (state, action) => {
        upgradesAdapter.addMany(state, action.payload.enabledUpgrades.map(eu => eu.upgrade));
      })
  }
})

export default upgradesSlice.reducer
export const {
  selectAll: selectAllUpgrades,
  selectById: selectUpgradeById
} = upgradesAdapter.getSelectors(state => state.upgrades)
