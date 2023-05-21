import { createEntityAdapter, createSlice } from "@reduxjs/toolkit";
import { fetchCompanySquads, upsertSquads } from "../units/squadsSlice";

const availableUpgradesAdapter = createEntityAdapter()
const initialState = availableUpgradesAdapter.getInitialState({})

const availableUpgradesSlice = createSlice({
  name: "availableUpgrades",
  initialState,
  reducers: {},
  extraReducers(builder) {
    builder
      .addCase(fetchCompanySquads.fulfilled, (state, action) => {
        availableUpgradesAdapter.setAll(state, action.payload.availableUpgrades)
      })
  }
})

export default availableUpgradesSlice.reducer

export const {
  selectAll: selectAllAvailableUpgrades,
  selectById: selectAvailableUpgradeById
} = availableUpgradesAdapter.getSelectors(state => state.availableUpgrades)

export const selectAvailableUpgradesByUnitId = (state, unitId) => {
  if (!_.isNil(unitId)) {
    return _.values(state.availableUpgrades.entities).filter(element => element.unitId === unitId)
  }
  return []
}
